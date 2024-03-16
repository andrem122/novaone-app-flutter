import 'package:flutter/material.dart';

class TitleSeperator extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool showSubtitle;
  final bool centerTitle;

  /// The function that is called when the subtitle is tapped
  final void Function()? onSubtitleTap;

  TitleSeperator(
      {Key? key,
      required this.title,
      this.subtitle,
      this.showSubtitle = false,
      this.centerTitle = false,
      this.onSubtitleTap})
      : super(key: key) {
    if (showSubtitle == false) {
      assert(onSubtitleTap == null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            title,
            textAlign: showSubtitle == false && centerTitle == true
                ? TextAlign.center
                : null,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
        showSubtitle == true
            ? GestureDetector(
                onTap: onSubtitleTap,
                child: Row(
                  children: <Widget>[
                    subtitle != null
                        ? Text(
                            subtitle!,
                            style: TextStyle(fontSize: 15),
                          )
                        : SizedBox.shrink(),
                    Icon(
                      Icons.arrow_forward_ios_sharp,
                      size: 15,
                    ),
                  ],
                ),
              )
            : SizedBox.shrink(),
      ],
    );
  }
}
