import 'package:flutter/material.dart';
import 'package:novaone/palette.dart';

/// Extension for the snack bar on a scaffold widget
extension ScaffoldStateExtension on ScaffoldState {
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showCustomSnackBar({
    required String message,
    Duration? duration,
    TextStyle? style,
    Color? backgroundColor,
  }) {
    // Default values for null arguments
    duration = duration ?? const Duration(seconds: 2);
    style = style ??
        Theme.of(context)
            .textTheme
            .bodyText2!
            .copyWith(color: Colors.white, fontSize: 17);
    backgroundColor = backgroundColor ?? Palette.primaryColor;

    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            child: Text(
              message,
            ),
          ),
          IconButton(
            onPressed: () =>
                ScaffoldMessenger.of(context).hideCurrentSnackBar(),
            icon: Icon(
              Icons.close,
              color: Colors.white,
            ),
          ),
        ],
      ),
      backgroundColor: backgroundColor,
      duration: duration,
    ));
  }

  /// Shows the error snack bar with a custom [error] message
  ///
  /// An optional [duration] and [style] for the error snack bar message can be specified as well
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showErrorSnackBar(
      {required String error, Duration? duration, TextStyle? style}) {
    return showCustomSnackBar(
        message: error,
        backgroundColor: Colors.redAccent,
        duration: duration,
        style: style);
  }

  /// Shows the error snack bar with a custom [error] message
  ///
  /// An optional [duration] and [style] for the error snack bar message can be specified as well
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSuccessSnackBar(
      {required String message, Duration? duration, TextStyle? style}) {
    return showCustomSnackBar(
        message: message,
        backgroundColor: Colors.greenAccent,
        duration: duration,
        style: style);
  }
}

extension ScaffoldMessengerStateExtension on ScaffoldMessengerState {
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showCustomSnackBar({
    required String message,
    Duration? duration,
    TextStyle? style,
    Color? backgroundColor,
  }) {
    // Default values for null arguments
    duration = duration ?? const Duration(seconds: 2);
    style = style ??
        Theme.of(context)
            .textTheme
            .bodyText2!
            .copyWith(color: Colors.white, fontSize: 17);
    backgroundColor = backgroundColor ?? Palette.primaryColor;

    return showSnackBar(SnackBar(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            child: Text(
              message,
            ),
          ),
          IconButton(
            onPressed: () => hideCurrentSnackBar(),
            icon: Icon(
              Icons.close,
              color: Colors.white,
            ),
          ),
        ],
      ),
      backgroundColor: backgroundColor,
      duration: duration,
    ));
  }

  /// Shows the error snack bar with a custom [error] message
  ///
  /// An optional [duration] and [style] for the error snack bar message can be specified as well
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showErrorSnackBar(
      {required String error, Duration? duration, TextStyle? style}) {
    return showCustomSnackBar(
        message: error,
        backgroundColor: Colors.redAccent,
        duration: duration,
        style: style);
  }

  /// Shows the error snack bar with a custom [error] message
  ///
  /// An optional [duration] and [style] for the error snack bar message can be specified as well
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSuccessSnackBar(
      {required String message, Duration? duration, TextStyle? style}) {
    return showCustomSnackBar(
        message: message,
        backgroundColor: Colors.greenAccent,
        duration: duration,
        style: style);
  }
}
