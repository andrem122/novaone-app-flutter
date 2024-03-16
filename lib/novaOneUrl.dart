import 'package:novaone/apiCredentials.dart';

/// Urls and headers used throughout the app
class NovaOneUrl {
  /// Authorities
  static const novaOneAuthority = 'www.novaonesoftware.com';
  static const googlePlacesAuthority = 'maps.googleapis.com';

  /// Base paths
  static const googlePlacesBasePath = '/maps/api/place';
  static const novaOneForgotPasswordEmailPath = '/accounts/password_reset';

  static Uri get novaOneWebsiteUrl => Uri.https(novaOneApiAuthority, '');
  static Uri get novaOneWebsiteForgotUrl =>
      Uri.https(novaOneApiAuthority, novaOneForgotPasswordEmailPath);

  /// Google Places API additional paths
  static const googlePlacesAutocompletePath =
      '$googlePlacesBasePath/autocomplete/json';
  static const googlePlacesPlaceDetailsPath =
      '$googlePlacesBasePath/details/json';

  /// Novaone API additional paths
  static const novaOneApiAuthority = 'graystonerealtyfl.com';
  static const novaOneApiBasePath = '/NovaOne';
  static const novaOneApiPathLogin = novaOneApiBasePath + '/login.php';
  static const novaOneApiPathChartMonthlyData =
      novaOneApiBasePath + '/chartDataMonthly.php';
  static const novaOneApiPathObjectCountsData =
      novaOneApiBasePath + '/objectCounts.php';
  static const novaOneApiPathLeadsData = novaOneApiBasePath + '/leads.php';
  static const novaOneApiPathAddLead = novaOneApiBasePath + '/addLead.php';
  static const novaOneApiPathAddCompany =
      novaOneApiBasePath + '/addCompany.php';
  static const novaOneApiPathMoreLeadsData =
      novaOneApiBasePath + '/moreLeads.php';
  static const novaOneApiPathAppointmentsData =
      novaOneApiBasePath + '/appointments.php';
  static const novaOneApiPathMoreAppointmentsData =
      novaOneApiBasePath + '/moreAppointments.php';
  static const novaOneApiAddAppointmentPath = '/appointments/new';
  static const novaOneApiPathCompaniessData =
      novaOneApiBasePath + '/companies.php';
  static const novaOneApiPathMoreCompaniessData =
      novaOneApiBasePath + '/moreCompanies.php';
  static const novaOneApiPathUpdateObject =
      novaOneApiBasePath + '/updateObject.php';
  static const novaOneApiPathUpdateAppointment =
      novaOneApiBasePath + '/updateAppointmentMedicalAndRealEstate.php';
  static const novaOneApiPathUpdateEmail =
      novaOneApiBasePath + '/updateEmail.php';
  static const novaOneApiPathUpdatePassword =
      novaOneApiBasePath + '/updatePassword.php';
  static const novaOneApiPathUpdateCompanyAddress =
      novaOneApiBasePath + '/updateCompanyAddress.php';
  static const novaOneApiPathUpdateName =
      novaOneApiBasePath + '/updateName.php';
  static const novaOneApiPathSupport = novaOneApiBasePath + '/support.php';
  static const novaOneApiDeleteObjectPath =
      novaOneApiBasePath + '/deleteObject.php';
  static const novaOneApiDeleteRealEstateAppointmentPath =
      novaOneApiBasePath + '/deleteAppointmentRealEstate.php';
  static const novaOneApiDeleteCompanyPath =
      novaOneApiBasePath + '/deleteCompany.php';
  static const novaOneApiRefreshLeadsPath =
      novaOneApiBasePath + '/refreshLeads.php';
  static const novaOneApiRefreshAppointmentsPath =
      novaOneApiBasePath + '/refreshAppointments.php';
  static const novaOneApiRefreshCompaniesPath =
      novaOneApiBasePath + '/refreshCompanies.php';
  static const novaOneApiAddPushNotificationTokenPath =
      novaOneApiBasePath + '/addDeviceToken.php';

  static Uri get novaOneApiUrl =>
      Uri.https(novaOneApiAuthority, novaOneApiBasePath);

