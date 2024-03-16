import 'package:flutter/material.dart';

class InputLabel extends StatelessWidget {
  const InputLabel(
      {Key? key,
      this.requiredField = false,
      required this.label,
      this.textAlign = TextAlign.start})
      : super(key: key);

  /// A boolean indicating whether or not this field is required
  ///
  /// If [requiredField] is set to true, then a red asterik * will appear after the
  /// [label]
  final bool requiredField;

  /// The text for the [InputLabel]
  final String label;

  /// How the text should be aligned horizontally
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: textAlign,
      text: TextSpan(
          text: label,
          style: Theme.of(context).textTheme.bodyText2?.copyWith(
              fontSize: 16, color: Colors.black54, fontWeight: FontWeight.bold),
          children: requiredField
              ? [
                  TextSpan(
                    text: '*',
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                ]
              : []),
    );
  }
}
