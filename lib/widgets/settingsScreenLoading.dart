import 'package:flutter/material.dart';
import 'package:novaone/constants.dart';
import 'package:novaone/palette.dart';
import 'package:novaone/widgets/widgets.dart';

class SettingsScreenLoading extends StatelessWidget {
  const SettingsScreenLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      linearGradient: Palette.shimmerGradient,
      child: Scaffold(
        body: Column(
          children: [
            NovaOneAppBar(
              title: 'Settings',
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(defaultPadding),
                      child: ShimmerLoading(
                          child: RoundedContainer(
                        height: 367,
                        width: double.infinity,
                      )),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(defaultPadding),
                      child: ShimmerLoading(
                          child: RoundedContainer(
                        height: 178,
                        width: double.infinity,
                      )),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(defaultPadding),
                      child: ShimmerLoading(
                          child: RoundedContainer(
                        height: 241,
                        width: double.infinity,
                      )),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
