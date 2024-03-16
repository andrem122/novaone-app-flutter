part of 'settings_bloc.dart';

abstract class SettingsState extends Equatable {
  const SettingsState();

  @override
  List<Object> get props => [];
}

/// The initial state of the settings screen
class SettingsInitial extends SettingsState {}

/// The settings screen is loading
class SettingsLoading extends SettingsState {}

/// The settings screen has loaded
class SettingsLoaded extends SettingsState {}

/// A state to represent the updating of a user's notification preferences
class SettingsUpdatingNotificationItem extends SettingsState {}

/// A state to represent that the user's notification preferences have been updated successfully
class SettingsUpdatedNotificationItem extends SettingsState {}

/// A state to represent that the process to sign out the user has been completed
class SettingsSignOutTappedComplete extends SettingsState {
  final Key key;

  const SettingsSignOutTappedComplete(this.key);

  @override
  List<Object> get props => super.props + [key];
}

// Home page error state
class SettingsError extends SettingsState {
  final String error;
  final StackTrace stackTrace;

  SettingsError({required this.error, required this.stackTrace});

  @override
  List<Object> get props => super.props + [error, stackTrace];
}
