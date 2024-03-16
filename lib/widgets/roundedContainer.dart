import 'package:flutter/material.dart';
import 'package:novaone/constants.dart';

class RoundedContainer extends StatelessWidget {
  final Widget? child;
  final double? height;
  final double width;
  final BoxConstraints constraints;
  final List<BoxShadow>? boxShadow;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Border? border;
  final Color backgroundColor;

  const RoundedContainer({
    Key? key,
    this.child,
    this.height,
    this.width = double.infinity,
    this.constraints = const BoxConstraints(),
    this.boxShadow,
    this.padding,
    this.border,
    this.backgroundColor = Colors.white,
    this.margin,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final Widget containerWithHeight = Container(
      padding: padding ?? EdgeInsets.all(defaultPadding),
      margin: margin,
      constraints: constraints,
      height: height,
      width: width,
      decoration: BoxDecoration(
          boxShadow: boxShadow,
          color: backgroundColor,
          border: border,
          borderRadius: BorderRadius.circular(containerBorderRadius)),
      child: child,
    );

    final Widget containerWithoutHeight = Container(
      padding: padding ?? EdgeInsets.all(defaultPadding),
      margin: margin,
      width: width,
      constraints: constraints,
      decoration: BoxDecoration(
          border: border,
          color: backgroundColor,
          borderRadius: BorderRadius.circular(containerBorderRadius)),
      child: child,
    );
    return height != null ? containerWithHeight : containerWithoutHeight;
  }
}
