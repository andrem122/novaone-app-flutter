import 'package:flutter/material.dart';
import 'package:novaone/enums/deviceScreenType.dart';
import 'package:novaone/widgets/widgets.dart';

class UIUtils {
  static final UIUtils instance = UIUtils._internal();
  UIUtils._internal();

  /// Gets the device type based on the device size
  DeviceScreenType getDeviceScreenType(
      {required MediaQueryData mediaQueryData}) {
    double deviceWidth = mediaQueryData.size.shortestSide;

    if (deviceWidth > 950) {
      return DeviceScreenType.Desktop;
    } else if (deviceWidth > 600) {
      return DeviceScreenType.Tablet;
    }

    return DeviceScreenType.Mobile;
  }

  /// Dismisses the keyboard from view
  dismissKeyboard(BuildContext context) {
    final FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }

  /// Pushes the success screen into view
  pushSuccessScreen(
      {required BuildContext context,
      String? successTitle,
      String? successSubtitle,
      required Function() onDoneButtonPressed}) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => SuccessDisplay(
              title: successTitle ?? SuccessDisplay.defaultTitle,
              subtitle: successSubtitle ?? SuccessDisplay.defaultSubtitle,
              onDoneButtonPressed: onDoneButtonPressed,
            )));
  }
}
