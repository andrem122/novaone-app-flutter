import 'package:flutter/material.dart';
import 'package:novaone/palette.dart';
import 'package:novaone/widgets/widgets.dart';

/// A widget used to display the empty status of a block of data in a [RoundedContainer]
class EmptyDataBlock extends StatelessWidget {
  /// The title used in the empty block
  final String title;

  /// The icon used in the empty block
  final Icon icon;

  const EmptyDataBlock({
    Key? key,
    this.title = 'No Data',
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RoundedContainer(
      height: 350,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            title,
            style: Theme.of(context).textTheme.headline2!.copyWith(
                  color: Colors.black,
                  fontSize: 30,
                ),
          ),
          ShaderMask(
            shaderCallback: (Rect bounds) =>
                Palette.greetingContainerGradient.createShader(bounds),
            blendMode: BlendMode.srcATop,
            child: icon,
          ),
        ],
      ),
    );
  }
}
