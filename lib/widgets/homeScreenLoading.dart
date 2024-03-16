import 'package:flutter/material.dart';
import 'package:novaone/constants.dart';
import 'package:novaone/palette.dart';
import 'package:novaone/widgets/widgets.dart';

class HomeMobilePortraitLoading extends StatelessWidget {
  const HomeMobilePortraitLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      linearGradient: Palette.shimmerGradient,
      child: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: GreetingContainer(
              containerDecimalHeight: 0.30,
            ),
          ),
          SliverPadding(
              padding: const EdgeInsets.fromLTRB(appHorizontalSpacing,
                  appVerticalSpacing, appHorizontalSpacing, 0),
              sliver: SliverToBoxAdapter(
                child: SafeArea(
                  bottom: false,
                  top: false,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      ShimmerLoading(
                        child: RoundedContainer(
                          height: 30,
                          width: 170,
                        ),
                      ),
                      ShimmerLoading(
                        child: RoundedContainer(
                          height: 30,
                          width: 100,
                        ),
                      ),
                    ],
                  ),
                ),
              )),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(appHorizontalSpacing,
                appVerticalSpacing, appHorizontalSpacing, 0),
            sliver: SliverToBoxAdapter(
              child: SafeArea(
                top: false,
                bottom: false,
                child: buildInfoCardsLoading(),
              ),
            ),
          ),
          SliverPadding(
              padding: const EdgeInsets.fromLTRB(appHorizontalSpacing,
                  appVerticalSpacing, appHorizontalSpacing, 0),
              sliver: SliverToBoxAdapter(
                child: SafeArea(
                  top: false,
                  bottom: false,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      ShimmerLoading(
                        child: RoundedContainer(
                          height: 30,
                          width: 170,
                        ),
                      ),
                    ],
                  ),
                ),
              )),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(appHorizontalSpacing,
                appVerticalSpacing, appHorizontalSpacing, 0),
            sliver: SliverToBoxAdapter(
                child: SafeArea(
              top: false,
              bottom: false,
              child: ShimmerLoading(
                  child: RoundedContainer(
                height: 350,
                width: double.infinity,
              )),
            )),
          ),
          SliverPadding(
              padding: const EdgeInsets.fromLTRB(appHorizontalSpacing,
                  appVerticalSpacing, appHorizontalSpacing, 0),
              sliver: SliverToBoxAdapter(
                child: SafeArea(
                  top: false,
                  bottom: false,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      ShimmerLoading(
                        child: RoundedContainer(
                          height: 30,
                          width: 170,
                        ),
                      ),
                      ShimmerLoading(
                        child: RoundedContainer(
                          height: 30,
                          width: 100,
                        ),
                      ),
                    ],
                  ),
                ),
              )),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(appHorizontalSpacing,
                appVerticalSpacing, appHorizontalSpacing, 0),
            sliver: SliverToBoxAdapter(
              child: SafeArea(
                top: false,
                bottom: false,
                child: ShimmerLoading(
                    child: RoundedContainer(
                  height: 350,
                  width: double.infinity,
                )),
              ),
            ),
          ),
          SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                  appHorizontalSpacing, 10, appHorizontalSpacing, 0),
              sliver: SliverToBoxAdapter(
                child: SafeArea(
                  top: false,
                  bottom: false,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      ShimmerLoading(
                        child: RoundedContainer(
                          height: 30,
                          width: 170,
                        ),
                      ),
                      ShimmerLoading(
                        child: RoundedContainer(
                          height: 30,
                          width: 100,
                        ),
                      ),
                    ],
                  ),
                ),
              )),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(appHorizontalSpacing,
                appVerticalSpacing, appHorizontalSpacing, 0),
            sliver: SliverToBoxAdapter(
              child: SafeArea(
                top: false,
                bottom: false,
                child: ShimmerLoading(
                  child: RoundedContainer(
                    height: 350,
                    width: double.infinity,
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: const SizedBox(
              height: lastWidgetVerticalSpacing,
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the loading animation for the info cards
  static Column buildInfoCardsLoading() {
    return Column(
      children: <Widget>[
        ShimmerLoading(
            child: RoundedContainer(
          height: 120,
        )),
        const SizedBox(
          height: appVerticalSpacing,
        ),
        ShimmerLoading(
            child: RoundedContainer(
          height: 120,
        )),
        const SizedBox(
          height: appVerticalSpacing,
        ),
        ShimmerLoading(
            child: RoundedContainer(
          height: 120,
        )),
      ],
    );
  }
}

class HomeMobileLandscapeLoading extends StatelessWidget {
  const HomeMobileLandscapeLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      linearGradient: Palette.shimmerGradient,
      child: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: GreetingContainer(
              containerDecimalHeight: 0.60,
            ),
          ),
          SliverPadding(
              padding: const EdgeInsets.fromLTRB(appHorizontalSpacing,
                  appVerticalSpacing, appHorizontalSpacing, 0),
              sliver: SliverToBoxAdapter(
                child: SafeArea(
                  bottom: false,
                  top: false,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      ShimmerLoading(
                        child: RoundedContainer(
                          height: 30,
                          width: 170,
                        ),
                      ),
                      ShimmerLoading(
                        child: RoundedContainer(
                          height: 30,
                          width: 100,
                        ),
                      ),
                    ],
                  ),
                ),
              )),
          SliverPadding(
              padding: const EdgeInsets.fromLTRB(appHorizontalSpacing,
                  appVerticalSpacing, appHorizontalSpacing, 0),
              sliver: SliverToBoxAdapter(
                  child: SafeArea(
                      top: false,
                      bottom: false,
                      child: Column(
                        children: <Widget>[
                          ShimmerLoading(
                              child: RoundedContainer(
                            height: 120,
                          )),
                          const SizedBox(
                            height: appVerticalSpacing,
                          ),
                          ShimmerLoading(
                              child: RoundedContainer(
                            height: 120,
                          )),
                          const SizedBox(
                            height: appVerticalSpacing,
                          ),
                          ShimmerLoading(
                              child: RoundedContainer(
                            height: 120,
                          )),
                        ],
                      )))),
          SliverPadding(
              padding: const EdgeInsets.fromLTRB(appHorizontalSpacing,
                  appVerticalSpacing, appHorizontalSpacing, 0),
              sliver: SliverToBoxAdapter(
                child: SafeArea(
                  top: false,
                  bottom: false,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      ShimmerLoading(
                        child: RoundedContainer(
                          height: 30,
                          width: 170,
                        ),
                      ),
                    ],
                  ),
                ),
              )),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(appHorizontalSpacing,
                appVerticalSpacing, appHorizontalSpacing, 0),
            sliver: SliverToBoxAdapter(
                child: SafeArea(
              top: false,
              bottom: false,
              child: ShimmerLoading(
                  child: RoundedContainer(
                height: 350,
                width: double.infinity,
              )),
            )),
          ),
          SliverPadding(
              padding: const EdgeInsets.fromLTRB(appHorizontalSpacing,
                  appVerticalSpacing, appHorizontalSpacing, 0),
              sliver: SliverToBoxAdapter(
                child: SafeArea(
                  top: false,
                  bottom: false,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      ShimmerLoading(
                        child: RoundedContainer(
                          height: 30,
                          width: 170,
                        ),
                      ),
                      ShimmerLoading(
                        child: RoundedContainer(
                          height: 30,
                          width: 100,
                        ),
                      ),
                    ],
                  ),
                ),
              )),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(appHorizontalSpacing,
                appVerticalSpacing, appHorizontalSpacing, 0),
            sliver: SliverToBoxAdapter(
              child: SafeArea(
                top: false,
                bottom: false,
                child: ShimmerLoading(
                    child: RoundedContainer(
                  height: 350,
                  width: double.infinity,
                )),
              ),
            ),
          ),
          SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                  appHorizontalSpacing, 10, appHorizontalSpacing, 0),
              sliver: SliverToBoxAdapter(
                child: SafeArea(
                  top: false,
                  bottom: false,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      ShimmerLoading(
                        child: RoundedContainer(
                          height: 30,
                          width: 170,
                        ),
                      ),
                      ShimmerLoading(
                        child: RoundedContainer(
                          height: 30,
                          width: 100,
                        ),
                      ),
                    ],
                  ),
                ),
              )),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(appHorizontalSpacing,
                appVerticalSpacing, appHorizontalSpacing, 0),
            sliver: SliverToBoxAdapter(
              child: SafeArea(
                top: false,
                bottom: false,
                child: ShimmerLoading(
                  child: RoundedContainer(
                    height: 350,
                    width: double.infinity,
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: const SizedBox(
              height: lastWidgetVerticalSpacing,
            ),
          ),
        ],
      ),
    );
  }
}

