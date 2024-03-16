import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:novaone/auth/objectStore.dart';
import 'package:novaone/controllers/navScreenController.dart';
import 'package:novaone/screens/addObject/bloc/add_object_bloc.dart';
import 'package:novaone/screens/addressAutocomplete/bloc/address_autocomplete_bloc.dart';
import 'package:novaone/screens/appointments/bloc/appointments_screen_bloc.dart';
import 'package:novaone/screens/companies/bloc/companies_screen_bloc.dart';
import 'package:novaone/screens/home/bloc/home_bloc.dart';
import 'package:novaone/screens/input/bloc/input_bloc.dart';
import 'package:novaone/screens/leads/bloc/leads_screen_bloc.dart';
import 'package:novaone/screens/listCompanies/bloc/list_companies_bloc.dart';
import 'package:novaone/screens/nav/bloc/nav_screen_bloc.dart';
import 'package:novaone/screens/settings/bloc/settings_bloc.dart';
import 'package:novaone/screens/splash/bloc/splash_screen_bloc.dart';
import 'package:novaone/screens/support/bloc/support_bloc.dart';
import 'package:novaone/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:novaone/api/api.dart';
import 'package:novaone/api/googlePlacesApiClient.dart';
import 'package:novaone/auth/auth.dart';
import 'package:novaone/screens/slider/bloc/slider_screen_bloc.dart';
import 'package:http/http.dart';
import 'package:uuid/uuid.dart';

/// The [RootWidget] contains all the blocs and instances used throughout the lifecycle of the app
class RootWidget extends StatefulWidget {
  const RootWidget({
    Key? key,
    required this.child,
    required this.database,
    this.onCreate,
    this.testing = false,
  }) : super(key: key);
  final Widget child;

  /// The local database instance
  final Database database;

  /// A boolean to indicate whether or not we are testing
  final bool testing;

  /// The function that is run when the database is created
  final Function(Database db, int version)? onCreate;

  @override
  State<RootWidget> createState() => _RootWidgetState();
}

class _RootWidgetState extends State<RootWidget> {
  /// Creates some of the blocs needed throughout the app
  ///
  /// Some blocs have to be created in the widget itself
  List<BlocProvider> _createBlocs(BuildContext context) {
    final homeBloc = HomeBloc(
      futurePrefs: context.read<Future<SharedPreferences>>(),
      chartDataApiClient: context.read<DataApiClient>(),
      leadsApiClient: context.read<LeadsApiClient>(),
      appointmentsApiClient: context.read<AppointmentsApiClient>(),
    );

    final leadsScreenBloc = LeadsScreenBloc(
      objectStore: context.read<ObjectStore>(),
      leadsApiClient: context.read<LeadsApiClient>(),
    )..add(LeadsScreenStart());

    final appointmentsScreenBloc = AppointmentsScreenBloc(
        objectStore: context.read<ObjectStore>(),
        appointmentsApiClient: context.read<AppointmentsApiClient>())
      ..add(
        AppointmentsScreenStart(
          key: UniqueKey(),
        ),
      );

    final companiesScreenBloc = CompaniesScreenBloc(
      objectStore: context.read<ObjectStore>(),
      companiesApiClient: context.read<CompaniesApiClient>(),
    )..add(
        CompaniesScreenStart(
          key: UniqueKey(),
        ),
      );

    return <BlocProvider>[
      BlocProvider<HomeBloc>.value(value: homeBloc),
      BlocProvider<AddressAutocompleteBloc>(
        create: (BuildContext context) =>
            AddressAutocompleteBloc(context.read<GooglePlacesApiClient>())
              ..add(AddressAutocompleteStart(key: UniqueKey())),
      ),
      BlocProvider<SettingsBloc>(
        create: (BuildContext context) => SettingsBloc(
            futurePrefs: context.read<Future<SharedPreferences>>(),
            userApiClient: context.read<UserApiClient>(),
            objectStore: context.read<ObjectStore>(),
            pushNotificationTokenApiClient:
                context.read<PushNotificationTokenApiClient>())
          ..add(SettingsStart()),
      ),
      BlocProvider<LeadsScreenBloc>.value(value: leadsScreenBloc),
      BlocProvider<NavScreenBloc>(
        create: (BuildContext context) => NavScreenBloc(
          leadsApiClient: context.read<LeadsApiClient>(),
          appointmentsApiClient: context.read<AppointmentsApiClient>(),
          homeBloc: homeBloc,
          companiesApiClient: context.read<CompaniesApiClient>(),
          leadsScreenBloc: leadsScreenBloc,
          appointmentsScreenBloc: appointmentsScreenBloc,
          companiesScreenBloc: companiesScreenBloc,
          objectStore: context.read<ObjectStore>(),
        )..add(
            NavScreenStart(),
          ),
      ),
      BlocProvider<AppointmentsScreenBloc>.value(value: appointmentsScreenBloc),
      BlocProvider<CompaniesScreenBloc>.value(value: companiesScreenBloc),
      BlocProvider<InputBloc>(
          create: (BuildContext context) => InputBloc(
                userApiClient: context.read<UserApiClient>(),
                leadsApiClient: context.read<LeadsApiClient>(),
                appointmentsApiClient: context.read<AppointmentsApiClient>(),
                companiesApiClient: context.read<CompaniesApiClient>(),
              )),
      BlocProvider<SupportBloc>(
        create: (BuildContext context) => SupportBloc(),
      ),
      BlocProvider<ListCompaniesBloc>(
          create: (BuildContext context) =>
              ListCompaniesBloc(context.read<ObjectStore>())
                ..add(ListCompaniesStart())),
      BlocProvider<AddObjectBloc>(
        create: (BuildContext context) => AddObjectBloc(
          leadsApiClient: context.read<LeadsApiClient>(),
          appointmentsApiClient: context.read<AppointmentsApiClient>(),
          companiesApiClient: context.read<CompaniesApiClient>(),
        )..add(
            AddObjectStart(
              key: UniqueKey(),
            ),
          ),
      ),
    ];
  }

