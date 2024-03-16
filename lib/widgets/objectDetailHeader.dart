import 'package:flutter/material.dart';
import 'package:novaone/widgets/widgets.dart';
import '../constants.dart';

class ObjectDetailHeader extends StatelessWidget {
  final double containerDecimalHeight;
  final Color leadColor; // The color that was used in the recent leads table
  final String headerTitle;
  final String headerSubtitle;

  const ObjectDetailHeader({
    Key? key,
    required this.containerDecimalHeight,
    required this.leadColor,
    required this.headerTitle,
    required this.headerSubtitle,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: <Widget>[
        GradientHeader(
          containerDecimalHeight: 0.35,
        ),
        Positioned.fill(
          bottom: -80,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Stack(
              clipBehavior: Clip.none,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width * 0.80,
                  constraints: BoxConstraints(minWidth: 280, maxWidth: 500),
                  height: 180,
                  padding: const EdgeInsets.all(defaultPadding),
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          headerTitle,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 27),
                        ),
                        const SizedBox(
                          height: appVerticalSpacing,
                        ),
                        Text(
                          headerSubtitle,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              ?.copyWith(color: Colors.grey[600], fontSize: 16),
                        ),
                        const SizedBox(
                          height: 10,
                        ),

                        /// TODO: Put information/widgets here to replace the widgets we had before.
                      ],
                    ),
                  ),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(containerBorderRadius)),
                ),
                Positioned(
                    top: -80,
                    right: 0,
                    left: 0,
                    child: Container(
                      height: 105,
                      width: 105,
                      child: Center(
                        child: Text(
                          headerTitle[0].toUpperCase(),
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 50),
                        ),
                      ),
                      margin: EdgeInsets.only(bottom: 60),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: leadColor,
                          border: Border.all(color: Colors.white)),
                    )),
              ],
            ),
          ),
        )
      ],
    );
  }
}
