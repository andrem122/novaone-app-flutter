import 'package:equatable/equatable.dart';
import 'package:novaone/models/models.dart';

class GooglePlacesPlace extends Equatable {
  final List<GooglePlacesAddressComponents> addressComponents;
  final String adrAddress;
  final String formattedAddress;

  GooglePlacesPlace(
      {required this.addressComponents,
      required this.adrAddress,
      required this.formattedAddress});

  @override
  List<Object?> get props => [];

  Map<String, dynamic> toJson() => {
        'address_components': addressComponents
            .map((GooglePlacesAddressComponents addressComponents) =>
                addressComponents.toJson())
            .toList(),
        'adr_address': adrAddress,
        'formatted_address': formattedAddress,
      };

  factory GooglePlacesPlace.fromJson({required Map<String, dynamic> json}) =>
      GooglePlacesPlace(
          addressComponents: (json['address_components'] as List<dynamic>)
              .map((addressComponentsJson) =>
                  GooglePlacesAddressComponents.fromJson(
                      json: addressComponentsJson))
              .toList(),
          adrAddress: json['adr_address'],
          formattedAddress: json['formatted_address']);
}
