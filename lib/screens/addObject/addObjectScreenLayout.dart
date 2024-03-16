import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:novaone/models/models.dart';
import 'package:novaone/palette.dart';
import 'package:novaone/responsive/responsive.dart';
import 'package:novaone/screens/addObject/addObjectScreenMobile.dart';
import 'package:novaone/screens/appointments/bloc/appointments_screen_bloc.dart';
import 'package:novaone/screens/companies/bloc/companies_screen_bloc.dart';
import 'package:novaone/screens/leads/bloc/leads_screen_bloc.dart';
import 'package:novaone/widgets/widgets.dart';

import 'bloc/add_object_bloc.dart';

/// The class used to add objects both locally and on the server
class AddObjectScreenLayout extends BaseStatefulWidget {
  const AddObjectScreenLayout(
      {Key? key,
      required this.fields,
      required this.appBarTitle,
      required this.onSubmitPressed,
      required this.successTitle,
      required this.successMessage})
      : super(key: key);

  /// The fields needed to create the form
  final List<Widget> fields;

  /// The title used for the app bar
  final String appBarTitle;

  /// The function that is called when the submit button is pressed
  final void Function() onSubmitPressed;

  /// The title used for the success screen after adding an object successfully
  final String successTitle;

  /// The message used for the success screen after adding an object successfully
  final String successMessage;

  @override
  BaseLayoutState createState() => _AddObjectScreenLayoutState();
}

class _AddObjectScreenLayoutState extends BaseLayoutState<AddObjectScreenLayout,
    AddObjectLoaded, AddObjectError, AddObjectEmpty> {
  bool _load = false;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddObjectBloc, AddObjectState>(
      listener: (BuildContext context, AddObjectState state) {
        setState(() {
          _load = false;
        });
        if (state is AddObjectCreated) {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (BuildContext context) {
              return SuccessDisplay(
                  title: widget.successTitle,
                  subtitle: widget.successMessage,
                  onDoneButtonPressed: () {
                    int count = 0;
                    Navigator.of(context).popUntil((route) => count++ >= 2);

                    /// Refresh the page to show the new object in the list table
                    refreshTable(state, context);
                  });
            }),
          );
        }

        if (state is AddObjectAppointmentError) {
          Navigator.of(context).push(
            ModalPopup(
                title: 'Error',
                subtitle: state.error.reason ??
                    'An error has occurred. Please try again.',
                showActionButton: false),
          );
        }

        if (state is AddObjectLoading) {
          setState(() {
            _load = true;
          });
        }
      },
      builder: (context, state) {
        if (state is AddObjectLoaded) {
          return buildLoaded(context, state);
        }

        if (state is AddObjectError) {
          return buildError(context, state);
        }

        return buildLoaded(context, AddObjectLoaded(key: UniqueKey()));
      },
    );
  }

  void refreshTable(AddObjectCreated state, BuildContext context) {
    switch (state.object.runtimeType) {
      case Lead:
        BlocProvider.of<LeadsScreenBloc>(context).add(
          LeadsScreenRefreshTable(key: UniqueKey(), forceRemote: true),
        );
        break;
      case Appointment:
        BlocProvider.of<AppointmentsScreenBloc>(context).add(
          AppointmentsScreenRefreshTable(key: UniqueKey(), forceRemote: true),
        );
        break;
      case Company:
        BlocProvider.of<CompaniesScreenBloc>(context).add(
          CompaniesScreenRefreshTable(key: UniqueKey(), forceRemote: true),
        );
        break;
    }
  }

  @override
  Widget buildError(BuildContext context, AddObjectError state) {
    return ErrorDisplay(
      errorReason: state.error,
      onPressed: () {},
    );
  }

  @override
  Widget buildLoaded(BuildContext context, AddObjectLoaded state) {
    return Stack(
      children: <Widget>[
        ScreenTypeLayout(
          mobile: OrientationLayout(
            portrait: AddObjectScreenMobilePortrait(
              onSubmitPressed: widget.onSubmitPressed,
              fields: widget.fields,
              appBarTitle: widget.appBarTitle,
            ),
          ),
        ),
        if (_load == true)
          Align(
            child: NovaOneLoadingIndicator(
              backgroundColor: Colors.white,
              title: 'Adding',
            ),
            alignment: FractionalOffset.center,
          ),
      ],
    );
  }

  @override
  Widget buildLoading(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: Palette.primaryColor,
      ),
    );
  }
}