  /// Read
  static Uri get novaOneApiUrlLogin =>
      Uri.https(novaOneApiAuthority, novaOneApiPathLogin);
  static Uri get novaOneApiChartMonthlyData =>
      Uri.https(novaOneApiAuthority, novaOneApiPathChartMonthlyData);
  static Uri get novaOneApiObjectCountsData =>
      Uri.https(novaOneApiAuthority, novaOneApiPathObjectCountsData);
  static Uri get novaOneApiLeadsData =>
      Uri.https(novaOneApiAuthority, novaOneApiPathLeadsData);
  static Uri get novaOneApiMoreLeadsData =>
      Uri.https(novaOneApiAuthority, novaOneApiPathMoreLeadsData);
  static Uri get novaOneApiAppointmentsData =>
      Uri.https(novaOneApiAuthority, novaOneApiPathAppointmentsData);
  static Uri get novaOneApiMoreAppointmentsData =>
      Uri.https(novaOneApiAuthority, novaOneApiPathMoreAppointmentsData);
  static Uri get novaOneApiCompaniesData =>
      Uri.https(novaOneApiAuthority, novaOneApiPathCompaniessData);
  static Uri get novaOneApiMoreCompaniesData =>
      Uri.https(novaOneApiAuthority, novaOneApiPathMoreCompaniessData);
  static Uri get novaOneApiRefreshLeadsData =>
      Uri.https(novaOneApiAuthority, novaOneApiRefreshLeadsPath);
  static Uri get novaOneApiRefreshAppointmentsData =>
      Uri.https(novaOneApiAuthority, novaOneApiRefreshAppointmentsPath);
  static Uri get novaOneApiRefreshCompaniesData =>
      Uri.https(novaOneApiAuthority, novaOneApiRefreshCompaniesPath);

  /// Update
  static Uri get novaOneApiUpdateObject =>
      Uri.https(novaOneApiAuthority, novaOneApiPathUpdateObject);
  static Uri get novaOneApiUpdateEmail =>
      Uri.https(novaOneApiAuthority, novaOneApiPathUpdateEmail);
  static Uri get novaOneApiUpdatePassword =>
      Uri.https(novaOneApiAuthority, novaOneApiPathUpdatePassword);
  static Uri get novaOneApiUpdateName =>
      Uri.https(novaOneApiAuthority, novaOneApiPathUpdateName);
  static Uri get novaOneApiUpdateAppointment =>
      Uri.https(novaOneApiAuthority, novaOneApiPathUpdateAppointment);
  static Uri get novaOneApiUpdateCompanyAddress =>
      Uri.https(novaOneApiAuthority, novaOneApiPathUpdateCompanyAddress);

  /// Delete
  static Uri get novaOneApiDeleteObject =>
      Uri.https(novaOneApiAuthority, novaOneApiDeleteObjectPath);
  static Uri get novaOneApiDeleteAppointmentRealEstate =>
      Uri.https(novaOneApiAuthority, novaOneApiDeleteRealEstateAppointmentPath);
  static Uri get novaOneApiDeleteCompany =>
      Uri.https(novaOneApiAuthority, novaOneApiDeleteCompanyPath);

  /// Add
  static Uri get novaOneApiAddToken =>
      Uri.https(novaOneApiAuthority, novaOneApiAddPushNotificationTokenPath);
  static Uri get novaOneApiAddLead =>
      Uri.https(novaOneApiAuthority, novaOneApiPathAddLead);
  static Uri get novaOneApiAddCompany =>
      Uri.https(novaOneApiAuthority, novaOneApiPathAddCompany);
  static Uri novaOneApiAddAppointment(int companyId) {
    final Map<String, dynamic> queryParameters = {
      'c': companyId.toString(),
    };
    return Uri.https(
        novaOneAuthority, novaOneApiAddAppointmentPath, queryParameters);
  }

  /// Support
  static Uri get novaOneApiSupport =>
      Uri.https(novaOneApiAuthority, novaOneApiPathSupport);

  /// Google Places
  static Uri googlePlacesApiAutocomplete(
      {required String input,
      required String types,
      required String sessionToken}) {
    final Map<String, dynamic> queryParameters = {
      'input': input,
      'key': ApiCredentials.googlePlacesApiKey,
      'types': types,
      'sessiontoken': sessionToken,
    };
    return Uri.https(
        googlePlacesAuthority, googlePlacesAutocompletePath, queryParameters);
  }

  /// Google Places
  static Uri googlePlacesApiPlaceDetails(
      {required String placeId, required String sessionToken}) {
    final Map<String, dynamic> queryParameters = {
      'place_id': placeId,
      'key': ApiCredentials.googlePlacesApiKey,
      'sessiontoken': sessionToken,
    };
    return Uri.https(
        googlePlacesAuthority, googlePlacesPlaceDetailsPath, queryParameters);
  }

  /// Returns the uri used to view the appointment page for a [companyId]
  static Uri novaOneViewAppointmentPage(int companyId) {
    final Map<String, dynamic> queryParameters = {
      'c': companyId.toString(),
    };
    return Uri.https(novaOneAuthority, '/appointments/new', queryParameters);
  }
}
