import 'package:flutter/material.dart';
import 'package:novaone/enums/deviceScreenType.dart';
import 'package:novaone/responsive/responsive.dart';
import 'package:provider/provider.dart';

class ScreenTypeLayout extends StatelessWidget {
  final Widget? mobile;
  final Widget? tablet;
  final Widget? desktop;

  const ScreenTypeLayout({Key? key, this.mobile, this.tablet, this.desktop})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (BuildContext context, SizingInformation sizingInformation) {
        if (sizingInformation.deviceScreenType == DeviceScreenType.Tablet) {
          if (tablet != null)
            return Provider.value(
              value: sizingInformation,
              child: tablet,
            );
        } else if (sizingInformation.deviceScreenType ==
            DeviceScreenType.Desktop) {
          if (desktop != null)
            return Provider.value(
              value: sizingInformation,
              child: desktop,
            );
        }

        return Provider.value(value: sizingInformation, child: mobile);
      },
    );
  }
}
