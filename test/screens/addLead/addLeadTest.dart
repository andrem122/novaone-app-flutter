// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:novaone/api/api.dart';
import 'package:novaone/auth/auth.dart';
import 'package:http/http.dart' as http;
import 'package:novaone/models/models.dart';
import 'package:novaone/novaOneUrl.dart';
import 'package:novaone/screens/addObject/addObjectScreenLayout.dart';
import 'package:novaone/screens/addObject/bloc/add_object_bloc.dart';
import 'package:novaone/screens/leads/bloc/leads_screen_bloc.dart';
import 'package:novaone/screens/screens.dart';
import 'package:mockito/mockito.dart';
import 'package:novaone/testData.dart';
import 'package:novaone/utils/utils.dart';
import 'package:novaone/widgets/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:novaone/auth/objectStore.dart';
import 'mocks/addLeadTest.mocks.dart';
import 'package:bloc_test/bloc_test.dart';

/// Create Mock classes
class MockSharedPreferences extends Mock implements SharedPreferences {}

class MockBuildContext extends Mock implements BuildContext {}

class MockUserApiClient extends Mock implements UserApiClient {}

class MockAppointmentsApiClient extends Mock implements AppointmentsApiClient {}

class MockCompaniesApiClient extends Mock implements CompaniesApiClient {}

class MockLeadsScreenBloc extends MockBloc<LeadsScreenEvent, LeadsScreenState>
    implements LeadsScreenBloc {}

