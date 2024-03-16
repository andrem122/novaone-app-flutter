import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:novaone/responsive/orientationLayout.dart';
import 'package:novaone/responsive/screenTypeLayout.dart';
import 'package:novaone/screens/slider/bloc/slider_screen_bloc.dart';
import 'package:novaone/screens/slider/sliderScreenMobile.dart';

class SliderScreenLayout extends StatelessWidget {
  const SliderScreenLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SliderScreenBloc, SliderScreenState>(
      builder: (BuildContext context, SliderScreenState state) {
        return _buildLoaded(context: context);
      },
    );
  }

  Widget _buildLoaded({required BuildContext context}) {
    return ScreenTypeLayout(
      mobile: OrientationLayout(
        portrait: SliderScreenMobilePortrait(),
      ),
    );
  }
}
