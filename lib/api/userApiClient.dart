import 'dart:convert';
import 'package:http/http.dart';
import 'package:novaone/api/api.dart';
import 'package:novaone/auth/auth.dart';
import 'package:novaone/enums/enums.dart';
import 'package:novaone/models/models.dart';
import 'package:novaone/novaOneTableHelper.dart';
import 'package:novaone/novaOneUrl.dart';
import 'package:novaone/utils/utils.dart';

class UserApiClient extends BaseApiClient<User> {
  UserApiClient({required Client client, required ObjectStore userStore})
      : super(client: client, objectStore: userStore);

  /// Gets the user object from the API by sending a [email] and [password]
  /// to the NovOne Api
  ///
  /// Returns an [ApiMessageException] object if the request fails
  /// and a [User] object if the request was successful
  Future<User> getUser(
      {required String email, required String password}) async {
    Map<String, String> parameters = {'email': email, 'password': password};

    final response = await postToNovaOneApi(
        uri: NovaOneUrl.novaOneApiUrlLogin,
        parameters: parameters,
        errorMessage: 'Could not fetch user data');

    final Map<String, dynamic> json = jsonDecode(response.body);
    final user = User.fromJson(json: json);
    objectStore.storeUser(user: user);
    return user;
  }

  /// Update the properties of the user locally and on the server.
  ///
  /// Takes in a list of [properties] to update for the user
  /// and returns the updated user object when complete.
  Future<void> updateUser(
      {required Map<UpdateObject, dynamic> properties}) async {
    final User? user = await objectStore.getUser();

    /// Add in the column names we will update in the database
    /// and update the user locally
    Map<String, String> columns = {};
    String tableToUse = NovaOneTableHelper.instance.customer;
    String userIdToUse = user?.customerId.toString() ?? '';
    Uri uriToUse = NovaOneUrl.novaOneApiUpdateObject;
    if (properties.containsKey(UpdateObject.UserEmailNotifications)) {
      final String switchFlag =
          properties[UpdateObject.UserEmailNotifications] == true ? 't' : 'f';
      columns['wants_email_notifications'] = switchFlag;
      user?.wantsEmailNotifications =
          properties[UpdateObject.UserEmailNotifications];

      uriToUse = NovaOneUrl.novaOneApiUpdateObject;
      tableToUse = NovaOneTableHelper.instance.customer;
      userIdToUse = user?.customerId.toString() ?? '';
    }

    if (properties.containsKey(UpdateObject.UserSMSNotifications)) {
      final String switchFlag =
          properties[UpdateObject.UserSMSNotifications] == true ? 't' : 'f';
      columns['wants_sms'] = switchFlag;
      user?.wantsSms = properties[UpdateObject.UserSMSNotifications];

      uriToUse = NovaOneUrl.novaOneApiUpdateObject;
      tableToUse = NovaOneTableHelper.instance.customer;
      userIdToUse = user?.customerId.toString() ?? '';
    }

    if (properties.containsKey(UpdateObject.UserPhone)) {
      final updatedPhoneNumber = properties[UpdateObject.UserPhone];

      assert(updatedPhoneNumber != null);
      assert(updatedPhoneNumber != '');

      columns['phone_number'] = StringFormatter.instance
          .formatPhoneNumberForApiCall(updatedPhoneNumber);

      uriToUse = NovaOneUrl.novaOneApiUpdateObject;
      tableToUse = NovaOneTableHelper.instance.customer;
      userIdToUse = user?.customerId.toString() ?? '';
    }

    if (properties.containsKey(UpdateObject.UserEmail)) {
      final updatedEmail = properties[UpdateObject.UserEmail];

      assert(updatedEmail != null);
      assert(updatedEmail != '');

      columns['email'] = updatedEmail;

      uriToUse = NovaOneUrl.novaOneApiUpdateEmail;
      tableToUse = NovaOneTableHelper.instance.authUser;
      userIdToUse = user?.userId.toString() ?? '';
    }

    if (properties.containsKey(UpdateObject.UserPassword)) {
      final updatedPassword = properties[UpdateObject.UserPassword];

      assert(updatedPassword != null);
      assert(updatedPassword != '');

      columns['password'] = updatedPassword;
      uriToUse = NovaOneUrl.novaOneApiUpdatePassword;
      tableToUse = NovaOneTableHelper.instance.authUser;
      userIdToUse = user?.userId.toString() ?? '';
    }

    if (properties.containsKey(UpdateObject.UserName)) {
      final updatedName = properties[UpdateObject.UserName];

      assert(updatedName != null);
      assert(updatedName != '');

      final List<String> nameList = (updatedName as String).split(' ');
      final String firstName = nameList.first;
      final String lastName = nameList.last;

      columns['first_name'] = firstName;
      columns['last_name'] = lastName;
      uriToUse = NovaOneUrl.novaOneApiUpdateName;
      tableToUse = NovaOneTableHelper.instance.authUser;
      userIdToUse = user?.userId.toString() ?? '';
    }

    /// Encode columns as a string and send to API
    final jsonEncodedColumns = jsonEncode(columns);

    if (user != null) {
      objectStore.storeUser(user: user);
    }

    Map<String, String> parameters = {
      'email': user?.email ?? '',
      'password': await objectStore
          .getPassword(), // Have to use userStore.getPassword here because the user object has an encryptyed password
      'tableName': tableToUse,
      'columns': jsonEncodedColumns,
      'objectId': userIdToUse,
    };

    /// Update user on the server
    postToNovaOneApi(uri: uriToUse, parameters: parameters)
        .then((Response response) => print(response.body));

    /// UPDATE LOCALLY
    /// Update user password locally after updating on server
    final User? updatedUser = await objectStore.getUser();
    if (properties.containsKey(UpdateObject.UserPassword)) {
      final updatedPassword = properties[UpdateObject.UserPassword];
      objectStore.storeCredentials(
          password: updatedPassword, email: user?.email ?? '');
    }

    if (properties.containsKey(UpdateObject.UserPhone)) {
      final updatedPhone = StringFormatter.instance
          .formatPhoneNumberForApiCall(properties[UpdateObject.UserPhone]);
      updatedUser?.phoneNumber = updatedPhone;
      if (updatedUser != null) {
        objectStore.storeUser(user: updatedUser);
      }
    }

    /// Update user email locally after updating on server
    if (properties.containsKey(UpdateObject.UserEmail)) {
      final updatedEmail = properties[UpdateObject.UserEmail];
      objectStore.storeCredentials(
          password: await objectStore.getPassword(), email: updatedEmail);

      // Update local user object
      updatedUser?.email = updatedEmail;
      if (updatedUser != null) {
        objectStore.storeUser(user: updatedUser);
      }
    }

    if (properties.containsKey(UpdateObject.UserName)) {
      final updatedName = properties[UpdateObject.UserName];

      final List<String> nameList = (updatedName as String).split(' ');
      final String firstName = nameList.first;
      final String lastName = nameList.last;

      // Update local user object
      updatedUser?.firstName = firstName;
      updatedUser?.lastName = lastName;
      if (updatedUser != null) {
        objectStore.storeUser(user: updatedUser);
      }
    }
  }

  /// Send a support request from this user
  ///
  /// Takes in [message] needed for the request
  Future<void> sendSupportRequest(String message) async {
    final User? user = await objectStore.getUser();
    Map<String, String> parameters = {
      'email': user?.email ?? '',
      'password': await objectStore.getPassword(),
      'customerMessage': message,
    };

    await postToNovaOneApi(
        uri: NovaOneUrl.novaOneApiSupport,
        parameters: parameters,
        errorMessage: 'Could not send user request');
  }
}