/// Create the mocks needed with custom stubs
///
/// Run "flutter pub run build_runner build" in terminal to generate the mocks below
@GenerateMocks([
  NavigatorObserver,
  ObjectStore,
  LeadsApiClient,
], customMocks: [
  MockSpec<NavigatorObserver>(
    returnNullOnMissingStub: true,
    as: #MockNavigatorObserverGen,
  ),
  MockSpec<LeadsApiClient>(
    returnNullOnMissingStub: true,
    as: #MockLeadsApiClientGen,
  ),
])
void main() {
  /// Blocs
  late LeadsScreenBloc mockleadsScreenBloc;
  late AddObjectBloc mockAddObjectBloc;

  /// Dependencies
  late Future<SharedPreferences> mockFuturePrefs;
  late LeadsApiClient mockLeadsApiClient;
  late UserApiClient
      mockUserApiClient; // Make the type [UserApiClient] instead of [MockUserApiClient] because the login screen on the next page needs it to be
  late ObjectStore
      mockObjectStore; // Make the type [ObjectStore] instead of [MockObjectStore] because the leads screen on the next page needs it to be when calling context.read<ObjectStore>()

  /// Creates and initialzes the blocs needed for the test widget
  _createBlocs() {
    mockleadsScreenBloc = LeadsScreenBloc(
        objectStore: mockObjectStore, leadsApiClient: mockLeadsApiClient);
    mockAddObjectBloc = AddObjectBloc(
      leadsApiClient: mockLeadsApiClient,
      appointmentsApiClient: MockAppointmentsApiClient(),
      companiesApiClient: MockCompaniesApiClient(),
    );

    /// Emit the appropriate state for the [BlocBuilder] so it can build the widget we want
    mockleadsScreenBloc.emit(
      LeadsScreenLoaded(listTableItems: allLeads, companies: [testCompany]),
    );
  }

  /// Creates and initializes the mocs needed for the blocs and for widgets
  _createMocks() {
    mockFuturePrefs = Future.value(MockSharedPreferences());
    mockUserApiClient = MockUserApiClient();
    mockLeadsApiClient = MockLeadsApiClientGen();
    mockObjectStore = MockObjectStore();
  }

  setUp(() {
    _createMocks();
    _createBlocs();
  });

  tearDown(() {
    mockleadsScreenBloc.close();
  });

  /// Creates the [BlocProvider]s needed for the [BlocBuilder]
  List<BlocProvider> _createBlocProviders() {
    return [
      BlocProvider<LeadsScreenBloc>.value(value: mockleadsScreenBloc),
      BlocProvider<AddObjectBloc>.value(value: mockAddObjectBloc),
    ];
  }

  /// Create our test widget
  /// Wrap with a media query because of [LayoutBuilder] that is used by
  /// [ResponsiveBuilder]
  Widget createTestWidget(MockNavigatorObserverGen observer) {
    return MediaQuery(
      data: new MediaQueryData(),
      child: MultiRepositoryProvider(
        providers: [
          RepositoryProvider.value(value: mockFuturePrefs),
          RepositoryProvider.value(value: mockUserApiClient),
          RepositoryProvider.value(value: mockLeadsApiClient),
          RepositoryProvider.value(value: mockObjectStore),
        ],
        child: MultiBlocProvider(
          providers: _createBlocProviders(),
          child: MaterialApp(
            navigatorObservers: [observer],
            home: LeadsScreen(),
          ),
        ),
      ),
    );
  }

  // group('LeadsScreenBloc', () {
  //   blocTest(
  //     'emits LeadsScreenLoading when LeadsScreenStart is added',
  //     build: () => LeadsScreenBloc(objectStore: MockObjectStore()),
  //     act: (LeadsScreenBloc bloc) => bloc.add(LeadsScreenStart()),
  //     expect: () => [LeadsScreenLoading()],
  //   );
  // });

  testWidgets('Test add lead screen', (WidgetTester tester) async {
    final mockNavigatorObserver = MockNavigatorObserverGen();
    final testWidget = createTestWidget(mockNavigatorObserver);

    /// We first get our leads to display
    when(mockObjectStore.getObjects<Lead>()).thenAnswer(
      (_) => Future.value(
        List.generate(15, (index) => testlead),
      ),
    );

    /// We then get our companies to initialize the company value for the add lead screen
    when(mockObjectStore.getObjects<Company>()).thenAnswer(
      (_) => Future.value(
        [testCompany],
      ),
    );

    /// When we submit our form with valid data, certain methods are called, which we have to stub
    when(mockObjectStore.getUser()).thenAnswer(
      (_) => Future.value(
        User.fromJson(
          json: jsonDecode(jsonUser),
        ),
      ),
    );

    when(mockObjectStore.getPassword())
        .thenAnswer((_) => Future.value(testPassword));

    when(
      mockLeadsApiClient.postToNovaOneApi(
          uri: NovaOneUrl.novaOneApiAddLead, parameters: testAddLeadParameters),
    ).thenAnswer(
      (_) => Future.value(
        http.Response(jsonSuccess, 200),
      ),
    );

    // Build our screen to test and trigger a frame.
    await tester.pumpWidget(testWidget);

    /// Wait for the bloc to finish its animation to build the widget after responding to a state
    await tester.pumpAndSettle();

    // Verify that we are on the leads screen
    expect(find.byType(LeadsScreen), findsOneWidget);

    // Tap the 'Add Lead' button and see if navigation to the add Lead screen occurs
    final addLeadButton = find.byKey(
      Key(Keys.instance.addLeadFloatingActionButton),
    );
    await tester.tap(addLeadButton);
    await tester.pumpAndSettle();

    /// Verify that a push event happened
    verify(mockNavigatorObserver.didPush(any, any));

    /// Verify the login screen is now showing
    expect(find.byType(AddObjectScreenLayout), findsOneWidget);

    /// Get text fields
    final nameTextField = find.byKey(Key(Keys.instance.addLeadName));
    final phoneTextField = find.byKey(Key(Keys.instance.addLeadPhone));
    final emailTextField = find.byKey(Key(Keys.instance.addLeadEmail));
    final companyDropDown = find.byKey(Key(Keys.instance.addLeadCompany));
    final renterBrandDropDown =
        find.byKey(Key(Keys.instance.addLeadRenterBrand));

    /// Get submit button
    final submitButton = find.byKey(Key(Keys.instance.addObjectButton));

    expect(nameTextField, findsOneWidget);
    expect(phoneTextField, findsOneWidget);
    expect(emailTextField, findsOneWidget);
    expect(companyDropDown, findsOneWidget);
    expect(renterBrandDropDown, findsOneWidget);
    expect(submitButton, findsOneWidget);

    /// Write the invalid data to the form first and try to submit
    await TestUtils.writeTextAndVerify(
        value: testAddLeadName, tester: tester, textFormField: nameTextField);
    await TestUtils.writeTextAndVerify(
        value: testAddLeadErrorPhone,
        tester: tester,
        textFormField: phoneTextField);
    await TestUtils.writeTextAndVerify(
        value: testAddLeadErrorEmail,
        tester: tester,
        textFormField: emailTextField);

    /// Tap the submit button to get form errors to appear
    await tester.tap(submitButton);
    await tester.pumpAndSettle();

    /// Verify errors have appeared on the form
    expect(find.text(ValueChecker.instance.phoneErrorMessage), findsOneWidget);
    expect(find.text(ValueChecker.instance.emailErrorMessage), findsOneWidget);

    /// Submit the valid form data this time
    await TestUtils.writeTextAndVerify(
        value: testAddLeadPhone, tester: tester, textFormField: phoneTextField);
    await TestUtils.writeTextAndVerify(
        value: testAddLeadEmail, tester: tester, textFormField: emailTextField);

    await tester.tap(submitButton);
    await tester.pumpAndSettle();

    /// Verify that a push event happened to the success screen
    verify(mockNavigatorObserver.didPush(any, any));

    /// Verify the success screen is now showing
    expect(find.byType(SuccessDisplay), findsOneWidget);
  });
}
