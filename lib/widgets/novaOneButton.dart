import 'package:flutter/material.dart';
import 'package:novaone/palette.dart';
import 'package:novaone/constants.dart';

class NovaOneButton extends StatelessWidget {
  final Function() onPressed;
  final String title;
  final EdgeInsets? margin;
  final Color? color;
  final double scaleTextSize;
  final BoxConstraints constraints;
  final double? width;

  const NovaOneButton(
      {Key? key,
      required this.onPressed,
      this.title = 'Submit',
      this.margin,
      this.color,
      this.constraints = const BoxConstraints(
          minWidth: minButtonWidth,
          minHeight: minButtonHeight,
          maxWidth: maxButtonWidth),
      this.scaleTextSize = 1,
      this.width})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(80))),
        child: Ink(
          decoration: BoxDecoration(
            gradient: color == null ? Palette.greetingContainerGradient : null,
            color: color != null ? color : null,
            borderRadius: BorderRadius.all(Radius.circular(80.0)),
          ),
          child: Container(
            width: width,
            constraints: constraints, // min sizes for Material buttons
            alignment: Alignment.center,
            child: Text(
              title,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 17 * scaleTextSize,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
