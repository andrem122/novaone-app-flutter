import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:novaone/apiCredentials.dart';

import 'enums/enums.dart';
import 'models/models.dart';

/// Valid data for the add lead form
final String testAddLeadName = 'Test Name';
final String testAddLeadPhone = '(555) 555-5555';
final String testAddLeadEmail = 'test@mail.com';

/// Error data for the add lead form
final String testAddLeadErrorPhone = '(555) 555-555';
final String testAddLeadErrorEmail = 'testmail.com';

final String testPassword = 'test';
final String testUserName = 'test@mail.com';
final String testCustomerId = '2';
final String jsonUser =
    '{"id":$testCustomerId,"userId":3,"password":"$testPassword","lastLogin":"2021-10-24 15:11:54.71883+00","username":"$testUserName","firstName":"test","lastName":"test","email":"$testUserName","dateJoined":"2020-03-17 18:10:17+00","isPaying":false,"wantsSms":false,"wantsEmailNotifications":false,"phoneNumber":"+15615555555","customerType":"PM"}';
final String jsonLeads =
    '[{"id":1793,"name":"Test 1","phoneNumber":"(555) 555-1555","email":"test@mail.com","dateOfInquiry":"2021-06-05 03:49:30 UTC","renterBrand":"Apartments.com","companyId":2,"sentTextDate":"2021-06-05 00:12:29 UTC","sentEmailDate":"2021-06-07 04:00:00 UTC","filledOutForm":false,"madeAppointment":true,"companyName":"Mayfair At Lawnwood"}]';
final String jsonSuccess = '{"successReason":"Successful operation."}';

/// Test parameters for mock API calls when getting data
Map<String, String> testGetParameters = {
  'email': testUserName,
  'password': testPassword,
  'customerUserId': '2',
  'PHPAuthenticationUsername': ApiCredentials.PHPAuthenticationUsername,
  'PHPAuthenticationPassword': ApiCredentials.PHPAuthenticationPassword,
};

/// Test parameters when adding a lead
final dateFormatter = DateFormat('yyyy-MM-dd HH:mm:ss-0400');
final String dateFormattedString = dateFormatter.format(DateTime.now());
Map<String, String> testAddLeadParameters = {
  'email': testUserName,
  'password': testPassword,
  'customerUserId': testCustomerId,
  'leadName': testAddLeadName,
  'leadPhoneNumber': testAddLeadPhone,
  'leadEmail': testAddLeadEmail,
  'leadRenterBrand': 'Zillow',
  'dateOfInquiry': dateFormattedString,
  'leadCompanyId': testCompany.id.toString(),
};

final User currentUser = User(
    customerId: 1,
    userId: 3213,
    password: 'password',
    lastLogin: '2020-12-30 12:00:00 PM',
    username: 'andrem122',
    firstName: 'John',
    lastName: 'Berman',
    email: 'test@mail.com',
    dateJoined: '2020-12-30 12:00:00 PM',
    isPaying: false,
    wantsEmailNotifications: false,
    wantsSms: false,
    phoneNumber: '555-555-5555',
    customerType: 'PM');

final testCompany = Company(
    id: 0,
    name: 'Test Company',
    address: '123 Test Way',
    phoneNumber: '(555) 555-5555',
    autoRespondNumber: '(555) 555-5555',
    autoRespondText: 'Test',
    email: 'test@mail.com',
    created: DateTime.now(),
    allowSameDayAppointments: false,
    daysOfTheWeekEnabled: '0, 1, 2, 3',
    hoursOfTheDayEnabled: '0, 1, 2, 3',
    city: "Test",
    customerUserId: 0,
    state: 'FL',
    zip: '333333');

final testlead = Lead(
    companyId: 0,
    companyName: '',
    dateOfInquiry: DateTime.now(),
    filledOutForm: false,
    id: 0,
    madeAppointment: false,
    name: 'Test');

final testAppointment = Appointment(
    id: 1,
    name: 'John Doe',
    phoneNumber: '561-346-5571',
    time: DateTime.now(),
    timeZone: 'United_States/America',
    confirmed: false,
    companyId: 1);

final List<Appointment> recentAppointments = [
  Appointment(
      id: 1,
      name: 'John Doe',
      phoneNumber: '561-346-5571',
      time: DateTime.now(),
      timeZone: 'United_States/America',
      confirmed: false,
      companyId: 1),
  Appointment(
      id: 2,
      name: 'Thomas Button',
      phoneNumber: '561-346-5571',
      time: DateTime.now(),
      timeZone: 'United_States/America',
      confirmed: false,
      companyId: 1),
  Appointment(
      id: 3,
      name: 'Benjamin Button',
      phoneNumber: '561-346-5571',
      time: DateTime.now(),
      timeZone: 'United_States/America',
      confirmed: false,
      companyId: 1),
  Appointment(
      id: 4,
      name: 'Johhny Rockets',
      phoneNumber: '561-346-5571',
      time: DateTime.now(),
      timeZone: 'United_States/America',
      confirmed: false,
      companyId: 1),
  Appointment(
      id: 5,
      name: 'Sarah Bateman',
      phoneNumber: '561-346-5571',
      time: DateTime.now(),
      timeZone: 'United_States/America',
      confirmed: false,
      companyId: 1),
];

