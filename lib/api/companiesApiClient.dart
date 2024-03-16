import 'dart:convert';
import 'package:http/http.dart';
import 'package:novaone/api/api.dart';
import 'package:novaone/auth/auth.dart';
import 'package:novaone/enums/enums.dart';
import 'package:novaone/models/models.dart';
import 'package:novaone/novaOneTableHelper.dart';
import 'package:novaone/novaOneUrl.dart';
import 'package:novaone/utils/utils.dart';

class CompaniesApiClient extends BaseApiClient<Company> {
  CompaniesApiClient({required Client client, required ObjectStore userStore})
      : super(client: client, objectStore: userStore);

  /// Gets the user's most recent leads from the Novaone API
  ///
  /// Returns an [ApiMessageException] object if the request fails
  /// and leads data if the request was successful
  Future<List<Company>> getRecentCompanies() async {
    final User? user = await objectStore.getUser();

    Map<String, String> parameters = {
      'email': user?.email ?? '',
      'password': await objectStore
          .getPassword(), // Have to use userStore.getPassword here because the user object has an encryptyed password
      'customerUserId': user?.customerId.toString() ?? '',
    };
    final response = await postToNovaOneApi(
        uri: NovaOneUrl.novaOneApiCompaniesData,
        parameters: parameters,
        errorMessage: 'Could not fetch companies data');

    /// Decode json string into map
    final List<dynamic> json = jsonDecode(response.body);

    /// Convert to a list of companies
    final companies =
        json.map((leadJson) => Company.fromJson(json: leadJson)).toList();

    /// Store locally
    await objectStore.storeObjects<Company>(companies);

    return companies;
  }

  /// Adds the [company] locally and on the server
  Future<void> add(Company company) async {
    final User? user = await objectStore.getUser();
    Map<String, String> parameters = {
      'customerUserId': user?.customerId.toString() ?? '',
      'email': user?.email ?? '',
      'password': await objectStore.getPassword(),
      'companyName': company.name,
      'companyEmail': company.email,
      'companyAddress': company.address,
      'companyCity': company.city,
      'companyState': company.state,
      'companyZip': company.zip,
      'companyPhoneNumber': company.phoneNumber,
      'daysOfTheWeekEnabled': company.daysOfTheWeekEnabled,
      'hoursOfTheDayEnabled': company.hoursOfTheDayEnabled,
      'allowSameDayAppointments': company.allowSameDayAppointments ? 't' : 'f',
    };

    /// Add user on the server
    postToNovaOneApi(
            uri: NovaOneUrl.novaOneApiAddCompany, parameters: parameters)
        .then((Response response) => print(response.body));
  }

  /// Deletes a [company] locally and from the server
  Future<void> delete(Company company) async {
    final User? user = await objectStore.getUser();

    Map<String, String> parameters = {
      'email': user?.email ?? '',
      'password': await objectStore.getPassword(),
      'objectId': company.id.toString(),
      'columnName': 'id',
    };

    postToNovaOneApi(
            uri: NovaOneUrl.novaOneApiDeleteCompany, parameters: parameters)
        .then((Response response) => print(response.body));

    await objectStore.deleteObject<Company>(company.id);
  }

