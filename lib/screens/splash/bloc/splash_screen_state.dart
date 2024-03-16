part of 'splash_screen_bloc.dart';

abstract class SplashScreenState extends Equatable {
  const SplashScreenState();

  @override
  List<Object> get props => [];
}

class SplashScreenInitial extends SplashScreenState {}

class SplashScreenLoading extends SplashScreenState {}

/// User has not logged in or signed out
class SplashScreenUserNotLoggedIn extends SplashScreenState {}

/// The user has been successfully retrieved from the API so bring
/// them to the nav screen.
class SplashScreenUser extends SplashScreenState {
  final User user;

  SplashScreenUser({required this.user});
}

/// The user could not be logged in, has no credentials stored
/// from previous logins, or an error occurred.
class SplashScreenError extends SplashScreenState {
  final ApiMessageException error;
  final StackTrace stackTrace;

  SplashScreenError({required this.error, required this.stackTrace});

  @override
  List<Object> get props => super.props + [error, stackTrace];
}
