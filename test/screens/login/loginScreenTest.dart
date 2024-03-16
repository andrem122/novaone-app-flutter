// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:novaone/api/userApiClient.dart';
import 'package:novaone/auth/auth.dart';
import 'package:novaone/screens/login/bloc/login_bloc.dart';
import 'package:novaone/screens/screens.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:novaone/auth/objectStore.dart';

import 'mocks/loginScreenTest.mocks.dart';

/// Create Mock classes
class MockSharedPreferences extends Mock implements SharedPreferences {}

class MockBuildContext extends Mock implements BuildContext {}

class MockUserApiClient extends Mock implements UserApiClient {}

class MockObjectStore extends Mock implements ObjectStore {}

/// Create the mocks needed with custom stubs
///
/// Run "dart run build_runner build" in terminal to generate the mocks below
@GenerateMocks([
  NavigatorObserver,
], customMocks: [
  MockSpec<NavigatorObserver>(
    returnNullOnMissingStub: true,
    as: #MockNavigatorObserverGen,
  ),
])
void main() {
  /// Blocs
  late LoginBloc loginBloc;

  /// Dependencies
  late Future<SharedPreferences> mockFuturePrefs;
  late UserApiClient
      mockUserApiClient; // Make the type [UserApiClient] instead of [MockUserApiClient] because the login screen on the next page needs it to be
  late ObjectStore
      mockObjectStore; // Make the type [ObjectStore] instead of [MockObjectStore] because the login screen on the next page needs it to be

  /// Creates and initialzes the blocs needed for the test widget
  _createBlocs() {
    loginBloc = LoginBloc(
        futurePrefs: mockFuturePrefs,
        userApiClient: mockUserApiClient,
        objectStore: mockObjectStore);
  }

  /// Creates and initializes the mocs needed for the blocs and for widgets
  _createMocks() {
    mockFuturePrefs = Future.value(MockSharedPreferences());
    mockUserApiClient = MockUserApiClient();
    mockObjectStore = MockObjectStore();
  }

  setUp(() {
    _createMocks();
    _createBlocs();
  });

  tearDown(() {
    loginBloc.close();
  });

  /// Creates the [BlocProvider]s needed for the [BlocBuilder]
  List<BlocProvider> _createBlocProviders() {
    return [
      BlocProvider<LoginBloc>.value(value: loginBloc),
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
          RepositoryProvider.value(value: mockObjectStore),
        ],
        child: MaterialApp(
          navigatorObservers: [observer],
          home: MultiBlocProvider(
              providers: _createBlocProviders(), child: LoginScreenLayout()),
        ),
      ),
    );
  }

  testWidgets('Test login screen', (WidgetTester tester) async {
    final mockNavigatorObserver = MockNavigatorObserverGen();
    final testWidget = createTestWidget(mockNavigatorObserver);

    // Build our screen to test and trigger a frame.
    await tester.pumpWidget(testWidget);

    final loginButton = find.text('Login');

    // // Verify that our buttons below the slider exist
    expect(loginButton, findsOneWidget);

    // Tap the 'Login' button and see if navigation to the login screen occurs
    // await tester.tap(loginButton);
    // await tester.pumpAndSettle();

    // // TODO: Tap the sign up button to see if the sign up screen appears

    // /// Verify that a push event happened
    // verify(mockNavigatorObserver.didPush(any, any));

    // /// Verify the login screen is now showing
    // expect(find.byType(LoginScreenLayout), findsOneWidget);
  });
}