  late ObjectStore objectStore;
  late NavScreenController navScreenController;
  late PushNotificationTokenApiClient pushNotificationTokenApiClient;

  /// Initialize the late variables above and listen for when a token changes and add it to the
  /// server if it has not been added
  Future<void> _initialize() async {
    objectStore = ObjectStore(
      storage: FlutterSecureStorage(),
      database: widget.database,
      prefs: SharedPreferences.getInstance(),
    );
    pushNotificationTokenApiClient = PushNotificationTokenApiClient(
        client: Client(), objectStore: objectStore);
    navScreenController = NavScreenController();

    _pushNotificationTokenSetup(pushNotificationTokenApiClient);
  }

  /// Sets up a listener for when the push notification token changes
  /// and tries to add the token to the server if notifications have been enabled
  /// and the token has NOT been added to the server yet
  Future<void> _pushNotificationTokenSetup(
      PushNotificationTokenApiClient pushNotificationTokenApiClient) async {
    final prefs = await SharedPreferences.getInstance();

    /// Save the token to the server and locally when it changes
    FirebaseMessaging.instance.onTokenRefresh.listen((String token) {
      pushNotificationTokenApiClient.add(token);
    });

    /// Try to upload the token to the server if notifications have been allowed
    final String localPushNotificationToken = await objectStore
            .getPushNotificationToken() ??
        ''; // If the token happens to be an empty string, then it has not been saved to the server
    final bool hasNotificationsEnabled =
        prefs.getBool(Keys.instance.userEnabledNotifications) ?? false;
    final bool hasDeniedNotifications =
        prefs.getBool(Keys.instance.userDeniedNotifications) ?? false;

    if (localPushNotificationToken.isEmpty &&
        hasNotificationsEnabled &&
        !hasDeniedNotifications) {
      final pushNotificationToken = await FirebaseMessaging.instance.getToken();

      if (pushNotificationToken != null) {
        try {
          pushNotificationTokenApiClient.add(pushNotificationToken);
          objectStore.storePushNotificationToken(pushNotificationToken);
        } catch (error) {
          print(
              'Error has occurred while trying to add the token to the server and locally: $error');
        }
      }
    }
  }

  @override
  void dispose() {
    if (!widget.testing) {
      widget.database.close();
    }
    navScreenController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialize(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return ChangeNotifierProvider.value(
            value: navScreenController,
            child: MultiRepositoryProvider(
              providers: [
                RepositoryProvider(
                    create: (BuildContext context) =>
                        SharedPreferences.getInstance()),
                RepositoryProvider.value(value: objectStore),
                RepositoryProvider(
                  create: (BuildContext context) => Client(),
                ),
                RepositoryProvider(
                  create: (BuildContext context) => Uuid(),
                ),
                RepositoryProvider(
                    create: (BuildContext context) => DataApiClient(
                        client: context.read<Client>(),
                        userStore: context.read<ObjectStore>())),
                RepositoryProvider(
                    create: (BuildContext context) => UserApiClient(
                        client: context.read<Client>(),
                        userStore: context.read<ObjectStore>())),
                RepositoryProvider(
                  create: (BuildContext context) => LeadsApiClient(
                      client: context.read<Client>(),
                      objectStore: context.read<ObjectStore>()),
                ),
                RepositoryProvider(
                  create: (BuildContext context) => AppointmentsApiClient(
                      client: context.read<Client>(),
                      objectStore: context.read<ObjectStore>()),
                ),
                RepositoryProvider.value(value: pushNotificationTokenApiClient),
                RepositoryProvider(
                  create: (BuildContext context) => CompaniesApiClient(
                      client: context.read<Client>(),
                      userStore: context.read<ObjectStore>()),
                ),
                RepositoryProvider(
                  create: (BuildContext context) => GooglePlacesApiClient(
                      client: context.read<Client>(),
                      uuid: context.read<Uuid>()),
                ),
                RepositoryProvider(
                    create: (BuildContext context) => SplashScreenBloc(
                        futurePrefs: context.read<Future<SharedPreferences>>(),
                        userApiClient: context.read<UserApiClient>(),
                        userStore: context.read<ObjectStore>())
                      ..add(SplashScreenStart())),
                RepositoryProvider(
                    create: (BuildContext context) => SliderScreenBloc()),
              ],
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return MultiBlocProvider(
                      providers: _createBlocs(context), child: widget.child);
                },
              ),
            ),
          );
        }

        return SizedBox.shrink();
      },
    );
  }
}
