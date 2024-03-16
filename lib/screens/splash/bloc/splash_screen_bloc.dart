import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:novaone/api/api.dart';
import 'package:novaone/auth/auth.dart';
import 'package:novaone/models/user.dart';
import 'package:novaone/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'splash_screen_event.dart';
part 'splash_screen_state.dart';

class SplashScreenBloc extends Bloc<SplashScreenEvent, SplashScreenState> {
  SplashScreenBloc({
    required this.futurePrefs,
    required this.userStore,
    required this.userApiClient,
  }) : super(SplashScreenInitial()) {
    on<SplashScreenStart>(_start);
  }

  final Future<SharedPreferences> futurePrefs;
  final ObjectStore userStore;
  final UserApiClient userApiClient;

  _start(SplashScreenStart event, Emitter<SplashScreenState> emit) async {
    emit(SplashScreenLoading());

    final SharedPreferences prefs = await futurePrefs;
    final bool userIsLoggedIn =
        prefs.getBool(Keys.instance.userLoggedIn) ?? false;
    final bool hasCredentials = await userStore.hasCredentials();

    /// Check to see if the user is logged in
    /// If the user is logged in, then grab user object and direct them to the home page
    if (userIsLoggedIn && hasCredentials) {
      try {
        final String email = await userStore.getEmail();
        final String password = await userStore.getPassword();

        // Get the user object from the API
        final user = await userApiClient
            .getUser(email: email, password: password)
            .whenComplete(() => emit.isDone);
        emit(SplashScreenUser(user: user));
      } catch (error, stackTrace) {
        final String? errorMessage =
            error is ApiMessageException ? error.reason : error.toString();
        final ApiMessageException errorObject = error is ApiMessageException
            ? error
            : ApiMessageException(reason: error.toString(), error: 0);
        print('SplashScreenStart Error: $errorMessage');
        emit(SplashScreenError(error: errorObject, stackTrace: stackTrace));
      }
    } else {
      emit(SplashScreenUserNotLoggedIn());
    }
  }
}
