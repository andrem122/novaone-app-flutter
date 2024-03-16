import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:novaone/constants.dart';
import 'package:novaone/enums/enums.dart';
import 'package:novaone/models/models.dart';
import 'package:novaone/responsive/sizingInformation.dart';
import 'package:novaone/screens/addressAutocomplete/addressAutocompleteMobile.dart';
import 'package:novaone/utils/utils.dart';
import 'package:novaone/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:novaone/extensions/extensions.dart';

class InputMobilePortrait extends StatefulWidget {
  final String title;
  final String description;
  final String hintText;
  final InputWidgetType inputWidgetType;
  final IconData backIcon;

  /// Extra inputs after the main input
  final List<InputWidget>? extraInputs;

  /// The function to call when the submit button is pressed
  final void Function(String) onSubmitButtonPressed;

  /// The function to call when a binary button is pressed
  final void Function(String)? onBinaryOptionSelected;

  /// The text that goes in the submit button
  final String submitButtonTitle;

  /// The items listed in the checkbox list items screen if the [inputWidgetType] is is ListDays OR ListHours
  final List<Map<String, bool>>? checkboxListItems;

  /// The initial text to show for a text field if desired
  final String? initialText;

  InputMobilePortrait({
    Key? key,
    required this.title,
    required this.description,
    required this.hintText,
    required this.inputWidgetType,
    this.backIcon = Icons.arrow_back_sharp,
    required this.onSubmitButtonPressed,
    this.extraInputs,
    required this.submitButtonTitle,
    this.onBinaryOptionSelected,
    this.checkboxListItems,
    this.initialText,
  }) : super(key: key);

  @override
  _InputMobilePortraitState createState() => _InputMobilePortraitState();

  /// Get the string associated with the enum value of [RenterBrands]
  static String getRenterBrandString(RenterBrands renterBrand) {
    String stringToReturn = '';
    switch (renterBrand) {
      case RenterBrands.Zillow:
        stringToReturn = 'Zillow';
        break;
      case RenterBrands.Trulia:
        stringToReturn = 'Trulia';
        break;
      case RenterBrands.Realtor:
        stringToReturn = 'Realtor.com';
        break;
      case RenterBrands.Hotpads:
        stringToReturn = 'Hotpads';
        break;
      case RenterBrands.Craigslist:
        stringToReturn = 'Craigslist';
        break;
      case RenterBrands.Apartments:
        stringToReturn = 'Apartments.com';
        break;
      default:
        stringToReturn = 'No case matched';
    }

    return stringToReturn;
  }

  /// Get the string associated with the enum value of [UnitTypes]
  static String getUnitTypeString(UnitTypes unitType) {
    String stringToReturn = '';
    switch (unitType) {
      case UnitTypes.OneBedroomApartment:
        stringToReturn = '1 Bedroom';
        break;
      case UnitTypes.TwoBedroomApartment:
        stringToReturn = '2 Bedrooms';
        break;
      case UnitTypes.ThreeBedroomApartment:
        stringToReturn = '3 Bedrooms';
        break;
      default:
        stringToReturn = 'No case matched';
    }

    return stringToReturn;
  }
}

