import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:novaone/controllers/controller.dart';
import 'package:novaone/enums/enums.dart';
import 'package:novaone/models/models.dart';
import 'package:novaone/screens/addObject/addObjectScreenLayout.dart';
import 'package:novaone/screens/addObject/bloc/add_object_bloc.dart';
import 'package:novaone/screens/screens.dart';
import 'package:novaone/utils/utils.dart';
import 'package:novaone/widgets/widgets.dart';

/// The base class for info card widgets. It contains all the form fields needed to add objects locally and on the server
class InfoCardsBase extends StatefulWidget {
  final List<Company> companies;
  final int leadCount;
  final int appointmentCount;
  final int companyCount;

  const InfoCardsBase(
      {Key? key,
      required this.companies,
      required this.leadCount,
      required this.appointmentCount,
      required this.companyCount})
      : super(key: key);

  @override
  State<InfoCardsBase> createState() => InfoCardsBaseState();
}

class InfoCardsBaseState<T extends InfoCardsBase> extends State<T> {
  // -----------------------------Company Fields BEGIN----------------------------------------------------- //

  /// The value obtained for the [Company] name from the form field for adding a company
  String? companyName;

  /// The value obtained for the [Company] email from the form field for adding a company
  String? companyEmail;

  /// The value obtained for the [Company] phone number from the form field for adding a company
  String? companyPhoneNumber;

  /// The value obtained for the [Company] address from the form field for adding a company
  String? companyAddress;

  /// The value obtained for the [Company] city from the form field for adding a company
  String? companyCity;

  /// The value obtained for the [Company] state from the form field for adding a company
  String? companyState;

  /// The value obtained for the [Company] zip from the form field for adding a company
  String? companyZip;

  /// The value obtained for the [Company] allow same day appointments from the form field for adding a company
  bool? companyAllowSameDayAppointments;

  /// The text controller for the address autocomplete field
  final TextEditingController addressAutoCompleteTextController =
      TextEditingController();

  /// The text controller for the city field
  final TextEditingController cityTextController = TextEditingController();

  /// The text controller for the zip field
  final TextEditingController zipTextController = TextEditingController();

  /// The controller for the [DropdownConfigured]
  final DropdownConfiguredController<String> dropdownConfiguredController =
      DropdownConfiguredController(
          DropdownConfigured.generateDropdownStateItems);

  // -----------------------------Company Fields END----------------------------------------------------- //

  // -----------------------------Appointnment Fields BEGIN----------------------------------------------------- //
  /// The value obtained for the [Appointment] company from the form field for the adding a lead
  Company? appointmentCompany;

  /// The name of the person with the appointment
  String? appointmentName;

  /// The phone number of the person with the appointment
  String? appointmentPhone;

  /// The date of the appointment
  DateTime? appointmentDate = DateTime.now();

  /// The time of the appointment
  TimeOfDay? appointmentTime = TimeOfDay.now();

  /// The time of the appointment
  UnitTypes? appointmentUnitType;

  // -----------------------------Appointnment Fields END----------------------------------------------------- //

  // -----------------------------Lead Fields BEGIN----------------------------------------------------- //

  /// The value obtained for the [Lead] name from the form field for the adding a lead
  String? leadName;

  /// The value obtained for the [Lead] email from the form field for the adding a lead
  String? leadEmail;

  /// The value obtained for the [Lead] phone from the form field for the adding a lead
  String? leadPhone;

  /// The value obtained for the [Lead] [Company] from the form field for the adding a lead
  Company? leadCompany;

  /// The value obtained for the [Lead] renter company from the form field for the adding a lead
  RenterBrands? leadRenterBrand = RenterBrands.Zillow;

  // -----------------------------Lead Fields END----------------------------------------------------- //

  void dispose() {
    addressAutoCompleteTextController.dispose();
    cityTextController.dispose();
    zipTextController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _initialize();
    super.initState();
  }

  /// Initialize variables
  void _initialize() {
    appointmentCompany = widget.companies.first;
    leadCompany = widget.companies.first;
  }

