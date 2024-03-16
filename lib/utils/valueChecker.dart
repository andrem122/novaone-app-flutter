import 'package:novaone/extensions/generalExtensions.dart';

class ValueChecker {
  /// Error messages
  final String phoneErrorMessage = 'Please enter a valid phone number';
  final String emailErrorMessage = 'Please enter an email address';
  final String emptyValueErrorMessage = 'Please enter in a value';

  static final ValueChecker instance = ValueChecker._internal();
  ValueChecker._internal();

  /// Checks if a string value is null or empty
  bool isNullOrEmpty(String? value) {
    if (value != null) {
      return value.isEmpty ? true : false;
    }

    return true;
  }

  /// Checks if a string value is a valid phone number
  String? isValidPhone(String? value) {
    if (value != null) {
      if (value.isEmpty) {
        return phoneErrorMessage;
      } else {
        return value.isValidPhone ? null : phoneErrorMessage;
      }
    }

    return phoneErrorMessage;
  }

  /// Checks if a string value is a valid phone number
  ///
  /// Allows an empty input
  String? isValidPhoneCanBeEmpty(String? value) {
    if (value != null) {
      if (value.isEmpty) {
        /// Allow empty values to pass
        return null;
      } else {
        return value.isValidPhone ? null : phoneErrorMessage;
      }
    } else {
      /// Allow null values to pass
      return null;
    }
  }

  /// Checks if a string value is a valid phone number
  ///
  /// Allows an empty input
  String? isValidEmailCanBeEmpty(String? value) {
    if (value != null) {
      if (value.isEmpty) {
        /// Allow empty values to pass
        return null;
      } else {
        return value.isValidEmail ? null : emailErrorMessage;
      }
    } else {
      /// Allow null values to pass
      return null;
    }
  }

  /// Checks if a string value is a valid phone number
  String? isValidEmail(String? value) {
    if (value != null) {
      if (value.isEmpty) {
        return emailErrorMessage;
      } else {
        return value.isValidEmail ? null : emailErrorMessage;
      }
    }

    return emailErrorMessage;
  }

  /// The default validator for text inputs
  String? defaultValidator(String? value) {
    if (value != null) {
      return value.isEmpty ? emptyValueErrorMessage : null;
    }

    return emptyValueErrorMessage;
  }
}
