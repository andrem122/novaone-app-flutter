import 'dart:convert';

import 'package:http/http.dart';
import 'package:novaone/apiCredentials.dart';
import 'package:novaone/models/models.dart';
import 'package:novaone/novaOneUrl.dart';
import 'package:uuid/uuid.dart';

class GooglePlacesApiClient {
  final Client client;
  final Uuid uuid;

  GooglePlacesApiClient({
    required this.client,
    required this.uuid,
  });

  final String apiKey = ApiCredentials.googlePlacesApiKey;
  final String type = '(regions)';

  /// Gets a list of [GooglePlacesPrediction] from the Google Places API for the [input]
  Future<List<GooglePlacesPrediction>> getSuggestions(String input) async {
    final Uri uri = NovaOneUrl.googlePlacesApiAutocomplete(
        input: input, sessionToken: uuid.v4(), types: 'address');

    final response = await client.get(uri);

    // Handle errors
    if (response.statusCode != 200) {
      throw Exception('Failed to load predictions');
    }

    final json = jsonDecode(response.body);
    final List<dynamic> jsonList = json['predictions'];
    return jsonList
        .map((json) => GooglePlacesPrediction.fromJson(json: json))
        .toList();
  }

  /// Gets all the place details for a [placeId]
  Future<GooglePlacesPlace> getPlaceDetails(String placeId) async {
    final Uri uri = NovaOneUrl.googlePlacesApiPlaceDetails(
        placeId: placeId, sessionToken: uuid.v4());

    final response = await client.get(uri);

    // Handle errors
    if (response.statusCode != 200) {
      throw Exception('Failed to load place details');
    }

    final json = jsonDecode(response.body);
    return GooglePlacesPlace.fromJson(json: json['result']);
  }
}
