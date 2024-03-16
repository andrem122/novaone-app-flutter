import 'package:flutter/material.dart';
import 'package:novaone/palette.dart';

class WhiteButton extends StatelessWidget {
  final String buttonText;

  /// The function that is called when the button is tapped on
  final void Function()? onPressed;

  const WhiteButton({Key? key, required this.buttonText, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
      child: Text(
        buttonText,
        style: TextStyle(
            color: Palette.primaryColor,
            fontSize: 15,
            fontWeight: FontWeight.bold),
      ),
    );
  }
}
