import 'package:intl/intl.dart';

class DateTimeHelper {
  static final DateTimeHelper instance = DateTimeHelper._internal();
  DateTimeHelper._internal();

  /// The standard string format each date string obtained from the NovaOne API will be in
  static const String standardDateStringFormat = 'yyyy-MM-dd HH:mm:ss zzz';
  static const String defaultOutputDateFormatWithTime =
      'MMM dd, yyyy | hh:mm a';
  static const String defaultOutputDateFormat = 'MMM dd, yyyy';

  DateTime toDateTime({required int year, String? month}) {
    // Determine the integer associated with the month string
    int? monthInteger;
    switch (month) {
      case 'Jan':
        monthInteger = DateTime.january;
        break;
      case 'Feb':
        monthInteger = DateTime.february;
        break;
      case 'Mar':
        monthInteger = DateTime.march;
        break;
      case 'Apr':
        monthInteger = DateTime.april;
        break;
      case 'May':
        monthInteger = DateTime.may;
        break;
      case 'Jun':
        monthInteger = DateTime.june;
        break;
      case 'Jul':
        monthInteger = DateTime.july;
        break;
      case 'Aug':
        monthInteger = DateTime.august;
        break;
      case 'Sep':
        monthInteger = DateTime.september;
        break;
      case 'Oct':
        monthInteger = DateTime.october;
        break;
      case 'Nov':
        monthInteger = DateTime.november;
        break;
      case 'Dec':
        monthInteger = DateTime.december;
        break;
    }

    if (monthInteger != null) {
      return DateTime(year, monthInteger);
    }

    return DateTime(year);
  }

  /// Converts the [dateString] into a DateTime object
  ///
  /// A [primaryFormat] is given to determine how to parse the
  /// [dateString]; and if the [dateString] could not be parsed
  /// with the [primaryFormat], the [secondaryFormat] will be used
  /// to parse the [dateString].
  DateTime? convertToDateTime(String? dateString, String primaryFormat,
      {String? secondaryFormat}) {
    if (dateString == null) {
      return null;
    }

    try {
      return DateFormat(primaryFormat).parseUTC(dateString).toLocal();
    } on FormatException {
      if (secondaryFormat != null) {
        try {
          return DateFormat(secondaryFormat).parseUTC(dateString).toLocal();
        } catch (error) {}
      }
    }

    // If we failed to parse the date string with both formats, then try the default parsing
    return DateTime.tryParse(dateString);
  }
}
