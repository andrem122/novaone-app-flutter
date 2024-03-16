extension EmailValidator on String {
  bool get isValidEmail => RegExp(
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
      .hasMatch(this);
}

extension PhoneValidator on String {
  bool get isValidPhone => RegExp(r'\(\d{3}\)\s\d{3}-\d{4}').hasMatch(this);
}

/// Checks if the password is at least 6 characters long and is alphanumeric
extension PasswordValidator on String {
  bool get isValidPassword =>
      this.length > 6 &&
      RegExp(".*[A-Za-z].*").hasMatch(this) &&
      RegExp(".*[0-9].*").hasMatch(this) &&
      RegExp("[A-Za-z0-9]*").hasMatch(this);
}

extension BoolToInt on bool {
  /// Converts the bool value to an int value
  ///
  /// 1 for true and 0 for false
  int get toInt => this == true ? 1 : 0;
}

extension IntToBool on int {
  /// Converts the int value to a bool value
  ///
  /// 1 for true and 0 for false
  bool get toBool => this == 1 ? true : false;
}
