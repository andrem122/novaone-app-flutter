import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:novaone/responsive/responsive.dart';
import 'package:novaone/screens/home/bloc/home_bloc.dart';
import 'package:novaone/screens/screens.dart';
import 'package:novaone/widgets/widgets.dart';

class HomeScreenLayout extends StatelessWidget {
  const HomeScreenLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is HomeLoading) {
          return _buildLoading(context: context);
        }
        if (state is HomeLoaded) {
          return _buildLoaded(context: context, state: state);
        }

        return _buildError(context: context);
      },
    );
  }

  Widget _buildLoading({required BuildContext context}) {
    return ScreenTypeLayout(
      mobile: OrientationLayout(
        portrait: HomeMobilePortraitLoading(),
        landscape: HomeMobileLandscapeLoading(),
      ),
      tablet: OrientationLayout(
        portrait: HomeTabletPortraitLoading(),
      ),
    );
  }

  Widget _buildLoaded(
      {required BuildContext context, required HomeLoaded state}) {
    return ScreenTypeLayout(
      mobile: OrientationLayout(
        portrait: HomeMobilePortrait(
          state: state,
        ),
        landscape: HomeMobileLandscape(state: state),
      ),
    );
  }

  Widget _buildError({required BuildContext context}) {
    return ErrorDisplay(
      onPressed: () {},
    );
  }
}
