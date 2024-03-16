import 'dart:async';

import 'package:flutter/material.dart';
import 'package:novaone/constants.dart';
import 'package:novaone/palette.dart';
import 'package:novaone/screens/screens.dart';
import 'package:novaone/utils/utils.dart';
import 'package:novaone/widgets/widgets.dart';

class SliderScreenMobilePortrait extends StatefulWidget {
  SliderScreenMobilePortrait({Key? key}) : super(key: key);

  @override
  _SliderScreenMobilePortraitState createState() =>
      _SliderScreenMobilePortraitState();
}

class _SliderScreenMobilePortraitState
    extends State<SliderScreenMobilePortrait> {
  final PageController _pageController = PageController();
  late Timer _timer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _startSlidingSlides();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
    _timer.cancel();
  }

  /// Starts the timer needed to animate the page view slides
  void _startSlidingSlides() {
    _timer = Timer.periodic(Duration(seconds: 3), (Timer timer) {
      if (_currentPage < 2) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      _pageController.animateToPage(_currentPage,
          duration: Duration(milliseconds: 350), curve: Curves.easeIn);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: PageView(
              controller: _pageController,
              onPageChanged: (int page) {
                _currentPage = page;
              },
              scrollDirection: Axis.horizontal,
              physics: ClampingScrollPhysics(),
              children: <Widget>[
                _NovaOnePageViewSlide(
                    imagePath: logoImage,
                    title: 'Welcome To NovaOne',
                    subtitle: 'Automate your lead process today!'),
                _NovaOnePageViewSlide(
                    imagePath: sliderImageTexting,
                    title: '24/7 Contact',
                    subtitle:
                        'NovaOne works 24/7 to contact and qualify leads'),
                _NovaOnePageViewSlide(
                    imagePath: sliderImageCalendar,
                    title: 'Auto Appointments',
                    subtitle:
                        'NovaOne makes it easy to set up appointments with leads'),
              ],
            ),
          ),
          Expanded(
              child: Container(
            width: double.infinity,
            padding:
                const EdgeInsets.symmetric(horizontal: appHorizontalSpacing),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                NovaOneButton(
                  key: Key(Keys.instance.signUpButton),
                  onPressed: () {},
                  title: 'Sign Up',
                ),
                const SizedBox(
                  height: appVerticalSpacing,
                ),
                NovaOneOutlinedButton(
                  key: Key(Keys.instance.sliderLoginButton),
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => LoginScreenLayout())),
                  title: 'Log In',
                ),
              ],
            ),
          ))
        ],
      ),
    );
  }
}

class _NovaOnePageViewSlide extends StatelessWidget {
  const _NovaOnePageViewSlide({
    Key? key,
    required this.imagePath,
    required this.title,
    required this.subtitle,
  }) : super(key: key);

  final String imagePath;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: Palette.greetingContainerGradient),
      child: Padding(
        padding: const EdgeInsets.all(appHorizontalSpacing),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              imagePath,
              height: 150,
              width: 150,
            ),
            const SizedBox(
              height: appVerticalSpacing,
            ),
            Container(
              child: Text(title,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: Theme.of(context).textTheme.headline2?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 30)),
            ),
            const SizedBox(
              height: appVerticalSpacing,
            ),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: Theme.of(context)
                  .textTheme
                  .bodyText2
                  ?.copyWith(color: Colors.white, fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
