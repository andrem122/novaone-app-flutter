import 'package:flutter/services.dart';

/// Formats strings such as dates, phone numbers, etc. for API calls and for
/// display data in the app
class StringFormatter {
  static final StringFormatter instance = StringFormatter._internal();
  StringFormatter._internal();

  /// Removes any uneeded characters in the [phoneNumber] when sending to the API
  ///
  /// Ex: (772) 346-2432 becomes +17723462432
  String formatPhoneNumberForApiCall(String phoneNumber) {
    // Remove any uneeded characters
    final String prefixNumber = phoneNumber.contains('+1') ? '' : '+1';
    return prefixNumber + phoneNumber.replaceAll(RegExp(r'[)(-\s]+'), '');
  }

  /// Formats a [phoneNumber] from an API call for display
  ///
  /// Ex: +17723462432 becomes (772) 346-2432
  String formatPhoneNumberForDisplay(String phoneNumber) {
    if (phoneNumber.isEmpty) {
      return '';
    }

    // Get the first 3 characters and add enclosing parentheses
    final String areaCode = '(' + phoneNumber.substring(2, 5) + ') ';
    final String firstThreeDigits = phoneNumber.substring(5, 8);
    final String lastFourDigits = phoneNumber.substring(8);
    return areaCode + firstThreeDigits + '-' + lastFourDigits;
  }
}

/// Formats the phone number to a (XXX) XXX-XXXX format for text inputs
class PhoneNumberTextInputFormatter extends TextInputFormatter {
  int _whichNumber;
  PhoneNumberTextInputFormatter(this._whichNumber);

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final int newTextLength = newValue.text.length;
    int selectionIndex = newValue.selection.end;
    int usedSubstringIndex = 0;
    final StringBuffer newText = StringBuffer();
    switch (_whichNumber) {
      case 1:
        {
          if (newTextLength >= 1) {
            newText.write('(');
            if (newValue.selection.end >= 1) selectionIndex++;
          }
          if (newTextLength >= 4) {
            newText.write(
                newValue.text.substring(0, usedSubstringIndex = 3) + ') ');
            if (newValue.selection.end >= 3) selectionIndex += 2;
          }
          if (newTextLength >= 7) {
            newText.write(
                newValue.text.substring(3, usedSubstringIndex = 6) + '-');
            if (newValue.selection.end >= 6) selectionIndex++;
          }
          if (newTextLength >= 11) {
            newText.write(
                newValue.text.substring(6, usedSubstringIndex = 10) + ' ');
            if (newValue.selection.end >= 10) selectionIndex++;
          }
          break;
        }
      case 91:
        {
          if (newTextLength >= 5) {
            newText.write(
                newValue.text.substring(0, usedSubstringIndex = 5) + ' ');
            if (newValue.selection.end >= 6) selectionIndex++;
          }
          break;
        }
    }
    // Dump the rest.
    if (newTextLength >= usedSubstringIndex)
      newText.write(newValue.text.substring(usedSubstringIndex));
    return TextEditingValue(
      text: newText.toString(),
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}
