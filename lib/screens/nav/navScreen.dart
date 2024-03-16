import 'dart:io' show Platform;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:novaone/api/api.dart';
import 'package:novaone/auth/auth.dart';
import 'package:novaone/controllers/navScreenController.dart';
import 'package:novaone/models/models.dart';
import 'package:novaone/screens/nav/bloc/nav_screen_bloc.dart';
import 'package:novaone/screens/screens.dart';
import 'package:novaone/utils/utils.dart';
import 'package:novaone/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavScreen extends StatefulWidget {
  NavScreen({
    Key? key,
    required,
    required this.controller,
  }) : super(key: key);

  final _NavScreenState state = _NavScreenState();
  final NavScreenController controller;

  @override
  _NavScreenState createState() => state;
}

class _NavScreenState extends State<NavScreen> with TickerProviderStateMixin {
  int selectedIndex = 0;
  late TabController tabController;

  /// Sets the boolean value for the user's notification preference
  void _setUserNotificationPreference(
      {required bool value, required BuildContext context}) async {
    final prefs = await context.read<Future<SharedPreferences>>();

    if (value == true) {
      await prefs.setBool(Keys.instance.userEnabledNotifications, true);
    } else {
      await prefs.setBool(Keys.instance.userDeniedNotifications, true);
    }
  }

  /// Asks the user for permission to send notifications
  void _requestNotificationPermission() async {
    final prefs = await context.read<Future<SharedPreferences>>();
    final bool hasNotificationsEnabled =
        prefs.getBool(Keys.instance.userEnabledNotifications) ?? false;
    final bool hasDeniedNotifications =
        prefs.getBool(Keys.instance.userDeniedNotifications) ?? false;

    if (Platform.isAndroid) {
      /// Android
      FirebaseMessaging.instance
          .requestPermission()
          .then((NotificationSettings settings) async {
        if (settings.authorizationStatus == AuthorizationStatus.authorized) {
          _setUserNotificationPreference(value: true, context: context);

          /// Save the token to the server and locally
          final token = await FirebaseMessaging.instance.getToken();
          context.read<PushNotificationTokenApiClient>().add(token ?? '');
        } else if (settings.authorizationStatus ==
            AuthorizationStatus.provisional) {
          _setUserNotificationPreference(value: true, context: context);

          /// Save the token to the server and locally
          final token = await FirebaseMessaging.instance.getToken();
          context.read<PushNotificationTokenApiClient>().add(token ?? '');
        } else {
          _setUserNotificationPreference(value: false, context: context);
        }
      });
    } else if (Platform.isIOS &&
        !hasNotificationsEnabled &&
        !hasDeniedNotifications) {
      Navigator.of(context).push(
        ModalPopup(
          title: 'Enable Notifications',
          subtitle:
              'Enable notifications to keep up to date on events, so you always know what\'s going on.',
          cancelButtonTitle: 'No',
          onCancelButtonPressed: () {
            _setUserNotificationPreference(value: false, context: context);
            Navigator.of(context).pop();
          },
          actionButtonTitle: 'Ok',
          onActionButtonPressed: () {
            Navigator.of(context).pop();
            FirebaseMessaging.instance
                .requestPermission()
                .then((NotificationSettings settings) async {
              if (settings.authorizationStatus ==
                  AuthorizationStatus.authorized) {
                _setUserNotificationPreference(value: true, context: context);

                /// Save the token to the server and locally
                final token = await FirebaseMessaging.instance.getToken();
                context.read<PushNotificationTokenApiClient>().add(token ?? '');
              } else if (settings.authorizationStatus ==
                  AuthorizationStatus.provisional) {
                _setUserNotificationPreference(value: true, context: context);

                /// Save the token to the server and locally
                final token = await FirebaseMessaging.instance.getToken();
                context.read<PushNotificationTokenApiClient>().add(token ?? '');
              } else {
                _setUserNotificationPreference(value: false, context: context);
              }
            });
          },
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _initialize();
    _requestNotificationPermission();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  void _initialize() {
    tabController =
        TabController(length: 5, vsync: this, initialIndex: selectedIndex);
    widget.controller.addListener(() {
      setState(() {
        final int index = widget.controller.index;
        selectedIndex = index;
        tabController.animateTo(index);
      });
    });
  }

  /// The icons to show in the tab bar
  final _icons = [
    Icons.home,
    Icons.perm_contact_calendar,
    Icons.people_alt,
    Icons.settings,
    Icons.business,
  ];

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: widget.controller,
      child: DefaultTabController(
        length: _icons.length,
        child: Scaffold(
          body: BlocConsumer<NavScreenBloc, NavScreenState>(
            builder: (BuildContext context, NavScreenState state) {
              if (state is NavScreenLoaded) {
                return _buildLoaded(companies: state.companies);
              }

              if (state is NavScreenError) {
                _buildError(context: context);
              }

              return _buildLoading();
            },
            listener: (BuildContext context, NavScreenState state) {},
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: CustomTabBar(
              icons: _icons,
              selectedIndex: selectedIndex,
              onTap: (index) => setState(() => selectedIndex = index),
              controller: tabController,
            ),
          ),
        ),
      ),
    );
  }

  /// Builds the screens needed for the nav screen
  Widget _buildLoaded({required List<Company> companies}) {
    return IndexedStack(
      index: selectedIndex,
      children: [
        HomeScreenLayout(),
        AppointmentsScreen(
          companies: companies,
        ),
        LeadsScreen(),
        SettingsLayout(
          objectStore: context.read<ObjectStore>(),
        ),
        CompaniesScreen(),
      ],
    );
  }

  Widget _buildError({required BuildContext context}) {
    return ErrorDisplay(
      onPressed: () {},
    );
  }

  /// Builds the loading screens
  Widget _buildLoading() {
    return IndexedStack(
      index: selectedIndex,
      children: <Widget>[
        HomeScreenLayout(),
        NovaOneListObjectsLayoutLoading(),
        NovaOneListObjectsLayoutLoading(),
        SettingsLayout(
          objectStore: context.read<ObjectStore>(),
        ),
        NovaOneListObjectsLayoutLoading(),
      ],
    );
  }
}