class HomeTabletPortraitLoading extends StatelessWidget {
  const HomeTabletPortraitLoading({Key? key}) : super(key: key);

  /// Builds the loading animation for the info cards
  static Row buildInfoCardsLoading() {
    return Row(
      children: <Widget>[
        Expanded(
          child: ShimmerLoading(
              child: RoundedContainer(
            height: 240,
          )),
        ),
        const SizedBox(
          width: appHorizontalSpacing,
        ),
        Expanded(
          child: ShimmerLoading(
              child: RoundedContainer(
            height: 240,
          )),
        ),
        const SizedBox(
          width: appHorizontalSpacing,
        ),
        Expanded(
          child: ShimmerLoading(
            child: RoundedContainer(
              height: 240,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      linearGradient: Palette.shimmerGradient,
      child: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: GreetingContainer(
              containerDecimalHeight: 0.30,
            ),
          ),
          SliverPadding(
              padding: const EdgeInsets.fromLTRB(appHorizontalSpacing,
                  appVerticalSpacing, appHorizontalSpacing, 0),
              sliver: SliverToBoxAdapter(
                child: SafeArea(
                  bottom: false,
                  top: false,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      ShimmerLoading(
                        child: RoundedContainer(
                          height: 30,
                          width: 170,
                        ),
                      ),
                      ShimmerLoading(
                        child: RoundedContainer(
                          height: 30,
                          width: 100,
                        ),
                      ),
                    ],
                  ),
                ),
              )),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(appHorizontalSpacing,
                appVerticalSpacing, appHorizontalSpacing, 0),
            sliver: SliverToBoxAdapter(
              child: SafeArea(
                top: false,
                bottom: false,
                child: buildInfoCardsLoading(),
              ),
            ),
          ),
          SliverPadding(
              padding: const EdgeInsets.fromLTRB(appHorizontalSpacing,
                  appVerticalSpacing, appHorizontalSpacing, 0),
              sliver: SliverToBoxAdapter(
                child: SafeArea(
                  top: false,
                  bottom: false,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      ShimmerLoading(
                        child: RoundedContainer(
                          height: 30,
                          width: 170,
                        ),
                      ),
                    ],
                  ),
                ),
              )),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(appHorizontalSpacing,
                appVerticalSpacing, appHorizontalSpacing, 0),
            sliver: SliverToBoxAdapter(
                child: SafeArea(
              top: false,
              bottom: false,
              child: ShimmerLoading(
                  child: RoundedContainer(
                height: 350,
                width: double.infinity,
              )),
            )),
          ),
          SliverPadding(
              padding: const EdgeInsets.fromLTRB(appHorizontalSpacing,
                  appVerticalSpacing, appHorizontalSpacing, 0),
              sliver: SliverToBoxAdapter(
                child: SafeArea(
                  top: false,
                  bottom: false,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      ShimmerLoading(
                        child: RoundedContainer(
                          height: 30,
                          width: 170,
                        ),
                      ),
                      ShimmerLoading(
                        child: RoundedContainer(
                          height: 30,
                          width: 100,
                        ),
                      ),
                    ],
                  ),
                ),
              )),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(appHorizontalSpacing,
                appVerticalSpacing, appHorizontalSpacing, 0),
            sliver: SliverToBoxAdapter(
              child: SafeArea(
                top: false,
                bottom: false,
                child: ShimmerLoading(
                    child: RoundedContainer(
                  height: 350,
                  width: double.infinity,
                )),
              ),
            ),
          ),
          SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                  appHorizontalSpacing, 10, appHorizontalSpacing, 0),
              sliver: SliverToBoxAdapter(
                child: SafeArea(
                  top: false,
                  bottom: false,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      ShimmerLoading(
                        child: RoundedContainer(
                          height: 30,
                          width: 170,
                        ),
                      ),
                      ShimmerLoading(
                        child: RoundedContainer(
                          height: 30,
                          width: 100,
                        ),
                      ),
                    ],
                  ),
                ),
              )),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(appHorizontalSpacing,
                appVerticalSpacing, appHorizontalSpacing, 0),
            sliver: SliverToBoxAdapter(
              child: SafeArea(
                top: false,
                bottom: false,
                child: ShimmerLoading(
                  child: RoundedContainer(
                    height: 350,
                    width: double.infinity,
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: const SizedBox(
              height: lastWidgetVerticalSpacing,
            ),
          ),
        ],
      ),
    );
  }
}