  /// Updates the company
  Future<Company?> update(
      {required Company company,
      required Map<UpdateObject, dynamic> properties}) async {
    final User? user = await objectStore.getUser();

    /// Add in the column names we will update in the database
    /// and update the user locally
    Map<String, String> columns = {};

    Company? updatedCompany;
    if (properties.containsKey(
      UpdateObject.CompanyName,
    )) {
      final String updatedName = properties[UpdateObject.CompanyName];
      columns[NovaOneTableColumns.instance.companyName] = updatedName;
      updatedCompany = company.copyWith(name: updatedName);
    }

    if (properties.containsKey(UpdateObject.CompanyAddress)) {
      final Map<String, dynamic> json =
          jsonDecode(properties[UpdateObject.CompanyAddress]);
      final GooglePlacesPlace place = GooglePlacesPlace.fromJson(json: json);

      final addressComponents =
          ValueExtractor.getAddressComponentsFromGooglePlace(place);

      final String address = addressComponents.first;

      final String city = addressComponents[1];
      final String state = addressComponents[2];
      final String zip = addressComponents[3];

      columns[NovaOneTableColumns.instance.companyAddress] = address;
      columns[NovaOneTableColumns.instance.companyCity] = city;
      columns[NovaOneTableColumns.instance.companyState] = state;
      columns[NovaOneTableColumns.instance.companyZip] = zip;

      updatedCompany = company.copyWith(
          address: address, city: city, state: state, zip: zip);
    }

    if (properties.containsKey(UpdateObject.CompanyPhoneNumber)) {
      final String updatedPhoneNumber =
          properties[UpdateObject.CompanyPhoneNumber];
      columns[NovaOneTableColumns.instance.appointmentPhone] =
          updatedPhoneNumber;
      updatedCompany = company.copyWith(phoneNumber: updatedPhoneNumber);
    }

    if (properties.containsKey(UpdateObject.CompanyEmail)) {
      final String updatedEmail = properties[UpdateObject.CompanyEmail];
      columns[NovaOneTableColumns.instance.companyEmail] = updatedEmail;
      updatedCompany = company.copyWith(email: updatedEmail);
    }

    if (properties.containsKey(UpdateObject.CompanySameDayAppointments)) {
      final String updatedSameDayAppointments =
          properties[UpdateObject.CompanySameDayAppointments];
      columns[NovaOneTableColumns.instance.companyAllowSameDayAppointments] =
          updatedSameDayAppointments;
      updatedCompany = company.copyWith(
          allowSameDayAppointments:
              updatedSameDayAppointments == 't' ? true : false);
    }

    if (properties.containsKey(UpdateObject.CompanyDays)) {
      final String updatedCompanyDays = properties[UpdateObject.CompanyDays];
      columns[NovaOneTableColumns.instance.companyDays] = updatedCompanyDays;
      updatedCompany =
          company.copyWith(daysOfTheWeekEnabled: updatedCompanyDays);
    }

    if (properties.containsKey(UpdateObject.CompanyHours)) {
      final String updatedCompanyHours = properties[UpdateObject.CompanyHours];
      columns[NovaOneTableColumns.instance.companyHours] = updatedCompanyHours;
      updatedCompany =
          company.copyWith(hoursOfTheDayEnabled: updatedCompanyHours);
    }

    if (properties.containsKey(UpdateObject.CompanyAutoRespondText)) {
      final String updatedCompanyText =
          properties[UpdateObject.CompanyAutoRespondText];
      columns[NovaOneTableColumns.instance.companyAutoRespondText] =
          updatedCompanyText;
      updatedCompany = company.copyWith(autoRespondText: updatedCompanyText);
    }

    // Encode columns as a string and send to API
    final jsonEncodedColumns = jsonEncode(columns);

    Map<String, String> parameters = {
      'email': user?.email ?? '',
      'password': await objectStore
          .getPassword(), // Have to use userStore.getPassword here because the user object has an encryptyed password
      'objectId': company.id.toString(),
      'tableName': NovaOneTableHelper.instance.company,
      'columns': jsonEncodedColumns,
    };

    /// Update user on the server
    final uri = properties.containsKey(UpdateObject.CompanyAddress)
        ? NovaOneUrl.novaOneApiUpdateCompanyAddress
        : NovaOneUrl.novaOneApiUpdateObject;
    postToNovaOneApi(uri: uri, parameters: parameters)
        .then((Response response) => print(response.body));

    /// Update locally
    if (updatedCompany != null) {
      objectStore.updateObject<Company>(updatedCompany);
    }

    return updatedCompany;
  }
}