class _InputMobilePortraitState extends State<InputMobilePortrait> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    controller.dispose();

    /// Dispose of all text editing controllers for the extra inputs
    widget.extraInputs?.forEach((InputWidget inputWidget) {
      inputWidget.controller.dispose();
    });
    super.dispose();
  }

  /// The text editing controller used to control the text field
  final TextEditingController controller = TextEditingController();

  /// The datetime that has been selected on the calendar if the input
  /// widget is a calendar
  DateTime _selectedDate = DateTime.now();

  /// The datetime that has been selected on the calendar if the input
  /// widget is a calendar
  TimeOfDay _selectedTime = TimeOfDay.now();

  /// The index used to access the extraInputs widget list
  int accessIndex = 0;

  /// The value that corresponds to the checkbox value for the checkbox list screen
  String? _checkboxValue;

  /// The place that corresponds to the address item tapped on the [AddressAutocompleteMobilePortrait] list screen
  Future<GooglePlacesPlace>? _place;

  /// The currently selected dropdown value for the renter brands dropdown
  RenterBrands? _selectedRenterBrandDropDownValue = RenterBrands.Zillow;

  /// The currently selected dropdown value for the unit types dropdown
  UnitTypes? _selectedUnitTypeDropDownValue = UnitTypes.OneBedroomApartment;

  @override
  Widget build(BuildContext context) {
    final int widgetsLength = (widget.extraInputs?.length ?? 0) +
        1 +
        (widget.extraInputs?.length ?? 0);

    /// Show keyboard on widget load
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          expandedHeight:
              context.read<SizingInformation>().screenSize.height * 0.22,
          flexibleSpace: GradientHeader(
            containerDecimalHeight: 0.28,
            child: Material(
              color: Colors.transparent,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    widget.title,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    widget.description,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Column(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 5),
                child: Form(
                  key: _formKey,
                  child: Column(
                      children: List.generate(widgetsLength, (int index) {
                    if (widget.extraInputs != null) {
                      /// If extra widgets are present

                      if (index == 0) {
                        accessIndex = 0;
                        return InputWidget(
                          inputWidgetType: widget.inputWidgetType,
                          hintText: widget.hintText,
                          controller: controller,
                          onCheckboxTap: (String? value) =>
                              _checkboxValue = value,
                        );
                      }

                      /// Add spacing between each input widget
                      if (index.isOdd && index != widgetsLength - 1) {
                        return const SizedBox(
                          height: appVerticalSpacing,
                        );
                      }

                      /// Use post increment operator because we want to increment the value
                      /// of accessIndex AFTER we use its value
                      return widget.extraInputs![accessIndex++];
                    } else {
                      /// Set initial text for the widget if it is a text input and if [widget.initialText] is
                      /// not null

                      if (widget.initialText != null) {
                        controller.text = widget.initialText!;
                      }

                      /// If no extra widgets are present
                      return InputWidget(
                        inputWidgetType: widget.inputWidgetType,
                        onRenterBrandDropdownChanged: (RenterBrands? type) {
                          _selectedRenterBrandDropDownValue = type;
                        },
                        onUnitTypeDropdownChanged: (UnitTypes? type) {
                          _selectedUnitTypeDropDownValue = type;
                        },
                        hintText: widget.hintText,
                        controller: controller,
                        onDateSelected: (DateTime? date) {
                          /// Set the _selectedDay property when
                          /// a day on the calendar is selected
                          _selectedDate = date ?? DateTime.now();
                        },
                        onTimeSelected: (TimeOfDay? time) {
                          _selectedTime = time ?? TimeOfDay.now();
                        },
                        onBinaryOptionSelected: (String value) {
                          /// Get the value from the binary input
                          if (widget.onBinaryOptionSelected != null) {
                            widget.onBinaryOptionSelected!(value);
                          }
                        },
                        onCheckboxTap: (String? value) {
                          _checkboxValue = value;
                        },
                        onAddressItemTap:
                            (Future<GooglePlacesPlace> place) async {
                          _place = place;
                        },
                        checkboxListItems: widget.checkboxListItems,
                      );
                    }
                  })),
                ),
              ),
            ],
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(
                left: appHorizontalSpacing,
                right: appHorizontalSpacing,
                top: appVerticalSpacing),
            child: widget.inputWidgetType != InputWidgetType.BinaryInput
                ? NovaOneButton(
                    margin: EdgeInsets.only(bottom: 20),
                    onPressed: () async {
                      if (widget.inputWidgetType ==
                          InputWidgetType.AddressInput) {
                        if (_place != null) {
                          final String jsonString = jsonEncode((await _place));
                          widget.onSubmitButtonPressed(jsonString);
                        } else {
                          /// Show a snackbar error if the user has not selected an address item
                          Scaffold.of(context).showErrorSnackBar(
                              error: 'Please select an item from the list.');
                        }
                      } else if (widget.inputWidgetType ==
                          InputWidgetType.DropdownRenterBrand) {
                        /// [RenterBrands] dropdown
                        final String renterBrandString =
                            InputMobilePortrait.getRenterBrandString(
                                _selectedRenterBrandDropDownValue ??
                                    RenterBrands.Zillow);

                        widget.onSubmitButtonPressed(renterBrandString);
                      } else if (widget.inputWidgetType ==
                          InputWidgetType.DropdownUnitType) {
                        /// [UnitTypes] dropdown
                        final String unitTypeString =
                            InputMobilePortrait.getUnitTypeString(
                                _selectedUnitTypeDropDownValue ??
                                    UnitTypes.OneBedroomApartment);
                        widget.onSubmitButtonPressed(unitTypeString);
                      } else if (widget.inputWidgetType ==
                          InputWidgetType.CalendarInput) {
                        _selectedDate = DateTime(
                          _selectedDate.year,
                          _selectedDate.month,
                          _selectedDate.day,
                          _selectedTime.hour,
                          _selectedTime.minute,
                        );

                        /// Calendar input
                        widget.onSubmitButtonPressed(_selectedDate.toString());
                      } else if (widget.inputWidgetType ==
                              InputWidgetType.ListInput ||
                          widget.inputWidgetType == InputWidgetType.ListHours ||
                          widget.inputWidgetType == InputWidgetType.ListDays) {
                        /// Check if at least one checkbox is checked before submitting
                        if (_checkboxValue != null) {
                          widget.onSubmitButtonPressed(_checkboxValue!);
                        } else {
                          Scaffold.of(context).showErrorSnackBar(
                              error: 'Please check an item.');
                        }
                      } else if (widget.inputWidgetType !=
                              InputWidgetType.CalendarInput &&
                          widget.inputWidgetType !=
                              InputWidgetType.BinaryInput) {
                        if (_formKey.currentState!.validate()) {
                          /// Dismiss the keyboard
                          UIUtils.instance.dismissKeyboard(context);

                          /// Get text from other controllers if possible
                          String inputText = controller.text;
                          widget.extraInputs
                              ?.forEach((InputWidget inputWidget) {
                            inputText += ' ${inputWidget.controller.text}';
                          });

                          widget.onSubmitButtonPressed(inputText);
                        }
                      }
                    },
                    title: widget.submitButtonTitle,
                  )
                : SizedBox.shrink(),
          ),
        ),
      ],
    );
  }
}
