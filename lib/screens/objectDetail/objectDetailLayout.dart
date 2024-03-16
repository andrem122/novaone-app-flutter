import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:novaone/api/api.dart';
import 'package:novaone/auth/auth.dart';
import 'package:novaone/models/models.dart';
import 'package:novaone/responsive/responsive.dart';
import 'package:novaone/screens/appointments/bloc/appointments_screen_bloc.dart';
import 'package:novaone/screens/companies/bloc/companies_screen_bloc.dart';
import 'package:novaone/screens/leads/bloc/leads_screen_bloc.dart';
import 'package:novaone/screens/objectDetail/bloc/object_detail_bloc.dart';
import 'package:novaone/screens/screens.dart';
import 'package:novaone/widgets/widgets.dart';

class ObjectDetailLayout extends StatelessWidget {
  final Color objectColor;
  final BaseModel object;
  final String headerSubtitle;
  final String headerTitle;
  final ObjectStore objectStore;

  const ObjectDetailLayout({
    Key? key,
    required this.objectColor,
    required this.headerSubtitle,
    required this.headerTitle,
    required this.object,
    required this.objectStore,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => ObjectDetailBloc(
          appointmentsApiClient: context.read<AppointmentsApiClient>(),
          companiesApiClient: context.read<CompaniesApiClient>(),
          leadsApiClient: context.read<LeadsApiClient>(),
          leadsScreenBloc: context.read<LeadsScreenBloc>(),
          appointmentsScreenBloc: context.read<AppointmentsScreenBloc>(),
          companiesScreenBloc: context.read<CompaniesScreenBloc>())
        ..add(ObjectDetailStart()),
      child: BlocBuilder<ObjectDetailBloc, ObjectDetailState>(
        builder: (BuildContext context, ObjectDetailState state) {
          if (state is ObjectDetailError) {
            _buildError(context: context);
          }

          return _buildLoaded(context: context);
        },
      ),
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
      portrait: ObjectDetailMobilePortrait(
        object: object,
        objectColor: objectColor,
        objectStore: objectStore,
      ),
    ));
  }
}
