import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:novaone/api/api.dart';
import 'package:novaone/auth/auth.dart';
import 'package:novaone/auth/objectStore.dart';
import 'package:novaone/constants.dart';
import 'package:novaone/enums/enums.dart';
import 'package:novaone/models/models.dart';
import 'package:novaone/screens/addObject/addObjectScreenLayout.dart';
import 'package:novaone/screens/addObject/bloc/add_object_bloc.dart';
import 'package:novaone/screens/screens.dart';
import 'package:novaone/utils/utils.dart';
import 'package:novaone/widgets/widgets.dart';

import 'bloc/leads_screen_bloc.dart';

class LeadsScreen extends StatefulWidget {
  LeadsScreen({Key? key}) : super(key: key);

  @override
  State<LeadsScreen> createState() => _LeadsScreenState();

  /// Generate the fields needed to gather information to create a new [Lead] object
  static List<Widget> generateAddObjectFormFields({
    required BuildContext context,
    required List<Company> companies,
    required Function(String? name) onNameSave,
    required Function(String? phone) onPhoneSave,
    required Function(String? email) onEmailSave,
    required Function(Company? company) onCompanySelected,
    required Function(RenterBrands? brand) onRenterBrandSelected,
  }) {
    return <Widget>[
      Row(
        children: [
          Expanded(
            child: TextFormField(
              key: Key(Keys.instance.addLeadName),
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
              key: Key(Keys.instance.addLeadPhone),
              maxLength: 14,
              keyboardType: TextInputType.phone,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'\d+')),
                PhoneNumberTextInputFormatter(1)
              ],
              onSaved: onPhoneSave,
              validator: ValueChecker.instance.isValidPhoneCanBeEmpty,
              decoration: InputDecoration(
                helperText:
                    ' ', // IMPORTANT: Makes each [TextFormField] that is side by side the same height, with or without error text/extra labels
                label: InputLabel(
                  label: 'Phone Number',
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
              key: Key(Keys.instance.addLeadEmail),
              keyboardType: TextInputType.emailAddress,
              onSaved: onEmailSave,
              validator: ValueChecker.instance.isValidEmailCanBeEmpty,
              decoration: InputDecoration(
                helperText:
                    ' ', // IMPORTANT: Makes each [TextFormField] that is side by side the same height, with or without error text/extra labels
                label: InputLabel(
                  label: 'Email',
                ),
                hintText: 'Email',
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
                  alignment: Alignment.centerLeft,
                  child: InputLabel(
                    label: 'Company',
                    requiredField: true,
                  ),
                ),
                DropdownConfigured<Company>(
                  key: Key(Keys.instance.addLeadCompany),
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
                    label: 'Renter Brand',
                    requiredField: true,
                  ),
                ),
                DropdownConfigured<RenterBrands>(
                  key: Key(Keys.instance.addLeadRenterBrand),
                  hint: 'Select Renter Brand',
                  isExpanded: true,
                  onChanged: (dynamic brand) {
                    final casted = brand as RenterBrands;
                    onRenterBrandSelected(casted);
                  },
                  items: DropdownConfigured.generateDropdownRenterBrandItems,
                ),
              ],
            ),
          ),
        ],
      ),
    ];
  }
}

class _LeadsScreenState extends State<LeadsScreen> {
  /// The value obtained for the [Lead] name from the form field for the adding a lead
  String? _leadName;

  /// The value obtained for the [Lead] email from the form field for the adding a lead
  String? _leadEmail;

  /// The value obtained for the [Lead] phone from the form field for the adding a lead
  String? _leadPhone;

  /// The value obtained for the [Lead] [Company] from the form field for the adding a lead
  Company? _leadCompany;

  /// The value obtained for the [Lead] renter company from the form field for the adding a lead
  RenterBrands? _leadRenterBrand = RenterBrands.Zillow;

  /// Initialize the [_leadCompany] variable with a value
  Future<void> _initializeCompany() async {
    final ObjectStore objectStore = context.read<ObjectStore>();
    try {
      _leadCompany = (await objectStore.getObjects<Company>()).first;
    } catch (error) {
      print('_LeadsScreenState._initializeCompany: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initializeCompany(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return BlocBuilder<LeadsScreenBloc, LeadsScreenState>(
              builder: (BuildContext context, LeadsScreenState state) {
                if (state is LeadsScreenLoaded) {
                  return _buildLoaded(context: context, state: state);
                }

                if (state is LeadsScreenLoading) {
                  return _buildLoading(context: context);
                }

                if (state is LeadsScreenError) {
                  return _buildError(
                      context: context, errorReason: state.error);
                }

                if (state is LeadsScreenNoData) {
                  return _buildEmpty(state);
                }

                return Container();
              },
            );
          }

          if (snapshot.hasError) {
            return _buildError(
                context: context, errorReason: snapshot.error.toString());
          }

          return _buildLoading(context: context);
        });
  }

  Widget _buildEmpty(LeadsScreenNoData state) {
    return EmptyDisplay(
      onAddPressed: () => goToAddLeadScreen(context, state.companies),
      onReloadPressed: () => BlocProvider.of<LeadsScreenBloc>(context).add(
        LeadsScreenRefreshTable(key: UniqueKey(), forceRemote: true),
      ),
      emptyTitle: 'No Leads',
      emptyReason: 'You currently have no leads.',
    );
  }

  Widget _buildLoaded(
      {required BuildContext context, required LeadsScreenLoaded state}) {
    return NovaOneListObjectsLayout(
      key:
          UniqueKey(), // Add key here because the table will not rebuild to show updated data if the table data is refreshed
      onFloatingActionButtonPressed: () {
        goToAddLeadScreen(context, state.companies);
      },
      tableItems: state.listTableItems,
      title: 'All Leads',
      heroTag: 'add_lead',
      apiClient: context.read<LeadsApiClient>(),
      floatingActionButtonKey: Key(Keys.instance.addLeadFloatingActionButton),
    );
  }

  void goToAddLeadScreen(BuildContext context, List<Company> companies) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (BuildContext context) {
        return AddObjectScreenLayout(
          fields: LeadsScreen.generateAddObjectFormFields(
              context: context,
              companies: companies,
              onCompanySelected: (Company? company) => _leadCompany = company,
              onEmailSave: (String? email) => _leadEmail = email,
              onNameSave: (String? name) => _leadName = name,
              onPhoneSave: (String? phone) => _leadPhone = phone,
              onRenterBrandSelected: (RenterBrands? brand) =>
                  _leadRenterBrand = brand),
          appBarTitle: 'Add Lead',
          onSubmitPressed: () {
            /// Send form information in a bloc event
            final lead = Lead(
                email: _leadEmail,
                phoneNumber: _leadPhone,
                name: _leadName ?? 'No name',
                id: 0,
                dateOfInquiry: DateTime.now(),
                companyId: _leadCompany?.id ?? 0,
                filledOutForm: false,
                renterBrand: InputMobilePortrait.getRenterBrandString(
                    _leadRenterBrand ?? RenterBrands.Zillow),
                madeAppointment: false,
                companyName: _leadCompany?.name ?? 'Company name');
            BlocProvider.of<AddObjectBloc>(context)
                .add(AddObjectInformationSubmitted(lead));
          },
          successTitle: 'Lead Added!',
          successMessage: 'The lead has been successfully added.',
        );
      }),
    );
  }

  Widget _buildLoading({required BuildContext context}) {
    return NovaOneListObjectsLayoutLoading();
  }

  Widget _buildError(
      {required BuildContext context, required String errorReason}) {
    return ErrorDisplay(
      errorReason: errorReason,
      onPressed: () {},
    );
  }
}
