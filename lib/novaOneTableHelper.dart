import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:novaone/enums/enums.dart';
import 'package:novaone/models/models.dart';
import 'package:novaone/utils/utils.dart';
import 'package:novaone/widgets/widgets.dart';

/// Constants for the tables used throughout the app.
///
/// Includes the name of the local and server tables as well
/// as other things related to the tables.
class NovaOneTableHelper {
  static final NovaOneTableHelper instance = NovaOneTableHelper._internal();
  NovaOneTableHelper._internal();

  final String leads = "leads_lead";
  final String appointmentsBase = "appointments_appointment_base";
  final String appointmentsRealEstate = "appointments_appointment_real_estate";
  final String appointmentsMedical = "appointments_appointment_medical";
  final String authUser = "auth_user";
  final String company = "property_company";
  final String customer = "customer_register_customer_user";
  final String pushNotificationTokens =
      "customer_register_customer_user_push_notification_tokens";

  /// The popup menu options for the list table for leads
  List<PopupMenuEntry> listLeadTablePopupMenuOptions({
    required void Function() onCallTap,
    required void Function() onTextTap,
    required void Function() onEmailTap,
  }) {
    return [
      PopupMenuItem(
        value: ListTableItemMenuOptions.Call,
        child: Text('Call'),
        onTap: onCallTap,
      ),
      PopupMenuItem(
        value: ListTableItemMenuOptions.Text,
        child: Text('Text'),
        onTap: onTextTap,
      ),
      PopupMenuItem(
        value: ListTableItemMenuOptions.Email,
        child: Text('Email'),
        onTap: onEmailTap,
      ),
    ];
  }

  /// The popup menu options for the list table for appointments
  List<PopupMenuEntry> listAppointmentTablePopupMenuOptions({
    required void Function() onCallTap,
    required void Function() onTextTap,
  }) {
    return [
      PopupMenuItem(
        value: ListTableItemMenuOptions.Call,
        child: Text('Call'),
        onTap: onCallTap,
      ),
      PopupMenuItem(
        value: ListTableItemMenuOptions.Text,
        child: Text('Text'),
        onTap: onTextTap,
      ),
    ];
  }

  /// The popup menu options for the list table for companies
  final List<PopupMenuEntry> companylistPopupMenuOptions = [
    PopupMenuItem(
      value: ListTableItemMenuOptions.View,
      child: Text('View'),
    ),
  ];

  /// Converts a list of objects that are a subclass of [BaseModel] to [NovaOneListTableItemData]
  List<NovaOneListTableItemData>? convertObjectsToListTableItemData(
      {required List<BaseModel>? objects}) {
    if (objects!.isNotEmpty) {
      switch (objects.first.runtimeType) {
        case Lead:
          final castedObjects = objects as List<Lead>;
          return castedObjects
              .map((Lead lead) => NovaOneListTableItemData(
                  popupMenuOptions:
                      listLeadTablePopupMenuOptions(onCallTap: () {
                    UrlLauncherHelper.instance.callNumber(lead);
                  }, onTextTap: () {
                    UrlLauncherHelper.instance.textNumber(lead);
                  }, onEmailTap: () {
                    UrlLauncherHelper.instance.email(lead);
                  }),
                  subtitle: DateFormat(NovaOneTable.defaultDateFormat)
                      .format(lead.dateOfInquiry),
                  title: lead.name,
                  id: lead.id,
                  object: lead))
              .toList();
        case Appointment:
          final castedObjects = objects as List<Appointment>;
          return castedObjects
              .map((Appointment appointment) => NovaOneListTableItemData(
                  popupMenuOptions: listAppointmentTablePopupMenuOptions(
                    onCallTap: () {
                      UrlLauncherHelper.instance.callNumber(appointment);
                    },
                    onTextTap: () {
                      UrlLauncherHelper.instance.textNumber(appointment);
                    },
                  ),
                  subtitle: DateFormat(NovaOneTable.defaultDateFormat)
                      .format(appointment.time),
                  title: appointment.name,
                  id: appointment.id,
                  object: appointment))
              .toList();
        case Company:
          final castedObjects = objects as List<Company>;
          return castedObjects
              .map((Company company) => NovaOneListTableItemData(
                  popupMenuOptions: companylistPopupMenuOptions,
                  subtitle: DateFormat(NovaOneTable.defaultDateFormat)
                      .format(company.created),
                  title: company.name,
                  id: company.id,
                  object: company))
              .toList();

        default:
          throw TypeError();
      }
    }

    return null;
  }
}

