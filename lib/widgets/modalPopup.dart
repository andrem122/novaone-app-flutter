import 'package:flutter/material.dart';
import 'package:novaone/constants.dart';
import 'package:novaone/widgets/widgets.dart';

class ModalPopup extends ModalRoute<void> {
  /// The main title of the modal popup
  final String title;

  /// The title of the action button
  final String? actionButtonTitle;

  /// The title of the cancel or dismiss button
  final String? cancelButtonTitle;

  /// The subtitle of the modal popup
  final String subtitle;

  /// The function to call when the action button has been pressed
  final void Function()? onActionButtonPressed;

  /// The function to call when the cancel or dismiss button has been pressed
  final void Function()? onCancelButtonPressed;

  /// Whether or not to show the action button
  final bool showActionButton;

  ModalPopup({
    this.showActionButton = true,
    this.actionButtonTitle,
    this.cancelButtonTitle,
    required this.title,
    required this.subtitle,
    this.onActionButtonPressed,
    this.onCancelButtonPressed,
  }) {
    if (showActionButton == true) {
      assert(actionButtonTitle != null && onActionButtonPressed != null);
    }
  }

  @override
  Duration get transitionDuration => Duration(milliseconds: 500);

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => false;

  @override
  Color get barrierColor => Colors.black.withOpacity(0.5);

  @override
  String get barrierLabel => '';

  @override
  bool get maintainState => true;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    // This makes sure that text and other content follows the material style
    return Material(
      type: MaterialType.transparency,
      // make sure that the overlay content is not cut off
      child: SafeArea(
        child: _buildOverlayContent(context),
      ),
    );
  }

  Widget _buildOverlayContent(BuildContext context) {
    return Center(
      child: RoundedContainer(
        constraints: BoxConstraints(maxWidth: 300),
        padding: EdgeInsets.symmetric(
            vertical: modalPopupVerticalPadding, horizontal: defaultPadding),
        margin: EdgeInsets.symmetric(horizontal: appHorizontalSpacing),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.warning_rounded,
              size: 50,
              color: Colors.red,
            ),
            const SizedBox(
              height: appVerticalSpacing / 2,
            ),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .headline2
                  ?.copyWith(fontSize: 30, color: Colors.black),
            ),
            const SizedBox(
              height: appVerticalSpacing,
            ),
            Text(
              subtitle,
              style:
                  Theme.of(context).textTheme.bodyText2?.copyWith(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: appVerticalSpacing,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                if (showActionButton == true) ...[
                  NovaOneButton(
                    width: 120,
                    onPressed: onActionButtonPressed ?? () {},
                    title: actionButtonTitle ?? '',
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                ],
                NovaOneButton(
                  width: showActionButton == true ? 120 : 280,
                  onPressed: onCancelButtonPressed ??
                      () => Navigator.of(context).pop(),
                  title: cancelButtonTitle ?? 'Dismiss',
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    // You can add your own animations for the overlay content
    return FadeTransition(
      opacity: animation,
      child: ScaleTransition(
        scale: animation,
        child: child,
      ),
    );
  }
}
