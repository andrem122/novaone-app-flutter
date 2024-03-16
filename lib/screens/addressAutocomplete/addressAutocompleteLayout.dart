import 'package:flutter/material.dart';
import 'package:novaone/models/models.dart';
import 'package:novaone/responsive/responsive.dart';
import 'package:novaone/screens/addressAutocomplete/addressAutocompleteMobile.dart';

class AddressAutocompleteScreenLayout extends StatelessWidget {
  /// The validator for the text form field input
  final String? Function(String?) validator;

  /// The controller for the input field
  final TextEditingController controller;

  /// The function that is called when an item is tapped on in the
  /// suggestion list.
  final Function(Future<GooglePlacesPlace> place) onAddressItemTap;

  /// Whether or not we want to directly focus on the text field when the screen first appears
  final bool? autofocus;

  AddressAutocompleteScreenLayout(
      {Key? key,
      required this.validator,
      required this.controller,
      required this.onAddressItemTap,
      this.autofocus})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: OrientationLayout(
        portrait: AddressAutocompleteMobilePortrait(
          autofocus: autofocus,
          controller: controller,
          validator: validator,
          onAddressItemTap: onAddressItemTap,
        ),
      ),
    );
  }
}