class NovaOneTableColumns {
  static final NovaOneTableColumns instance = NovaOneTableColumns._internal();
  NovaOneTableColumns._internal();

  /// Local means the column names used by the sqlite local database
  /// Server means the column names used by the database on the server

  /// Leads (server column names)
  final String leadName = 'name';
  final String leadPhone = 'phone_number';
  final String leadEmail = 'email';
  final String leadRenterBrand = 'renter_brand';
  final String leadDateOfInquiry = 'date_of_inquiry';
  final String leadCompanyId = 'company_id';
  final String leadSentEmailDate = 'sent_email_date';
  final String leadSentTextDate = 'sent_text_date';
  final String leadFilledOutForm = 'filled_out_form';
  final String leadMadeAppointment = 'made_appointment';

  /// Appointments (server column names)
  final String appointmentName = 'name';
  final String appointmentPhone = 'phone_number';
  final String appointmentEmail = 'email';
  final String appointmentTime = 'time';
  final String appointmentConfirmed = 'confirmed';
  final String appointmentUnitType = 'unit_type';
  final String appointmentCompanyId = 'company_id';

  /// Companies (server column names)
  final String companyName = 'name';
  final String companyPhone = 'phone_number';
  final String companyEmail = 'email';
  final String companyAddress = 'address';
  final String companyCity = 'city';
  final String companyState = 'state';
  final String companyZip = 'zip';
  final String companyAllowSameDayAppointments = 'allow_same_day_appointments';
  final String companyAutoRespondNumber = 'auto_respond_number';
  final String companyAutoRespondText = 'auto_respond_text';
  final String companyDays = 'days_of_the_week_enabled';
  final String companyHours = 'hours_of_the_day_enabled';

  /// Leads (local column names)
  final String localLeadName = 'name';
  final String localLeadPhone = 'phoneNumber';
  final String localLeadEmail = 'email';
  final String localLeadRenterBrand = 'renterBrand';
  final String localLeadDateOfInquiry = 'dateOfInquiry';
  final String localLeadCompanyId = 'companyId';
  final String localLeadSentTextDate = 'sentTextDate';
  final String localLeadSentEmailDate = 'sentEmailDate';
  final String localLeadFilledOutForm = 'filledOutForm';
  final String localLeadMadeAppointment = 'madeAppointment';
  final String localLeadCompanyName = 'companyName';

  /// Companies (local column names)
  final String localCompanyName = 'name';
  final String localCompanyAddress = 'address';
  final String localCompanyPhone = 'phoneNumber';
  final String localCompanyAutoRespondNumber = 'autoRespondNumber';
  final String localCompanyAutoRespondText = 'autoRespondText';
  final String localCompanyEmail = 'email';
  final String localCompanyCreated = 'created';
  final String localCompanyAllowSameDayAppointments =
      'allowSameDayAppointments';
  final String localCompanyDaysOfTheWeekEnabled = 'daysOfTheWeekEnabled';
  final String localCompanyHoursOfTheDayEnabled = 'hoursOfTheDayEnabled';
  final String localCompanyCity = 'city';
  final String localCompanyCustomerUserId = 'customerUserId';
  final String localCompanyState = 'state';
  final String localCompanyZip = 'zip';

  /// Appointments (local column names)
  final String localAppointmentName = 'name';
  final String localAppointmentPhone = 'phoneNumber';
  final String localAppointmentTime = 'time';
  final String localAppointmentCreated = 'created';
  final String localAppointmentTimeZone = 'timeZone';
  final String localAppointmentConfirmed = 'confirmed';
  final String localAppointmentCompanyId = 'companyId';
  final String localAppointmentUnitType = 'unitType';
  final String localAppointmentEmail = 'email';
  final String localAppointmentDateOfBirth = 'dateOfBirth';
  final String localAppointmentTestType = 'testType';
  final String localAppointmentGender = 'gender';
  final String localAppointmentAddress = 'address';
  final String localAppointmentCity = 'city';
  final String localAppointmentZip = 'zip';
}
