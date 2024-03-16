import 'package:flutter/material.dart';
import 'package:novaone/constants.dart';
import 'package:novaone/palette.dart';
import 'package:novaone/widgets/widgets.dart';

/// Displays the success screen when an operation is successfully completed
class SuccessDisplay extends StatelessWidget {
  static const defaultTitle = 'Success!';
  static const defaultSubtitle = 'Operation successfully completed!';

  const SuccessDisplay(
      {Key? key,
      this.title = defaultTitle,
      this.subtitle = defaultSubtitle,
      required this.onDoneButtonPressed})
      : super(key: key);

  /// The title of the success screen
  final String title;

  /// The subtitle of the success screen
  final String subtitle;

  /// The function to call when the 'Done' button is pressed
  final Function() onDoneButtonPressed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: appHorizontalSpacing),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GradientIcon(
                    gradient: Palette.greetingContainerGradient,
                    icon: Icons.check_circle_outlined,
                    size: 200,
                  ),
                  const SizedBox(
                    height: appVerticalSpacing,
                  ),
                  Text(
                    title,
                    style: Theme.of(context)
                        .textTheme
                        .headline1
                        ?.copyWith(fontSize: 34, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: appVerticalSpacing,
                  ),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  const SizedBox(
                    height: appVerticalSpacing,
                  ),
                ],
              ),
            ),
            NovaOneButton(
              onPressed: onDoneButtonPressed,
              title: 'Done',
            ),
            const SizedBox(
              height: appVerticalSpacing,
            ),
          ],
        ),
      ),
    );
  }
}
