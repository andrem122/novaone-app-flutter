import 'package:flutter/material.dart';
import 'package:novaone/enums/deviceScreenType.dart';

class SizingInformation {
  final DeviceScreenType? deviceScreenType;
  final Size screenSize;
  final Size localWidgetSize;

  SizingInformation(
      {this.deviceScreenType,
      required this.screenSize,
      required this.localWidgetSize});

  @override
  String toString() {
    return 'DeviceScreenType: $deviceScreenType, ScreenSize: $screenSize, LocalWidgetSize: $localWidgetSize';
  }
}
