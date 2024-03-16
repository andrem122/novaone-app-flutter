import 'package:flutter/material.dart';
import 'package:novaone/constants.dart';
import 'package:novaone/controllers/dropdownConfiguredController.dart';
import 'package:novaone/enums/enums.dart';
import 'package:novaone/models/models.dart';

/// This class is needed only for the [LeadsScreenLayout] screen because
/// the dropdown value was not changing in the menu when an item was selected
class DropdownConfigured<T> extends StatefulWidget {
  DropdownConfigured(
      {Key? key,
      required this.onChanged,
      this.items,
      this.isExpanded = false,
      this.hint,
      this.controller})
      : super(key: key) {
    if (controller == null) {
      assert(items != null);
    } else {
      /// Since we use the items from the controller if it is provided, make sure items are null
      assert(items == null);
    }
  }

  final Function(T? value) onChanged;
  final List<DropdownMenuItem<T>>? items;
  final bool isExpanded;
  final String? hint;
  final DropdownConfiguredController? controller;

  @override
  _DropdownConfiguredState<T> createState() => _DropdownConfiguredState();

  static List<DropdownMenuItem<UnitTypes>> get generateDropdownUnitTypeItems {
    return [
      DropdownMenuItem(
          child: Text('1 Bedroom'), value: UnitTypes.OneBedroomApartment),
      DropdownMenuItem(
        child: Text('2 Bedrooms'),
        value: UnitTypes.TwoBedroomApartment,
      ),
      DropdownMenuItem(
        child: Text('3 Bedrooms'),
        value: UnitTypes.ThreeBedroomApartment,
      ),
    ];
  }

  /// The list of items that will go into the dropdown renter brands menu
  static List<DropdownMenuItem<RenterBrands>>
      get generateDropdownRenterBrandItems {
    return [
      DropdownMenuItem(child: Text('Zillow'), value: RenterBrands.Zillow),
      DropdownMenuItem(
        child: Text('Trulia'),
        value: RenterBrands.Trulia,
      ),
      DropdownMenuItem(
        child: Text('Realtor'),
        value: RenterBrands.Realtor,
      ),
      DropdownMenuItem(
          child: Text('Apartments.com'), value: RenterBrands.Apartments),
      DropdownMenuItem(child: Text('Hotpads'), value: RenterBrands.Hotpads),
      DropdownMenuItem(
          child: Text('Craigslist'), value: RenterBrands.Craigslist),
    ];
  }

  /// The list of items that will go into the dropdown renter brands menu
  static List<DropdownMenuItem<String>> get generateDropdownStateItems {
    return List.generate(states.length, (int index) {
      final currentStateMap = states.elementAt(index);
      return DropdownMenuItem<String>(
          child: Text(currentStateMap.values.first),
          value: currentStateMap.keys.first);
    });
  }

  /// The list of items that will go into the dropdown binary choice menu
  static List<DropdownMenuItem<bool>> get generateDropdownBinaryChoiceItems {
    return [
      DropdownMenuItem(child: Text('Yes'), value: true),
      DropdownMenuItem(
        child: Text('No'),
        value: false,
      ),
    ];
  }

  /// The list of items that will go into the dropdown renter brands menu
  static List<DropdownMenuItem<Company>> generateDropdownCompanyItems(
      List<Company> companies) {
    return List.generate(
      companies.length,
      (int index) => DropdownMenuItem(
          child: Text(companies[index].name), value: companies[index]),
    );
  }
}

class _DropdownConfiguredState<T> extends State<DropdownConfigured> {
  /// The value obtained for the [Lead] renter brand from the form field for the adding a lead

  late T? selected;

  @override
  initState() {
    selected = widget.controller != null
        ? widget.controller?.value
        : widget.items?.first.value;
    if (widget.controller != null) {
      widget.controller!.addListener(() {
        setState(() {
          selected = widget.controller!.value;
        });
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<T>(
        hint: widget.hint != null ? Text(widget.hint!) : null,
        isExpanded: widget.isExpanded,
        value: selected,
        items: widget.controller != null
            ? widget.controller?.items as List<DropdownMenuItem<T>>
            : widget.items as List<DropdownMenuItem<T>>,
        onChanged: (T? value) {
          setState(() {
            selected = value;
          });
          widget.onChanged(value);
        });
  }
}
