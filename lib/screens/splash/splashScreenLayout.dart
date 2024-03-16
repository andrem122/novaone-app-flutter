import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:novaone/controllers/controller.dart';
import 'package:novaone/screens/screens.dart';
import 'package:novaone/screens/splash/bloc/splashScreen.dart';
import 'package:novaone/screens/splash/bloc/splash_screen_bloc.dart';

class SplashScreenLayout extends StatelessWidget {
  const SplashScreenLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SplashScreenBloc, SplashScreenState>(
        builder: (BuildContext context, SplashScreenState state) {
      return SplashScreen();
    }, listener: (BuildContext context, SplashScreenState state) {
      /// Take the user to the nav screen since they are logged in
      if (state is SplashScreenUser) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => RepositoryProvider.value(
                  value: state.user,
                  child: NavScreen(
                    controller: context.read<NavScreenController>(),
                  ),
                ),
            fullscreenDialog: true));
      }

      /// Take the user to the slider screen if an error occurs or if
      /// the user has never logged in
      if (state is SplashScreenError || state is SplashScreenUserNotLoggedIn) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => SliderScreenLayout(),
            fullscreenDialog: true));
      }
    });
  }
}
