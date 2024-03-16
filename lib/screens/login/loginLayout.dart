import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:novaone/api/api.dart';
import 'package:novaone/auth/auth.dart';
import 'package:novaone/controllers/controller.dart';
import 'package:novaone/responsive/responsive.dart';
import 'package:novaone/screens/login/bloc/login_bloc.dart';
import 'package:novaone/screens/screens.dart';
import 'package:novaone/extensions/extensions.dart';
import 'package:novaone/widgets/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Consumes the Bloc
class LoginScreenLayout extends StatefulWidget {
  @override
  _LoginScreenLayoutState createState() => _LoginScreenLayoutState();
}

class _LoginScreenLayoutState extends State<LoginScreenLayout> {
  bool _load = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => LoginBloc(
          futurePrefs: context.read<Future<SharedPreferences>>(),
          userApiClient: context.read<UserApiClient>(),
          objectStore: context.read<ObjectStore>())
        ..add(LoginStart()),
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: BlocConsumer<LoginBloc, LoginState>(
          listener: (BuildContext context, LoginState state) {
            setState(() {
              _load = false;
            });

            if (state is LoginUser) {
              /// Navigate the user to the navigation screen
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => RepositoryProvider.value(
                        value: state.user,
                        child: NavScreen(
                          controller: context.read<NavScreenController>(),
                        ),
                      )));
            }

            if (state is LoginLoading) {
              setState(() {
                _load = true;
              });
            }

            if (state is LoginError) {
              Scaffold.of(context)
                  .showErrorSnackBar(error: state.error.reason!);
            }
          },
          builder: (BuildContext context, LoginState state) {
            if (state is LoginLoaded) {
              return _buildLoaded(context: context);
            }

            return _buildLoaded(context: context);
          },
        ),
      ),
    );
  }

  Widget _buildLoaded({required BuildContext context}) {
    Widget loadingIndicator = _load
        ? NovaOneLoadingIndicator(
            title: 'Logging In',
          )
        : SizedBox.shrink();
    return Stack(
      children: <Widget>[
        ScreenTypeLayout(
          mobile: OrientationLayout(
            portrait: LoginMobilePortrait(),
            landscape: LoginMobileLandscape(),
          ),
          tablet: LoginTabletPortrait(),
          desktop: LoginDesktopPortrait(),
        ),
        Align(
          child: loadingIndicator,
          alignment: FractionalOffset.center,
        ),
      ],
    );
  }
}
