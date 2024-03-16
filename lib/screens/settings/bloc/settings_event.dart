part of 'settings_bloc.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object> get props => [];
}

/// The settings screen is starting up
class SettingsStart extends SettingsEvent {}

/// The event that occurs when the sign out option is tapped on the settings page
class SettingsSignOutTapped extends SettingsEvent {
  final Key key;

  SettingsSignOutTapped(this.key);

  @override
  List<Object> get props => super.props + [key];
}

/// The event that occurs when information on the settings page has been updated
class SettingsScreenUpdate extends SettingsEvent {
  final User user;

  SettingsScreenUpdate(this.user);

  @override
  List<Object> get props => super.props + [user];
}

/// The event that occurs when a notification item is tapped
class SettingsNotificationItemTapped extends SettingsEvent {
  final SettingsNotificationItem settingsNotificationItem;
  final bool settingsNotificationItemValue;

  SettingsNotificationItemTapped(
      {required this.settingsNotificationItem,
      required this.settingsNotificationItemValue});

  @override
  List<Object> get props =>
      super.props + [settingsNotificationItem, settingsNotificationItemValue];
}
