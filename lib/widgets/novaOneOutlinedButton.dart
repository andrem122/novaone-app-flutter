import 'package:flutter/material.dart';
import 'package:novaone/palette.dart';
import 'package:novaone/constants.dart';

class NovaOneOutlinedButton extends StatelessWidget {
  final Function() onPressed;
  final String title;
  final EdgeInsets? margin;
  final Color color;
  final double scaleTextSize;
  final BoxConstraints constraints;

  const NovaOneOutlinedButton(
      {Key? key,
      required this.onPressed,
      this.title = 'Submit',
      this.margin,
      this.color = Palette.primaryColor,
      this.constraints = const BoxConstraints(
          minWidth: minButtonWidth,
          minHeight: minButtonHeight,
          maxWidth: maxButtonWidth),
      this.scaleTextSize = 1})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
            elevation: 0,
            padding: EdgeInsets.zero,
            side: BorderSide(color: color, width: 2),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(80))),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(80.0)),
          ),
          child: Container(
            constraints: constraints, // min sizes for Material buttons
            alignment: Alignment.center,
            child: Text(
              title,
              style: TextStyle(
                  color: color,
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
