import 'package:equatable/equatable.dart';

class GooglePlacesAddressComponents extends Equatable {
  final String longName;
  final String shortName;
  final List<String> types;

  GooglePlacesAddressComponents(
      {required this.longName, required this.shortName, required this.types});

  @override
  List<Object?> get props => [];

  Map<String, dynamic> toJson() => {
        'long_name': longName,
        'short_name': shortName,
        'types': types,
      };

  factory GooglePlacesAddressComponents.fromJson(
          {required Map<String, dynamic> json}) =>
      GooglePlacesAddressComponents(
          longName: json['long_name'],
          shortName: json['short_name'],
          types: (json['types'] as List<dynamic>)
              .map((e) => e as String)
              .toList());
}