  void goToAddLeadScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (BuildContext context) {
        return AddObjectScreenLayout(
          fields: LeadsScreen.generateAddObjectFormFields(
              context: context,
              companies: widget.companies,
              onCompanySelected: (Company? company) => leadCompany = company,
              onEmailSave: (String? email) => leadEmail = email,
              onNameSave: (String? name) => leadName = name,
              onPhoneSave: (String? phone) => leadPhone = phone,
              onRenterBrandSelected: (RenterBrands? brand) =>
                  leadRenterBrand = brand),
          appBarTitle: 'Add Lead',
          onSubmitPressed: () {
            /// Send form information in a bloc event
            final lead = Lead(
                email: leadEmail,
                phoneNumber: leadPhone,
                name: leadName ?? 'No name',
                id: 0,
                dateOfInquiry: DateTime.now(),
                companyId: leadCompany?.id ?? 0,
                filledOutForm: false,
                renterBrand: InputMobilePortrait.getRenterBrandString(
                    leadRenterBrand ?? RenterBrands.Zillow),
                madeAppointment: false,
                companyName: leadCompany?.name ?? 'Company name');
            BlocProvider.of<AddObjectBloc>(context)
                .add(AddObjectInformationSubmitted(lead));
          },
          successTitle: 'Lead Added!',
          successMessage: 'The lead has been successfully added.',
        );
      }),
    );
  }

  /// Navigates the user to the add company screen
  void goToAddCompanyScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (BuildContext context) {
        return AddObjectScreenLayout(
          fields: CompaniesScreen.generateAddObjectFormFields(
            context: context,
            addressAutoCompleteTextController:
                addressAutoCompleteTextController,
            onAddressItemTap: (Future<GooglePlacesPlace> place) async {
              final googlePlace = await place;
              final addressComponents =
                  ValueExtractor.getAddressComponentsFromGooglePlace(
                      googlePlace);
              companyAddress = addressComponents.first;
              companyCity = addressComponents[1];
              companyState = addressComponents[2];
              companyZip = addressComponents[3];

              /// Set the values for city, state, and zip fields
              cityTextController.text = companyCity ?? '';
              zipTextController.text = companyZip ?? '';
              dropdownConfiguredController.value = companyState;
            },
            cityTextController: cityTextController,
            dropdownConfiguredController: dropdownConfiguredController,
            onCitySave: (String? city) => companyCity = city,
            onEmailSave: (String? email) => companyEmail = email,
            onNameSave: (String? name) => companyName = name,
            onPhoneSave: (String? phone) => companyPhoneNumber = phone,
            onSameDayAppointmentSelected: (bool? value) =>
                companyAllowSameDayAppointments = value,
            onStateSelected: (String? state) => companyState = state,
            onZipSaved: (String? zip) => companyZip = zip,
            zipTextController: zipTextController,
          ),
          appBarTitle: 'Add Company',
          onSubmitPressed: () {
            /// Send form information in a bloc event
            final company = Company(
                address: companyAddress ?? '',
                allowSameDayAppointments:
                    companyAllowSameDayAppointments ?? false,
                autoRespondNumber: '',
                autoRespondText: '',
                city: companyCity ?? '',
                created: DateTime.now(),
                customerUserId: 0,
                daysOfTheWeekEnabled: '0,1,2,3,4,5,6',
                email: companyEmail ?? '',
                hoursOfTheDayEnabled: '9,10,11,12,13,14,15,16,17',
                id: 0,
                name: companyName ?? '',
                phoneNumber: companyPhoneNumber ?? '',
                state: companyState ?? '',
                zip: companyZip ?? '');
            BlocProvider.of<AddObjectBloc>(context)
                .add(AddObjectInformationSubmitted(company));
          },
          successTitle: 'Company Added!',
          successMessage: 'The company has been successfully added.',
        );
      }),
    );
  }

  /// Navigates the user to the add lead screen
  void goToAddAppointmentScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (BuildContext context) {
        return AddObjectScreenLayout(
          fields: AppointmentsScreen.generateAddObjectFormFields(
              context: context,
              companies: widget.companies,
              onNameSave: (String? name) {
                appointmentName = name;
              },
              onCompanySelected: (Company? company) =>
                  appointmentCompany = company,
              onDateSelected: (DateTime? date) => appointmentDate = date,
              onPhoneSave: (String? phone) => appointmentPhone = phone,
              onTimeSelected: (TimeOfDay? time) => appointmentTime = time,
              onUnitTypeSelected: (UnitTypes? type) =>
                  appointmentUnitType = type),
          appBarTitle: 'Add Appointment',
          onSubmitPressed: () {
            /// Prepare appointment time information
            final now = DateTime.now();
            appointmentDate = DateTime(
              appointmentDate?.year ?? now.year,
              appointmentDate?.month ?? now.month,
              appointmentDate?.day ?? now.day,
              appointmentTime?.hour ?? now.hour,
              appointmentTime?.minute ?? now.minute,
            );

            /// Send form information in a bloc event
            final appointment = Appointment(
                name: appointmentName ?? 'No name',
                id: 0,
                phoneNumber: appointmentPhone ?? 'No phone',
                time: appointmentDate ?? DateTime.now(),
                timeZone: 'America/New_York',
                confirmed: false,
                unitType: InputMobilePortrait.getUnitTypeString(
                    appointmentUnitType ?? UnitTypes.OneBedroomApartment),
                companyId: appointmentCompany?.id ?? 0);
            BlocProvider.of<AddObjectBloc>(context)
                .add(AddObjectInformationSubmitted(appointment));
          },
          successTitle: 'Appointment Added!',
          successMessage: 'The appointment has been successfully added.',
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.shrink();
  }
}
