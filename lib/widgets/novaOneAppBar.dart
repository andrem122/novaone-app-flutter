import 'package:flutter/material.dart';
import 'package:novaone/palette.dart';

class NovaOneAppBar extends StatelessWidget {
  final String title;
  final double height;
  final Widget? leading;
  final Widget? trailing;

  NovaOneAppBar(
      {Key? key,
      required this.title,
      this.height = 50,
      this.leading,
      this.trailing})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double statusbarHeight = MediaQuery.of(context).padding.top;
    return Container(
      padding: EdgeInsets.only(
        top: statusbarHeight,
      ),
      height: statusbarHeight + height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (leading != null) leading!,
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
      decoration: BoxDecoration(gradient: Palette.greetingContainerGradient),
    );
  }
}
