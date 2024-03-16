import 'package:novaone/models/googlePlacesPlace.dart';

class ValueExtractor {
  /// Gets the city, state, zip, and address from a google place
  static List<String> getAddressComponentsFromGooglePlace(
      GooglePlacesPlace place) {
    final String address = place.formattedAddress;
    String zip;
    String state;
    String city;

    try {
      city = place.addressComponents
          .firstWhere((component) => component.types.contains('locality'))
          .shortName;
    } catch (error) {
      city = '';
    }

    try {
      state = place.addressComponents
          .firstWhere((component) =>
              component.types.contains('administrative_area_level_1'))
          .shortName;
    } catch (error) {
      state = '';
    }

    try {
      zip = place.addressComponents
          .firstWhere((component) => component.types.contains('postal_code'))
          .shortName;
    } catch (error) {
      zip = '';
    }

    return [address, city, state, zip];
  }
}
