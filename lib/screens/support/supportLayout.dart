import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:novaone/responsive/responsive.dart';
import 'package:novaone/screens/support/bloc/support_bloc.dart';
import 'package:novaone/screens/support/supportMobile.dart';
import 'package:novaone/widgets/widgets.dart';

class SupportLayout extends StatelessWidget {
  const SupportLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SupportBloc, SupportState>(
      listener: (BuildContext context, SupportState state) {},
      builder: (BuildContext context, SupportState state) {
        if (state is SupportError) {
          return _buildError(context: context);
        }

        return _buildLoaded(context: context);
      },
    );
  }

  Widget _buildError({required BuildContext context}) {
    return ErrorDisplay(
      onPressed: () {},
    );
  }

  Widget _buildLoaded({required BuildContext context}) {
    return ScreenTypeLayout(
      mobile: OrientationLayout(
        portrait: SupportMobilePortrait(),
      ),
    );
  }
}
