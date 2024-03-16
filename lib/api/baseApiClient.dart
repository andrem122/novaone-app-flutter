import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:novaone/api/api.dart';
import 'package:novaone/apiCredentials.dart';
import 'package:http/http.dart';
import 'package:novaone/auth/auth.dart';
import 'package:novaone/models/models.dart';
import 'package:novaone/novaOneUrl.dart';

class BaseApiClient<T extends BaseModel> {
  final Client client;
  final ObjectStore objectStore;

  // The base parameters to send with every request to the NovaOne API
  final Map<String, String> baseParameters = {
    'PHPAuthenticationUsername': ApiCredentials.PHPAuthenticationUsername,
    'PHPAuthenticationPassword': ApiCredentials.PHPAuthenticationPassword,
  };

  // The API headers to send with every request to the NovaOne API
  final Map<String, String> apiHeaders = {
    'Referer': NovaOneUrl.novaOneWebsiteUrl.toString(),
    'Content-Type': 'application/x-www-form-urlencoded',
  };

  BaseApiClient({required this.client, required this.objectStore});

  /// Makes a post request with some base parameters to the NovaOneApi
  ///
  /// Takes in some extra [parameters] to add to the [baseParameters]
  /// Also requries a [uri] to make a request to
  /// An optional [errorMessage] can be provided for when the request fails
  Future<Response> postToNovaOneApi(
      {required Uri uri,
      required Map<String, String> parameters,
      String errorMessage = 'Unsuccessful request!',
      bool testing = false}) async {
    // Add the base parameters to the additional parameters
    parameters.addAll(baseParameters);

    // Convert to query string
    final String query = Uri(queryParameters: parameters).query;
    final Response response =
        await client.post(uri, headers: apiHeaders, body: query);

    // Handle errors if not testing
    if (!testing) {
      if (response.statusCode > 299 || response.statusCode < 200) {
        ApiMessageFailureHandler.throwErrorMessage(
            fallback: errorMessage, response: response);
      }
    }

    return response;
  }

  /// Gets more data to append to a table from the NovaOne API.
  ///
  /// A [lastObjectId] is needed to know where to fetch the next number of leads
  /// and a [fromJson] method is needed to let the method know which 'fromJson'
  /// method to use for the type we are converting a json object into.
  ///
  /// Returns an [ApiMessageException] object if the request fails
  /// and leads data if the request was successful.
  Future<List<T>> getMore(int lastObjectId) async {
    final User? user = await objectStore.getUser();

    final Map<String, String> parameters = {
      'email': user?.email ?? '',
      'password': await objectStore
          .getPassword(), // Have to use userStore.getPassword here because the user object has an encryptyed password
      'customerUserId': user?.customerId.toString() ?? '',
      'lastObjectId': lastObjectId.toString(),
    };

    /// Determine what URI to use based on the type T
    Uri uriToUse = Uri();
    if (T == Lead) {
      uriToUse = NovaOneUrl.novaOneApiMoreLeadsData;
    } else if (T == Appointment) {
      uriToUse = NovaOneUrl.novaOneApiMoreAppointmentsData;
    } else if (T == Company) {
      uriToUse = NovaOneUrl.novaOneApiMoreCompaniesData;
    } else {
      print('Could not obtain URI for more data. No cases matched');
    }

    final response = await this.postToNovaOneApi(
        uri: uriToUse,
        parameters: parameters,
        errorMessage: 'Could not fetch more data');
    List<dynamic> json = [];
    try {
      json = jsonDecode(response.body);
    } on TypeError {
      ApiMessageFailureHandler.throwErrorMessage(
          fallback: 'Could not decode JSON properly', response: response);
    }

    List<T> objects = [];
    if (T == Lead) {
      objects = json.map((rawJson) => Lead.fromJson(json: rawJson)).toList()
          as List<T>;
    } else if (T == Appointment) {
      objects = json
          .map((rawJson) => Appointment.fromJson(json: rawJson))
          .toList() as List<T>;
    } else if (T == Company) {
      objects = json.map((rawJson) => Company.fromJson(json: rawJson)).toList()
          as List<T>;
    } else {
      print(
          'Could not convert objects from JSON for more data. No cases matched');
    }

    objectStore.storeObjects(objects);

    return objects;
  }

  /// Refreshes the data for a table from the NovaOne API.
  ///
  /// A [lastObjectId] is needed to know where to fetch the next number of objects
  /// and a [fromJson] method is needed to let the method know which 'fromJson'
  /// method to use for the type we are converting a json object into.
  ///
  /// Returns an [ApiMessageException] object if the request fails
  /// and leads data if the request was successful.
  Future<List<T>> refresh(int lastObjectId, BuildContext context) async {
    final User? user = await objectStore.getUser();

    final Map<String, String> parameters = {
      'email': user?.email ?? '',
      'password': await objectStore.getPassword(),
      'customerUserId': user?.customerId.toString() ?? '',
      'lastObjectId': lastObjectId.toString(),
    };

    /// Determine what URI to use based on the type T
    Uri uriToUse = Uri();
    switch (T) {
      case Lead:
        uriToUse = NovaOneUrl.novaOneApiRefreshLeadsData;
        break;
      case Appointment:
        uriToUse = NovaOneUrl.novaOneApiRefreshAppointmentsData;
        break;
      case Company:
        uriToUse = NovaOneUrl.novaOneApiRefreshCompaniesData;
        break;
      default:
        throw TypeError();
    }

    final response = await this.postToNovaOneApi(
        uri: uriToUse,
        parameters: parameters,
        errorMessage: 'Could not fetch more data');

    List<dynamic> json = [];
    try {
      json = jsonDecode(response.body);
    } on TypeError {
      ApiMessageFailureHandler.throwErrorMessage(
          fallback: 'Could not decode JSON properly', response: response);
    }

    List<T> objects = [];
    switch (T) {
      case Lead:
        objects = json.map((rawJson) => Lead.fromJson(json: rawJson)).toList()
            as List<T>;
        break;
      case Appointment:
        objects = json
            .map((rawJson) => Appointment.fromJson(json: rawJson))
            .toList() as List<T>;
        break;
      case Company:
        objects = json
            .map((rawJson) => Company.fromJson(json: rawJson))
            .toList() as List<T>;
        break;
      default:
        throw TypeError();
    }

    await objectStore.storeObjects<T>(objects);

    return objects;
  }
}
