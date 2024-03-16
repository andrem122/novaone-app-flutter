import 'dart:io';

import 'package:novaone/constants.dart';
import 'package:novaone/models/models.dart';
import 'package:novaone/utils/utils.dart';
import 'package:novaone/extensions/extensions.dart';
import 'package:url_launcher/url_launcher_string.dart';

class UrlLauncherHelper {
  static final UrlLauncherHelper instance = UrlLauncherHelper._internal();
  UrlLauncherHelper._internal();

  /// The error message to show when a device does not have the capability to make phone calls
  final String _callErrorMessage =
      'Cannot call number from this device. Please try a different device.';

  /// The error message to show when a device does not have the capability to SMS messages
  final String _textErrorMessage =
      'Cannot text number from this device. Please try a different device.';

  /// The error message to show when a device does not have the capability to make email
  final String _emailErrorMessage =
      'Cannot email from this device. Please try a different device.';

  /// Launches a given [url] into a browser
  ///
  /// [onError] is called once an error occurs
  void launchUrl(String url, {Function()? onError}) async {
    if (!(await canLaunchUrlString(url))) {
      if (onError != null) {
        onError();
      }
      throw Exception('UrlLauncherHelper.launchUrl: Could not launch url');
    } else {
      print('TEST');
      await launchUrlString(url);
    }
  }

  /// Brings up the call dialog to call a number
  void callNumber(BaseModel object) {
    switch (object.runtimeType) {
      case Lead:
        final lead = object as Lead;
        if (lead.phoneNumber != null) {
          final String phoneNumber = StringFormatter.instance
              .formatPhoneNumberForApiCall(lead.phoneNumber!);
          final String urlString = "tel:$phoneNumber";

          UrlLauncherHelper.instance.launchUrl(
            urlString,
            onError: () => rootScaffoldMessengerKey.currentState
                ?.showErrorSnackBar(error: _callErrorMessage),
          );
        } else {
          rootScaffoldMessengerKey.currentState?.showErrorSnackBar(
              error: 'No phone number to call for this lead.');
        }
        break;
      case Appointment:
        final appointment = object as Appointment;
        final String phoneNumber = StringFormatter.instance
            .formatPhoneNumberForApiCall(appointment.phoneNumber);
        final String urlString = "tel:$phoneNumber";

        UrlLauncherHelper.instance.launchUrl(
          urlString,
          onError: () => rootScaffoldMessengerKey.currentState
              ?.showErrorSnackBar(error: _callErrorMessage),
        );
        break;
      default:
        throw TypeError();
    }
  }

  /// Brings up the text dialog to call a number
  void textNumber(BaseModel object) {
    switch (object.runtimeType) {
      case Lead:
        final casted = object as Lead;
        if (casted.phoneNumber != null) {
          final String phoneNumber = StringFormatter.instance
              .formatPhoneNumberForApiCall(casted.phoneNumber!);
          final String urlString = _getSmsUrlString(phoneNumber);

          UrlLauncherHelper.instance.launchUrl(
            urlString,
            onError: () => rootScaffoldMessengerKey.currentState
                ?.showErrorSnackBar(error: _textErrorMessage),
          );
        } else {
          rootScaffoldMessengerKey.currentState?.showErrorSnackBar(
              error: 'No phone number to text for this lead.');
        }
        break;
      case Appointment:
        final casted = object as Appointment;
        final String phoneNumber = StringFormatter.instance
            .formatPhoneNumberForApiCall(casted.phoneNumber);
        final String urlString = _getSmsUrlString(phoneNumber);

        UrlLauncherHelper.instance.launchUrl(
          urlString,
          onError: () => rootScaffoldMessengerKey.currentState
              ?.showErrorSnackBar(error: _textErrorMessage),
        );
        break;
    }
  }

  /// Opens up the email client if there is an email property available in the [object]
  void email(BaseModel object) {
    switch (object.runtimeType) {
      case Lead:
        final casted = object as Lead;
        if (casted.email != null) {
          final String urlString = 'mailto:${casted.email}';

          UrlLauncherHelper.instance.launchUrl(
            urlString,
            onError: () => rootScaffoldMessengerKey.currentState
                ?.showErrorSnackBar(error: _emailErrorMessage),
          );
        } else {
          rootScaffoldMessengerKey.currentState
              ?.showErrorSnackBar(error: 'No email for this lead.');
        }
        break;
      default:
        throw TypeError();
    }
  }

  /// Generates the SMS url string that is used to open the OS texting application
  _getSmsUrlString(String phoneNumber) {
    return Platform.isIOS
        ? "sms:$phoneNumber".replaceAll('+', '')
        : "sms:$phoneNumber";
  }
}
