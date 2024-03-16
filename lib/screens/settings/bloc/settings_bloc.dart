import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:novaone/api/api.dart';
import 'package:novaone/auth/auth.dart';
import 'package:novaone/enums/enums.dart';
import 'package:novaone/models/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final Future<SharedPreferences> futurePrefs;
  final UserApiClient userApiClient;
  final ObjectStore objectStore;
  final PushNotificationTokenApiClient pushNotificationTokenApiClient;

  SettingsBloc({
    required this.futurePrefs,
    required this.userApiClient,
    required this.objectStore,
    required this.pushNotificationTokenApiClient,
  }) : super(SettingsInitial()) {
    on<SettingsStart>(_start);
    on<SettingsNotificationItemTapped>(_settingsNotificationItemTapped);
    on<SettingsSignOutTapped>(_settingsSignOutTapped);
  }

  _start(SettingsStart event, Emitter<SettingsState> emit) {
    emit(SettingsLoading());
    emit(SettingsLoaded());
  }

  _settingsNotificationItemTapped(
      SettingsNotificationItemTapped event, Emitter<SettingsState> emit) async {
    emit(SettingsUpdatingNotificationItem());

    switch (event.settingsNotificationItem) {
      case SettingsNotificationItem.Email:
        final Map<UpdateObject, dynamic> properties = {
          UpdateObject.UserEmailNotifications:
              event.settingsNotificationItemValue
        };
        await userApiClient.updateUser(properties: properties);
        break;
      case SettingsNotificationItem.SMS:
        final Map<UpdateObject, dynamic> properties = {
          UpdateObject.UserSMSNotifications: event.settingsNotificationItemValue
        };
        userApiClient.updateUser(properties: properties);
        break;
      case SettingsNotificationItem.PushNotification:
        print(
            'SettingsBloc.mapEventToState: SettingsNotificationItem.PushNotification case matched');
        break;
      default:
        print('SettingsBloc.mapEventToState: No settings item case matched');
    }

    emit(SettingsUpdatedNotificationItem());
  }

  _settingsSignOutTapped(
      SettingsSignOutTapped event, Emitter<SettingsState> emit) async {
    // Delete push notification token from the server

    final token = await objectStore.getPushNotificationToken() ?? '';

    if (token.isNotEmpty) {
      pushNotificationTokenApiClient.delete(token);
    }

    // Clear all user preferences and data
    final _prefs = await futurePrefs;
    await _prefs.clear();
    await objectStore.clearData();
    emit(SettingsSignOutTappedComplete(event.key));
  }
}
