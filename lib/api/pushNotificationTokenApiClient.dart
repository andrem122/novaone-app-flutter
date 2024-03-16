import 'dart:convert';
import 'dart:io' show Platform;
import 'package:http/http.dart';
import 'package:novaone/api/api.dart';
import 'package:novaone/auth/auth.dart';
import 'package:novaone/models/models.dart';
import 'package:novaone/novaOneTableHelper.dart';
import 'package:novaone/novaOneUrl.dart';

///  A class to help manage push notification token objects
class PushNotificationTokenApiClient extends BaseApiClient {
  PushNotificationTokenApiClient(
      {required Client client, required ObjectStore objectStore})
      : super(client: client, objectStore: objectStore);

  /// Adds a push notification token object to the server and saves it locally
  Future<void> add(String token) async {
    if (token.isEmpty) {
      throw Exception(
          'PushNotificationTokenApiClient.add: Token cannot be an empty string.');
    }

    final User? user = await objectStore.getUser();

    Map<String, String> columns = {
      'deviceToken': token,
      'type': Platform.isIOS ? 'iOS' : 'Android',
      'customerUserId': user?.id.toString() ?? '',
    };

    // Encode columns as a string and send to API
    final jsonEncodedColumns = jsonEncode(columns);

    Map<String, String> parameters = {
      'email': user?.email ?? '',
      'password': await objectStore.getPassword(),
      'columns': jsonEncodedColumns,
    };

    postToNovaOneApi(
            uri: NovaOneUrl.novaOneApiAddToken,
            parameters: parameters,
            errorMessage: 'Could not fetch lead data')
        .then((_) async {
      await objectStore.storePushNotificationToken(token);
    }, onError: (error) {
      throw Exception(
          'Error occurred while adding push notification token to the server: $error');
    });
  }

  /// Deletes a [token] locally and from the server
  Future<void> delete(String token) async {
    if (token.isEmpty) {
      throw Exception('Token cannot be empty');
    }

    final User? user = await objectStore.getUser();

    Map<String, String> parameters = {
      'email': user?.email ?? '',
      'password': await objectStore.getPassword(),
      'objectId': token,
      'tableName': NovaOneTableHelper.instance.pushNotificationTokens,
      'columnName': 'device_token',
    };

    postToNovaOneApi(
            uri: NovaOneUrl.novaOneApiDeleteObject, parameters: parameters)
        .then((Response response) => print(response.body));

    await objectStore.deletePushNotificationToken();
  }
}
