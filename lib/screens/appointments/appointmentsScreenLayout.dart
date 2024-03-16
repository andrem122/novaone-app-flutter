import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:novaone/api/api.dart';
import 'package:novaone/auth/auth.dart';
import 'package:novaone/constants.dart';
import 'package:novaone/enums/enums.dart';
import 'package:novaone/models/models.dart';
import 'package:novaone/screens/addObject/addObjectScreenLayout.dart';
import 'package:novaone/screens/addObject/bloc/add_object_bloc.dart';
import 'package:novaone/screens/input/inputMobile.dart';
import 'package:novaone/utils/utils.dart';
import 'package:novaone/widgets/widgets.dart';

import 'bloc/appointments_screen_bloc.dart';

class AppointmentsScreen extends BaseStatefulWidget {
  const AppointmentsScreen({Key? key, required this.companies})
      : super(key: key);

  final List<Company> companies;

  /// Generate the fields needed to gather information to create a new [Appointment] object
  static List<Widget> generateAddObjectFormFields({
    required BuildContext context,
    required List<Company> companies,
    required Function(String? name) onNameSave,
    required Function(String? phone) onPhoneSave,
    required Function(DateTime? date) onDateSelected,
    required Function(TimeOfDay? time) onTimeSelected,
    required Function(Company? company) onCompanySelected,
    required Function(UnitTypes? type) onUnitTypeSelected,
  }) {
    return <Widget>[
      Row(
        children: <Widget>[
          Expanded(
            child: TextFormField(
              key: Key(Keys.instance.addAppointmentName),
              keyboardType: TextInputType.text,
              onSaved: onNameSave,
              validator: ValueChecker.instance.defaultValidator,
              decoration: InputDecoration(
                hintText: 'Name',
                border: textFormFieldBorderStyle,
                label: InputLabel(
                  label: 'Name',
                  requiredField: true,
                ),
              ),
            ),
          ),
        ],
      ),
      const SizedBox(
        height: appVerticalSpacing,
      ),
      Row(
        children: [
          Expanded(
            child: TextFormField(
              key: Key(Keys.instance.addAppointmentPhone),
              maxLength: 14,
              keyboardType: TextInputType.phone,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'\d+')),
                PhoneNumberTextInputFormatter(1)
              ],
              onSaved: onPhoneSave,
              validator: ValueChecker.instance.isValidPhone,
              decoration: InputDecoration(
                label: InputLabel(
                  label: 'Phone Number',
                  requiredField: true,
                ),
                hintText: 'Phone Number',
                border: textFormFieldBorderStyle,
              ),
            ),
          ),
        ],
      ),
      const SizedBox(
        height: appVerticalSpacing,
      ),
      DateTimePicker(
          onDateSelected: onDateSelected, onTimeSelected: onTimeSelected),
      const SizedBox(
        height: appVerticalSpacing + 30,
      ),
      Row(
        children: <Widget>[
          Expanded(
            child: Column(
              children: <Widget>[
                Align(
                  alignment: Alignment.centerLeft,
                  child: InputLabel(
                    label: 'Company',
                    requiredField: true,
                  ),
                ),
                DropdownConfigured<Company>(
                  key: Key(Keys.instance.addAppointmentCompany),
                  hint: 'Select Company',
                  isExpanded: true,
                  onChanged: (dynamic company) {
                    final casted = company as Company;
                    onCompanySelected(casted);
                  },
                  items: DropdownConfigured.generateDropdownCompanyItems(
                      companies),
                ),
              ],
            ),
          ),
        ],
      ),
      const SizedBox(
        height: appVerticalSpacing,
      ),
      Row(
        children: <Widget>[
          Expanded(
            child: Column(
              children: <Widget>[
                Align(
                  alignment: Alignment.centerLeft,
                  child: InputLabel(
                    label: 'Unit Type',
                    requiredField: true,
                  ),
                ),
                DropdownConfigured<UnitTypes>(
                  key: Key(Keys.instance.addAppointmentUnitType),
                  hint: 'Select Unit Type',
                  isExpanded: true,
                  onChanged: (dynamic brand) {
                    final casted = brand as UnitTypes;
                    onUnitTypeSelected(casted);
                  },
                  items: DropdownConfigured.generateDropdownUnitTypeItems,
                ),
              ],
            ),
          ),
        ],
      ),
    ];
  }

  /// Initialize the [_leadCompany] variable with a value
  Future<void> initializeCompany(
      {required BuildContext context,
      required Function(Company company) onCompanyFetch}) async {
    final ObjectStore objectStore = context.read<ObjectStore>();

    try {
      final company = (await objectStore.getObjects<Company>()).first;
      onCompanyFetch(company);
    } catch (error) {
      final company = companies.first;
      onCompanyFetch(company);
    }
  }

  @override
  BaseLayoutState createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends BaseLayoutState<
    AppointmentsScreen,
    AppointmentsScreenLoaded,
    AppointmentsScreenError,
    AppointmentsScreenEmpty> {
  /// The value obtained for the [Lead] [Company] from the form field for the adding a lead
  Company? _appointmentCompany;

  /// The name of the person with the appointment
  String? _appointmentName;

  /// The phone number of the person with the appointment
  String? _appointmentPhone;

  /// The date of the appointment
  DateTime? _appointmentDate = DateTime.now();

  /// The time of the appointment
  TimeOfDay? _appointmentTime = TimeOfDay.now();

  /// The time of the appointment
  UnitTypes? _appointmentUnitType;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: widget.initializeCompany(
            onCompanyFetch: (Company company) => _appointmentCompany = company,
            context: context),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return BlocBuilder<AppointmentsScreenBloc, AppointmentsScreenState>(
              builder: (BuildContext context, AppointmentsScreenState state) {
                if (state is AppointmentsScreenLoaded) {
                  return buildLoaded(context, state);
                }

                if (state is AppointmentsScreenLoading) {
                  return buildLoading(context);
                }

                if (state is AppointmentsScreenError) {
                  return buildError(context, state);
                }

                if (state is AppointmentsScreenEmpty) {
                  return buildEmpty(context, state);
                }

                return Container();
              },
            );
          }

          if (snapshot.hasError) {
            return buildError(
              context,
              AppointmentsScreenError(
                error: snapshot.error.toString(),
              ),
            );
          }

          return buildLoading(context);
        });
  }

  Widget buildEmpty(BuildContext context, AppointmentsScreenEmpty state) {
    return EmptyDisplay(
      onAddPressed: () => goToAddAppointmentScreen(context, state.companies),
      onReloadPressed: () =>
          BlocProvider.of<AppointmentsScreenBloc>(context).add(
        AppointmentsScreenRefreshTable(key: UniqueKey(), forceRemote: true),
      ),
      emptyTitle: 'No Appointments',
      emptyReason: 'You currently have no appointments.',
    );
  }

  Widget buildLoaded(BuildContext context, AppointmentsScreenLoaded state) {
    return NovaOneListObjectsLayout(
      key:
          UniqueKey(), // Add key here because the table will not rebuild to show updated data if the table data is refreshed
      onFloatingActionButtonPressed: () {
        goToAddAppointmentScreen(context, state.companies);
      },
      tableItems: state.listTableItems,
      title: 'All Appointments',
      heroTag: 'add_appointment',
      apiClient: context.read<AppointmentsApiClient>(),
      floatingActionButtonKey:
          Key(Keys.instance.addAppointmentFloatingActionButton),
    );
  }

  /// Goes to the add appointment screen
  void goToAddAppointmentScreen(BuildContext context, List<Company> companies) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (BuildContext context) {
        return AddObjectScreenLayout(
          fields: AppointmentsScreen.generateAddObjectFormFields(
              context: context,
              companies: companies,
              onNameSave: (String? name) {
                _appointmentName = name;
              },
              onCompanySelected: (Company? company) =>
                  _appointmentCompany = company,
              onDateSelected: (DateTime? date) => _appointmentDate = date,
              onPhoneSave: (String? phone) => _appointmentPhone = phone,
              onTimeSelected: (TimeOfDay? time) => _appointmentTime = time,
              onUnitTypeSelected: (UnitTypes? type) =>
                  _appointmentUnitType = type),
          appBarTitle: 'Add Appointment',
          onSubmitPressed: () {
            /// Prepare appointment time information
            final now = DateTime.now();
            _appointmentDate = DateTime(
              _appointmentDate?.year ?? now.year,
              _appointmentDate?.month ?? now.month,
              _appointmentDate?.day ?? now.day,
              _appointmentTime?.hour ?? now.hour,
              _appointmentTime?.minute ?? now.minute,
            );

            /// Send form information in a bloc event
            final appointment = Appointment(
                name: _appointmentName ?? 'No name',
                id: 0,
                phoneNumber: _appointmentPhone ?? 'No phone',
                time: _appointmentDate ?? DateTime.now(),
                timeZone: 'America/New_York',
                confirmed: false,
                unitType: InputMobilePortrait.getUnitTypeString(
                    _appointmentUnitType ?? UnitTypes.OneBedroomApartment),
                companyId: _appointmentCompany?.id ?? 0);
            BlocProvider.of<AddObjectBloc>(context)
                .add(AddObjectInformationSubmitted(appointment));
          },
          successTitle: 'Appointment Added!',
          successMessage: 'The appointment has been successfully added.',
        );
      }),
    );
  }

  Widget buildLoading(BuildContext context) {
    return NovaOneListObjectsLayoutLoading();
  }

  Widget buildError(BuildContext context, AppointmentsScreenError state) {
    return ErrorDisplay(
      onPressed: () {},
    );
  }
}
