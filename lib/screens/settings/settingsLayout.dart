import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:novaone/auth/auth.dart';
import 'package:novaone/models/models.dart';
import 'package:novaone/responsive/responsive.dart';
import 'package:novaone/screens/screens.dart';
import 'package:novaone/screens/settings/bloc/settings_bloc.dart';
import 'package:novaone/widgets/widgets.dart';

class SettingsLayout extends StatelessWidget {
  final ObjectStore objectStore;

  const SettingsLayout({Key? key, required this.objectStore}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SettingsBloc, SettingsState>(
      listener: (BuildContext context, SettingsState state) {
        if (state is SettingsSignOutTappedComplete) {
          // Navigate the user to the slider screen
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => SliderScreenLayout()));
        }
      },
      builder: (BuildContext context, SettingsState state) {
        if (state is SettingsLoading) {
          return _buildLoading(context: context);
        }

        if (state is SettingsLoaded) {
          return _buildLoaded(context: context);
        }

        if (state is SettingsError) {
          return _buildError(context: context);
        }

        return _buildLoaded(context: context);
      },
    );
  }

  Widget _buildLoaded({required BuildContext context}) {
    return FutureBuilder(
      future: _getLocalUser(),
      builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
        if (snapshot.hasData) {
          return ScreenTypeLayout(
            mobile: OrientationLayout(
              portrait: SettingsMobilePortrait(
                user: snapshot.data!,
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return _buildError(context: context);
        }

        return _buildLoading(context: context);
      },
    );
  }

  Widget _buildLoading({required BuildContext context}) {
    return SettingsScreenLoading();
  }

  Widget _buildError({required BuildContext context}) {
    return ErrorDisplay(
      onPressed: () {},
    );
  }

  Future<User> _getLocalUser() async {
    return await objectStore.getUser() ??
        User(
            customerId: 0,
            userId: 0,
            password: '',
            lastLogin: '',
            customerType: '',
            dateJoined: '',
            email: '',
            firstName: '',
            isPaying: false,
            lastName: '',
            phoneNumber: '',
            username: '',
            wantsEmailNotifications: false,
            wantsSms: false);
  }
}
