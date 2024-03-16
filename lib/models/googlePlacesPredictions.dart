import 'package:equatable/equatable.dart';
import 'package:novaone/models/models.dart';

class GooglePlacesPrediction extends Equatable {
  final String description;
  final String placeId;
  final String reference;
  final GooglePlacesStructuredFormatting structuredFormatting;

  GooglePlacesPrediction(
      {required this.description,
      required this.structuredFormatting,
      required this.placeId,
      required this.reference});

  @override
  List<Object?> get props => [];

  Map<String, dynamic> toJson() => {
        'description': description,
        'place_id': placeId,
        'reference': reference,
        'structured_formatting': structuredFormatting.toJson(),
      };

  factory GooglePlacesPrediction.fromJson(
      {required Map<String, dynamic> json}) {
    return GooglePlacesPrediction(
        description: json['description'],
        placeId: json['place_id'],
        reference: json['reference'],
        structuredFormatting: GooglePlacesStructuredFormatting.fromJson(
            json: json['structured_formatting']));
  }
}
