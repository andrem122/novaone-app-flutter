import 'package:flutter/material.dart';
import 'package:novaone/palette.dart';

class CustomTabBar extends StatelessWidget {
  final List<IconData>? icons;
  final int selectedIndex;
  final Function(int) onTap;
  final TabController controller;

  const CustomTabBar(
      {Key? key,
      required this.icons,
      required this.selectedIndex,
      required this.onTap,
      required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: controller,
      indicatorPadding: EdgeInsets.zero,
      indicator: BoxDecoration(
          border:
              Border(top: BorderSide(width: 3, color: Palette.primaryColor))),
      tabs: icons!
          .asMap()
          .map((index, iconData) => MapEntry(
              index,
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Icon(
                  iconData,
                  color: index == selectedIndex
                      ? Palette.primaryColor
                      : Colors.black45,
                  size: 30,
                ),
              )))
          .values
          .toList(),
      onTap: onTap,
    );
  }
}
