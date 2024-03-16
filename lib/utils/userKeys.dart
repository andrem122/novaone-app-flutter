import 'package:flutter/material.dart';

/// Keys used to store values for the user and [Key] values for widgets
///
/// Follows the singleton pattern and properties can be accessed
/// by accessing the instance property in the class
class Keys {
  static final Keys instance = Keys._internal();
  Keys._internal();

  /// User
  final String userObject = 'user_object';
  final String userLoggedIn = 'user_login_status';
  final String userPassword = 'user_password';
  final String userUserName = 'user_username';
  final String userEnabledNotifications = 'user_enabled_notifications';
  final String userDeniedNotifications = 'user_denied_notifications';
  final String userPushNotificationToken = 'user_push_notification_token';

  /// Leads
  final String userLeads = 'user_leads';

  /// Widgets
  final String signUpButton = 'sign_up_button';
  final String sliderLoginButton = 'slider_login_button';
  final String loginButton = 'login_button';
  final String addObjectButton = 'add_object_button';

  /// Floating action buttons
  final String addLeadFloatingActionButton = 'add_lead_floating_action_button';
  final String addAppointmentFloatingActionButton =
      'add_appointment_floating_action_button';
  final String addCompanyFloatingActionButton =
      'add_company_floating_action_button';

  /// Lead form
  final String addLeadName = 'add_lead_name_text_field';
  final String addLeadPhone = 'add_lead_phone_text_field';
  final String addLeadEmail = 'add_lead_email_text_field';
  final String addLeadCompany = 'add_lead_company_dropdown_field';
  final String addLeadRenterBrand = 'add_lead_renter_brand_dropdown_field';

  /// Appointment form
  final String addAppointmentName = 'add_appointment_name_text_field';
  final String addAppointmentPhone = 'add_appointment_phone_text_field';
  final String addAppointmentCompany = 'add_appointment_company_dropdown_field';
  final String addAppointmentUnitType =
      'add_appointment_unit_type_dropdown_field';

  /// Company form
  final String addCompanyName = 'add_company_name_text_field';
  final String addCompanyPhone = 'add_company_phone_text_field';
  final String addCompanyEmail = 'add_company_email_text_field';
  final String addCompanyAddress = 'add_company_address_text_field';
  final String addCompanyCity = 'add_company_city_text_field';
  final String addCompanyState = 'add_company_state_dropdown_field';
  final String addCompanyZip = 'add_company_zip_text_field';
}
