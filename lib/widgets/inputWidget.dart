import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:novaone/auth/auth.dart';
import 'package:novaone/constants.dart';
import 'package:novaone/enums/enums.dart';
import 'package:novaone/models/models.dart';
import 'package:novaone/screens/addressAutocomplete/addressAutocompleteLayout.dart';
import 'package:novaone/screens/listCompanies/listCompaniesLayout.dart';
import 'package:novaone/utils/utils.dart';
import 'package:novaone/widgets/widgets.dart';
import 'package:provider/src/provider.dart';

/// Returns the input widget based on which [inputWidgetType] is given
class InputWidget extends StatefulWidget {
  final String hintText;
  final String? Function(String?)? validator;
  final InputWidgetType inputWidgetType;
  final TextEditingController controller;
  final void Function(String)? onBinaryOptionSelected;
  final Function(String?) onCheckboxTap;
  final Function(RenterBrands?)? onRenterBrandDropdownChanged;
  final Function(UnitTypes?)? onUnitTypeDropdownChanged;
  final List<Map<String, bool>>? checkboxListItems;
  final Function(Future<GooglePlacesPlace> place)? onAddressItemTap;
  final Function(DateTime? date)? onDateSelected;
  final Function(TimeOfDay? date)? onTimeSelected;

  InputWidget({
    Key? key,
    required this.hintText,
    required this.inputWidgetType,
    required this.controller,
    this.validator,
    this.onBinaryOptionSelected,
    required this.onCheckboxTap,
    this.onRenterBrandDropdownChanged,
    this.onUnitTypeDropdownChanged,
    this.checkboxListItems,
    this.onAddressItemTap,
    this.onDateSelected,
    this.onTimeSelected,
  }) : super(key: key) {
    /// Make sure we have a list of items if our [InputWidgetType] is ListDays OR ListHours
    if (this.inputWidgetType == InputWidgetType.ListDays ||
        this.inputWidgetType == InputWidgetType.ListHours) {
      assert(checkboxListItems != null);
    }
    if (this.inputWidgetType == InputWidgetType.CalendarInput) {
      assert(onDateSelected != null && onTimeSelected != null);
    }
  }

  @override
  _InputWidgetState createState() => _InputWidgetState();
}

class _InputWidgetState extends State<InputWidget> {
  late Widget _updateWidget;

  /// The currently selected dropdown value for the renter brands dropdown
  RenterBrands? _selectedRenterBrandDropDownValue = RenterBrands.Zillow;

  /// The currently selected dropdown value for the unit types dropdown
  UnitTypes? _selectedUnitTypeDropDownValue = UnitTypes.OneBedroomApartment;

