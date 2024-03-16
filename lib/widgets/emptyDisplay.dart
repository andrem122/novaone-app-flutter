import 'package:flutter/material.dart';
import 'package:novaone/constants.dart';
import 'package:novaone/palette.dart';
import 'package:novaone/widgets/widgets.dart';

class EmptyDisplay extends StatelessWidget {
  /// The function to run when the reload button is pressed
  final void Function() onReloadPressed;

  /// The function to run when the add button is pressed
  final void Function() onAddPressed;

  /// The reason why the error has occurred
  final String emptyReason;

  /// The title for the empty screen
  final String emptyTitle;

  const EmptyDisplay({
    Key? key,
    required this.onReloadPressed,
    this.emptyReason = 'No data was found.',
    this.emptyTitle = 'No Data',
    required this.onAddPressed,
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
                Icons.topic_rounded,
                size: 100,
              ),
            ),
            Text(
              emptyTitle,
              style: Theme.of(context).textTheme.headline2!.copyWith(
                    color: Colors.black,
                    fontSize: 30,
                  ),
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              emptyReason,
              textAlign: TextAlign.center,
              style:
                  Theme.of(context).textTheme.bodyText2?.copyWith(fontSize: 16),
            ),
            const SizedBox(
              height: 30,
            ),
            NovaOneButton(
              onPressed: onReloadPressed,
              title: 'Reload',
            ),
            const SizedBox(
              height: appVerticalSpacing,
            ),
            NovaOneButton(
              onPressed: onAddPressed,
              title: 'Add',
            ),
          ],
        ),
      ),
    );
  }
}
