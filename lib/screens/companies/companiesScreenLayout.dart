import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:novaone/api/api.dart';
import 'package:novaone/constants.dart';
import 'package:novaone/controllers/dropdownConfiguredController.dart';
import 'package:novaone/screens/addObject/addObjectScreenLayout.dart';
import 'package:novaone/screens/addObject/bloc/add_object_bloc.dart';
import 'package:novaone/screens/addressAutocomplete/addressAutocompleteLayout.dart';
import 'package:novaone/utils/utils.dart';
import 'package:novaone/widgets/widgets.dart';
import 'package:novaone/models/models.dart';
import 'bloc/companies_screen_bloc.dart';

class CompaniesScreen extends BaseStatefulWidget {
  const CompaniesScreen({Key? key}) : super(key: key);

  /// Generate the fields needed to gather information to create a new [Lead] object
  static List<Widget> generateAddObjectFormFields(
      {required BuildContext context,
      required Function(String? name) onNameSave,
      required Function(String? phone) onPhoneSave,
      required Function(String? email) onEmailSave,
      required Function(String? city) onCitySave,
      required Function(String? zip) onZipSaved,
      required Function(String? state) onStateSelected,
      required Function(bool? value) onSameDayAppointmentSelected,
      required TextEditingController addressAutoCompleteTextController,
      required TextEditingController cityTextController,
      required TextEditingController zipTextController,
      required DropdownConfiguredController dropdownConfiguredController,
      required Function(Future<GooglePlacesPlace> place) onAddressItemTap}) {
    return <Widget>[
      Row(
        children: [
          Expanded(
            child: TextFormField(
              key: Key(Keys.instance.addCompanyName),
              keyboardType: TextInputType.text,
              onSaved: onNameSave,
              validator: ValueChecker.instance.defaultValidator,
              decoration: InputDecoration(
                hintText: 'Company Name',
                border: textFormFieldBorderStyle,
                label: InputLabel(
                  label: 'Company Name',
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
              key: Key(Keys.instance.addCompanyPhone),
              maxLength: 14,
              keyboardType: TextInputType.phone,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'\d+')),
                PhoneNumberTextInputFormatter(1)
              ],
              onSaved: onPhoneSave,
              validator: ValueChecker.instance.isValidPhone,
              decoration: InputDecoration(
                helperText:
                    ' ', // IMPORTANT: Makes each [TextFormField] that is side by side the same height, with or without error text/extra labels
                label: InputLabel(
                  label: 'Phone Number',
                  requiredField: true,
                ),
                hintText: 'Phone Number',
                border: textFormFieldBorderStyle,
              ),
            ),
          ),
          const SizedBox(
            width: appHorizontalSpacing,
          ),
          Expanded(
            child: TextFormField(
              key: Key(Keys.instance.addCompanyEmail),
              keyboardType: TextInputType.emailAddress,
              onSaved: onEmailSave,
              validator: ValueChecker.instance.isValidEmail,
              decoration: InputDecoration(
                helperText:
                    ' ', // IMPORTANT: Makes each [TextFormField] that is side by side the same height, with or without error text/extra labels
                label: InputLabel(
                  label: 'Email',
                  requiredField: true,
                ),
                hintText: 'Email',
                border: textFormFieldBorderStyle,
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
            child: AddressAutocompleteScreenLayout(
              controller: addressAutoCompleteTextController,
              onAddressItemTap: onAddressItemTap,
              validator: ValueChecker.instance.defaultValidator,
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
              controller: cityTextController,
              key: Key(Keys.instance.addCompanyCity),
              keyboardType: TextInputType.text,
              onSaved: onCitySave,
              validator: ValueChecker.instance.defaultValidator,
              decoration: InputDecoration(
                helperText:
                    ' ', // IMPORTANT: Makes each [TextFormField] that is side by side the same height, with or without error text/extra labels
                label: InputLabel(
                  label: 'City',
                  requiredField: true,
                ),
                hintText: 'City',
                border: textFormFieldBorderStyle,
              ),
            ),
          ),
          const SizedBox(
            width: appHorizontalSpacing,
          ),
          Expanded(
            child: Column(
              children: <Widget>[
                Align(
                  alignment: Alignment.centerLeft,
                  child: InputLabel(
                    label: 'State',
                    requiredField: true,
                  ),
                ),
                DropdownConfigured<String>(
                  key: Key(Keys.instance.addCompanyState),
                  hint: 'Select State',
                  isExpanded: true,
                  onChanged: (dynamic company) {
                    final casted = company as String;
                    onStateSelected(casted);
                  },
                  controller: dropdownConfiguredController,
                ),
              ],
            ),
          ),
          const SizedBox(
            width: appHorizontalSpacing,
          ),
          Expanded(
            child: TextFormField(
              controller: zipTextController,
              key: Key(Keys.instance.addCompanyZip),
              keyboardType: TextInputType.text,
              onSaved: onZipSaved,
              validator: ValueChecker.instance.defaultValidator,
              decoration: InputDecoration(
                helperText:
                    ' ', // IMPORTANT: Makes each [TextFormField] that is side by side the same height, with or without error text/extra labels
                label: InputLabel(
                  requiredField: true,
                  label: 'Zip',
                ),
                hintText: 'Zip',
                border: textFormFieldBorderStyle,
              ),
            ),
          ),
        ],
      ),
      const SizedBox(
        height: appVerticalSpacing + 30,
      ),
      Row(
        children: <Widget>[
          Expanded(
            child: Column(
              children: <Widget>[
                Align(
                  alignment: Alignment.center,
                  child: InputLabel(
                    label: 'Allow same day appointments?',
                  ),
                ),
                DropdownConfigured<bool>(
                  isExpanded: true,
                  onChanged: (dynamic value) {
                    final bool casted = value;
                    onSameDayAppointmentSelected(casted);
                  },
                  items: DropdownConfigured.generateDropdownBinaryChoiceItems,
                ),
              ],
            ),
          ),
        ],
      ),
    ];
  }

  @override
  BaseLayoutState createState() => _CompaniesScreenState();
}

class _CompaniesScreenState extends BaseLayoutState<CompaniesScreen,
    CompaniesScreenLoaded, CompaniesScreenError, CompaniesScreenEmpty> {
  /// The value obtained for the [Company] name from the form field for adding a company
  String? _companyName;

  /// The value obtained for the [Company] email from the form field for adding a company
  String? _companyEmail;

  /// The value obtained for the [Company] phone number from the form field for adding a company
  String? _companyPhoneNumber;

  /// The value obtained for the [Company] address from the form field for adding a company
  String? _companyAddress;

  /// The value obtained for the [Company] city from the form field for adding a company
  String? _companyCity;

  /// The value obtained for the [Company] state from the form field for adding a company
  String? _companyState;

  /// The value obtained for the [Company] zip from the form field for adding a company
  String? _companyZip;

  /// The value obtained for the [Company] allow same day appointments from the form field for adding a company
  bool? _companyAllowSameDayAppointments;

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

  @override
  void dispose() {
    addressAutoCompleteTextController.dispose();
    cityTextController.dispose();
    zipTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CompaniesScreenBloc, CompaniesScreenState>(
      builder: (BuildContext context, CompaniesScreenState state) {
        if (state is CompaniesScreenLoaded) {
          return buildLoaded(context, state);
        }

        if (state is CompaniesScreenLoading) {
          return buildLoading(context);
        }

        if (state is CompaniesScreenError) {
          return buildError(context, state);
        }

        return Container();
      },
    );
  }

  Widget buildLoaded(BuildContext context, CompaniesScreenLoaded state) {
    return NovaOneListObjectsLayout(
      key:
          UniqueKey(), // Add key here because the table will not rebuild to show updated data if the table data is refreshed
      onFloatingActionButtonPressed: () {
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
                  _companyAddress = addressComponents.first;
                  _companyCity = addressComponents[1];
                  _companyState = addressComponents[2];
                  _companyZip = addressComponents[3];

                  /// Set the values for city, state, and zip fields
                  cityTextController.text = _companyCity ?? '';
                  zipTextController.text = _companyZip ?? '';
                  dropdownConfiguredController.value = _companyState;
                },
                cityTextController: cityTextController,
                dropdownConfiguredController: dropdownConfiguredController,
                onCitySave: (String? city) => _companyCity = city,
                onEmailSave: (String? email) => _companyEmail = email,
                onNameSave: (String? name) => _companyName = name,
                onPhoneSave: (String? phone) => _companyPhoneNumber = phone,
                onSameDayAppointmentSelected: (bool? value) =>
                    _companyAllowSameDayAppointments = value,
                onStateSelected: (String? state) => _companyState = state,
                onZipSaved: (String? zip) => _companyZip = zip,
                zipTextController: zipTextController,
              ),
              appBarTitle: 'Add Company',
              onSubmitPressed: () {
                /// Send form information in a bloc event
                final company = Company(
                    address: _companyAddress ?? '',
                    allowSameDayAppointments:
                        _companyAllowSameDayAppointments ?? false,
                    autoRespondNumber: '',
                    autoRespondText: '',
                    city: _companyCity ?? '',
                    created: DateTime.now(),
                    customerUserId: 0,
                    daysOfTheWeekEnabled: '0,1,2,3,4,5,6',
                    email: _companyEmail ?? '',
                    hoursOfTheDayEnabled: '9,10,11,12,13,14,15,16,17',
                    id: 0,
                    name: _companyName ?? '',
                    phoneNumber: _companyPhoneNumber ?? '',
                    state: _companyState ?? '',
                    zip: _companyZip ?? '');
                BlocProvider.of<AddObjectBloc>(context)
                    .add(AddObjectInformationSubmitted(company));
              },
              successTitle: 'Company Added!',
              successMessage: 'The company has been successfully added.',
            );
          }),
        );
      },
      tableItems: state.listTableItems,
      title: 'All Companies',
      heroTag: 'add_company',
      apiClient: context.read<CompaniesApiClient>(),
      floatingActionButtonKey:
          Key(Keys.instance.addCompanyFloatingActionButton),
    );
  }

  Widget buildLoading(BuildContext context) {
    return NovaOneListObjectsLayoutLoading();
  }

  Widget buildError(BuildContext context, CompaniesScreenError state) {
    return ErrorDisplay(
      onPressed: () {},
    );
  }
}