  /// Gets the count of companies in local storage
  Future<int?> _getCompanyCount(BuildContext context) async {
    final objectStore = context.read<ObjectStore>();
    return await objectStore.getObjectCount<Company>();
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.inputWidgetType) {
      case InputWidgetType.AddressInput:
        _updateWidget = AddressAutocompleteScreenLayout(
          autofocus: true,
          controller: widget.controller,
          validator: ValueChecker.instance.defaultValidator,
          onAddressItemTap:
              widget.onAddressItemTap ?? (Future<GooglePlacesPlace> place) {},
        );
        break;
      case InputWidgetType.DropdownRenterBrand:
        assert(widget.onRenterBrandDropdownChanged != null);
        _updateWidget = Padding(
          padding: const EdgeInsets.symmetric(horizontal: appHorizontalSpacing),
          child: DropdownButton<RenterBrands>(
            enableFeedback: true,
            isExpanded: true,
            elevation: 0,
            style:
                Theme.of(context).textTheme.bodyText2?.copyWith(fontSize: 18),
            value: _selectedRenterBrandDropDownValue,
            items: DropdownConfigured.generateDropdownRenterBrandItems,
            onChanged: (RenterBrands? type) {
              setState(() {
                _selectedRenterBrandDropDownValue = type;
              });

              widget.onRenterBrandDropdownChanged!(type);
            },
          ),
        );
        break;
      case InputWidgetType.DropdownUnitType:
        assert(widget.onRenterBrandDropdownChanged != null);
        _updateWidget = Padding(
          padding: const EdgeInsets.symmetric(horizontal: appHorizontalSpacing),
          child: DropdownButton<UnitTypes>(
            enableFeedback: true,
            isExpanded: true,
            elevation: 0,
            style:
                Theme.of(context).textTheme.bodyText2?.copyWith(fontSize: 18),
            value: _selectedUnitTypeDropDownValue,
            items: DropdownConfigured.generateDropdownUnitTypeItems,
            onChanged: (UnitTypes? type) {
              setState(() {
                _selectedUnitTypeDropDownValue = type;
              });

              widget.onUnitTypeDropdownChanged!(type);
            },
          ),
        );
        break;
      case InputWidgetType.CalendarInput:
        _updateWidget = DateTimePicker(
          onDateSelected: widget.onDateSelected ?? (DateTime? date) {},
          onTimeSelected: widget.onTimeSelected ?? (TimeOfDay? time) {},
        );

        break;
      case InputWidgetType.TextInput:
        _updateWidget = NovaOneTextInput(
          hintText: widget.hintText,
          autoFocus: true,
          validator: widget.validator ?? ValueChecker.instance.defaultValidator,
          controller: widget.controller,
        );
        break;
      case InputWidgetType.Multiline:
        _updateWidget = NovaOneTextInput(
          hintText: widget.hintText,
          keyboardType: TextInputType.multiline,
          maxLines: null,
          minLines: 6,
          autoFocus: true,
          validator: widget.validator ?? ValueChecker.instance.defaultValidator,
          controller: widget.controller,
        );
        break;
      case InputWidgetType.EmailInput:
        _updateWidget = NovaOneTextInput(
          hintText: widget.hintText,
          keyboardType: TextInputType.emailAddress,
          autoFocus: true,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: widget.validator ?? ValueChecker.instance.isValidEmail,
          controller: widget.controller,
        );
        break;
      case InputWidgetType.BinaryInput:
        _updateWidget = NovaOneBinaryInput(
          onPressedNo: () {
            if (widget.onBinaryOptionSelected != null) {
              widget.onBinaryOptionSelected!('f');
            }
          },
          onPressedYes: () {
            if (widget.onBinaryOptionSelected != null) {
              widget.onBinaryOptionSelected!('t');
            }
          },
        );
        break;
      case InputWidgetType.ListInput:
        _updateWidget = FutureBuilder(
            future: _getCompanyCount(context),
            builder: (BuildContext context, AsyncSnapshot<int?> snapshot) {
              if (snapshot.hasData) {
                return ListCompaniesLayout(
                  onCheckboxTap: widget.onCheckboxTap,
                  companyCount: snapshot.data ?? 0,
                );
              }
              return ErrorWidget('Could not load companies');
            });
        break;
      case InputWidgetType.ListHours:
        _updateWidget = CheckboxListItems(
          items: widget.checkboxListItems ?? [],
          onCheckboxTap: widget.onCheckboxTap,
        );
        break;
      case InputWidgetType.ListDays:
        _updateWidget = CheckboxListItems(
          items: widget.checkboxListItems ?? [],
          onCheckboxTap: widget.onCheckboxTap,
        );
        break;
      case InputWidgetType.PhoneInput:
        _updateWidget = NovaOneTextInput(
          hintText: widget.hintText,
          keyboardType: TextInputType.phone,
          autoFocus: true,
          validator: widget.validator ?? ValueChecker.instance.isValidPhone,
          controller: widget.controller,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.allow(RegExp(r'\d+')),
            PhoneNumberTextInputFormatter(1)
          ],
          maxLength: 14,
        );
        break;
    }

    return _updateWidget;
  }
}
