import 'package:flutter/material.dart';

/// A class used to control the contents of the [NavScreen]
class NavScreenController extends ChangeNotifier {
  /// The index of the currently selected item in the tab bar
  int _index = 0;

  int get index => _index;

  /// Sets the index for the tab bar and nav screen
  set index(int newIndex) {
    this._index = newIndex;
    notifyListeners();
  }
}
