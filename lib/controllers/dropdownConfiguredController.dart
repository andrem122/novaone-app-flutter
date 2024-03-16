import 'package:flutter/material.dart';
import 'package:novaone/widgets/widgets.dart';

/// A class used to control the contents of [DropdownConfigured] controller
class DropdownConfiguredController<T> extends ChangeNotifier {
  late List<DropdownMenuItem<T>> items;

  /// The currently selected item in the dropdown
  T? _value;

  DropdownConfiguredController(List<DropdownMenuItem<T>> items) {
    this.items = items;
    this._value = items.first.value;
  }

  T? get value => _value;

  /// Sets the value for the dropdown
  set value(T? newValue) {
    this._value = newValue;
    notifyListeners();
  }
}
