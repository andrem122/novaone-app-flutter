import 'package:flutter/material.dart';
import 'package:novaone/constants.dart';
import 'package:novaone/palette.dart';
import 'package:novaone/widgets/widgets.dart';

class ErrorDisplay extends StatelessWidget {
  /// The function to run when the button is pressed
  final void Function() onPressed;

  /// The reason why the error has occurred
  final String? errorReason;

  const ErrorDisplay({
    Key? key,
    required this.onPressed,
    this.errorReason =
        'We could not find a network connection or something went wrong. Please try connecting again.',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(defaultPadding),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ShaderMask(
              shaderCallback: (Rect bounds) =>
                  Palette.greetingContainerGradient.createShader(bounds),
              blendMode: BlendMode.srcATop,
              child: Icon(
                Icons.error,
                size: 100,
              ),
            ),
            Text(
              'Uh oh.',
              style: Theme.of(context).textTheme.headline2!.copyWith(
                    color: Colors.black,
                  ),
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              errorReason ?? '',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyText2,
            ),
            const SizedBox(
              height: 30,
            ),
            NovaOneButton(
              onPressed: onPressed,
              title: 'Try Again',
            )
          ],
        ),
      ),
    );
  }
}