final List<PopupMenuEntry> listPopupMenuOptions = [
  PopupMenuItem(
    value: ListTableItemMenuOptions.Call,
    child: Text('Call'),
  ),
  PopupMenuItem(
    value: ListTableItemMenuOptions.Text,
    child: Text('Text'),
  ),
  PopupMenuItem(
    value: ListTableItemMenuOptions.Email,
    child: Text('Email'),
  ),
  PopupMenuItem(
    value: ListTableItemMenuOptions.View,
    child: Text('View'),
  ),
];

// List of pop up menu options for settings
final List<PopupMenuEntry> settingsPopupMenuOptions = [
  PopupMenuItem(
    value: ListTableItemMenuOptions.Edit,
    child: Text('Edit'),
  ),
  PopupMenuItem(
    value: ListTableItemMenuOptions.Copy,
    child: Text('Copy'),
  ),
];

final List<NovaOneListTableItemData> allAppointments = [
  NovaOneListTableItemData(
      popupMenuOptions: listPopupMenuOptions,
      subtitle: 'Dec 25',
      title: 'John Berry',
      id: 1,
      object: recentAppointments[0]),
  NovaOneListTableItemData(
      popupMenuOptions: listPopupMenuOptions,
      subtitle: 'Dec 25',
      title: 'John Berry',
      id: 1,
      object: recentAppointments[0]),
  NovaOneListTableItemData(
      popupMenuOptions: listPopupMenuOptions,
      subtitle: 'Dec 25',
      title: 'John Berry',
      id: 1,
      object: recentAppointments[0]),
  NovaOneListTableItemData(
      popupMenuOptions: listPopupMenuOptions,
      subtitle: 'Dec 25',
      title: 'John Berry',
      id: 1,
      object: recentAppointments[0]),
  NovaOneListTableItemData(
      popupMenuOptions: listPopupMenuOptions,
      subtitle: 'Dec 25',
      title: 'John Berry',
      id: 1,
      object: recentAppointments[0]),
  NovaOneListTableItemData(
      popupMenuOptions: listPopupMenuOptions,
      subtitle: 'Dec 25',
      title: 'John Berry',
      id: 1,
      object: recentAppointments[0]),
  NovaOneListTableItemData(
      popupMenuOptions: listPopupMenuOptions,
      subtitle: 'Dec 25',
      title: 'John Berry',
      id: 1,
      object: recentAppointments[0]),
  NovaOneListTableItemData(
      popupMenuOptions: listPopupMenuOptions,
      subtitle: 'Dec 25',
      title: 'John Berry',
      id: 1,
      object: recentAppointments[0]),
  NovaOneListTableItemData(
      popupMenuOptions: listPopupMenuOptions,
      subtitle: 'Dec 25',
      title: 'John Berry',
      id: 1,
      object: recentAppointments[0]),
  NovaOneListTableItemData(
      popupMenuOptions: listPopupMenuOptions,
      subtitle: 'Dec 25',
      title: 'John Berry',
      id: 1,
      object: recentAppointments[0]),
  NovaOneListTableItemData(
      popupMenuOptions: listPopupMenuOptions,
      subtitle: 'Dec 25',
      title: 'John Berry',
      id: 1,
      object: recentAppointments[0]),
];

final List<NovaOneListTableItemData> allLeads = [
  NovaOneListTableItemData(
      popupMenuOptions: listPopupMenuOptions,
      subtitle: 'Dec 25',
      title: 'John Berry',
      id: 1,
      object: testlead),
  NovaOneListTableItemData(
      popupMenuOptions: listPopupMenuOptions,
      subtitle: 'Dec 25',
      title: 'John Berry',
      id: 1,
      object: testlead),
  NovaOneListTableItemData(
      popupMenuOptions: listPopupMenuOptions,
      subtitle: 'Dec 25',
      title: 'John Berry',
      id: 1,
      object: testlead),
  NovaOneListTableItemData(
      popupMenuOptions: listPopupMenuOptions,
      subtitle: 'Dec 25',
      title: 'John Berry',
      id: 1,
      object: testlead),
  NovaOneListTableItemData(
      popupMenuOptions: listPopupMenuOptions,
      subtitle: 'Dec 25',
      title: 'John Berry',
      id: 1,
      object: testlead),
  NovaOneListTableItemData(
      popupMenuOptions: listPopupMenuOptions,
      subtitle: 'Dec 25',
      title: 'John Berry',
      id: 1,
      object: testlead),
  NovaOneListTableItemData(
      popupMenuOptions: listPopupMenuOptions,
      subtitle: 'Dec 25',
      title: 'John Berry',
      id: 1,
      object: testlead),
  NovaOneListTableItemData(
      popupMenuOptions: listPopupMenuOptions,
      subtitle: 'Dec 25',
      title: 'John Berry',
      id: 1,
      object: testlead),
  NovaOneListTableItemData(
      popupMenuOptions: listPopupMenuOptions,
      subtitle: 'Dec 25',
      title: 'John Berry',
      id: 1,
      object: testlead),
  NovaOneListTableItemData(
      popupMenuOptions: listPopupMenuOptions,
      subtitle: 'Dec 25',
      title: 'John Berry',
      id: 1,
      object: testlead),
  NovaOneListTableItemData(
      popupMenuOptions: listPopupMenuOptions,
      subtitle: 'Dec 25',
      title: 'John Berry',
      id: 1,
      object: testlead),
];
