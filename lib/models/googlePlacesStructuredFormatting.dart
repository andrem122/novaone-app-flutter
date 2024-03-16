import 'package:equatable/equatable.dart';

class GooglePlacesStructuredFormatting extends Equatable {
  final String mainText;
  final List<Map<String, int>> mainTextMatchedSubstrings;
  final String secondaryText;

  GooglePlacesStructuredFormatting({
    required this.mainText,
    required this.mainTextMatchedSubstrings,
    required this.secondaryText,
  });

  @override
  List<Object?> get props =>
      [mainText, mainTextMatchedSubstrings, secondaryText];

  Map<String, dynamic> toJson() => {
        'main_text': mainText,
        'main_text_matched_substrings': mainTextMatchedSubstrings,
        'secondary_text': secondaryText,
      };

  factory GooglePlacesStructuredFormatting.fromJson(
      {required Map<String, dynamic> json}) {
    final List<dynamic> mainTextMatchedSubstrings =
        json['main_text_matched_substrings'];
    final List<Map<String, int>> mainTextMatchedSubstringsAsMap =
        mainTextMatchedSubstrings
            .map((map) => {
                  'length': map['length'] as int,
                  'offset': map['offset'] as int
                })
            .toList();
    return GooglePlacesStructuredFormatting(
        mainText: json['main_text'],
        mainTextMatchedSubstrings: mainTextMatchedSubstringsAsMap,
        secondaryText: json['secondary_text']);
  }
}
