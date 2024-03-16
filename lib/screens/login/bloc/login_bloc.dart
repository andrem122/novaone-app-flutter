import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:novaone/api/api.dart';
import 'package:novaone/auth/auth.dart';
import 'package:novaone/models/models.dart';
import 'package:novaone/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final Future<SharedPreferences> futurePrefs;
  final ObjectStore objectStore;
  final UserApiClient userApiClient;
  LoginBloc(
      {required this.futurePrefs,
      required this.userApiClient,
      required this.objectStore})
      : super(LoginLoaded()) {
    on<LoginButtonTapped>(_login);
    on<LoginStart>(_start);
  }

  _start(LoginStart event, Emitter<LoginState> emit) {
    emit(LoginLoaded());
  }

  /// Logs the use in after the login button has been tapped
  _login(LoginButtonTapped event, Emitter<LoginState> emit) async {
    final SharedPreferences prefs = await futurePrefs;
    emit(LoginLoading());

    try {
      // Get user data from API
      final user = await userApiClient.getUser(
          email: event.email, password: event.password);

      // User has been logged in so keep track of login status
      // password, and username/email to
      // allow the user to not have to login again
      prefs.setBool(Keys.instance.userLoggedIn, true);
      objectStore.storeUser(user: user);
      objectStore.storeCredentials(
          password: event.password, email: event.email);

      emit(LoginUser(user: user));
    } catch (error) {
      if (error is ApiMessageException) {
        print('LoginBloc._login: ${error.reason}');
        emit(LoginError(error: error));
      }
    }
  }
}
