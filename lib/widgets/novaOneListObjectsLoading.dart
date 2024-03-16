import 'package:flutter/material.dart';
import 'package:novaone/constants.dart';
import 'package:novaone/palette.dart';
import 'package:novaone/widgets/widgets.dart';

class NovaOneListObjectsLayoutLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
      child: Shimmer(
        linearGradient: Palette.shimmerGradient,
        child: Column(
          children: <Widget>[
            _NovaOneListObjectsLayoutLoadingHeader(),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  defaultPadding, 40, defaultPadding, 5),
              child: ShimmerLoading(
                child: RoundedContainer(
                  height: 500,
                  child: SizedBox(),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _NovaOneListObjectsLayoutLoadingHeader extends StatelessWidget {
  const _NovaOneListObjectsLayoutLoadingHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.width > 320 ? size.height * 0.25 : size.height * 0.26,
      child: Stack(
        children: [
          GradientHeader(
            containerDecimalHeight: size.width > 320 ? 0.20 : 0.17,
            child: SafeArea(
                child: Center(
                    child: ShimmerLoading(
              child: RoundedContainer(
                width: 260,
                height: 40,
                child: Container(),
              ),
            ))),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: ShimmerLoading(
                child: RoundedContainer(
                  height: 54,
                  child: Container(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
