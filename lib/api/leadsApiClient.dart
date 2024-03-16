import 'dart:convert';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:novaone/api/api.dart';
import 'package:novaone/auth/auth.dart';
import 'package:novaone/enums/enums.dart';
import 'package:novaone/models/models.dart';
import 'package:novaone/novaOneTableHelper.dart';
import 'package:novaone/novaOneUrl.dart';

class LeadsApiClient extends BaseApiClient<Lead> {
  LeadsApiClient({required Client client, required ObjectStore objectStore})
      : super(client: client, objectStore: objectStore);

  /// Gets the user's most recent leads from the Novaone API
  ///
  /// Returns an [ApiMessageException] object if the request fails
  /// and leads data if the request was successful
  Future<List<Lead>> getRecentLeads() async {
    final User? user = await objectStore.getUser();

    Map<String, String> parameters = {
      'email': user?.email ?? '',
      'password': await objectStore
          .getPassword(), // Have to use userStore.getPassword here because the user object has an encryptyed password
      'customerUserId': user?.customerId.toString() ?? '',
    };
    final response = await postToNovaOneApi(
        uri: NovaOneUrl.novaOneApiLeadsData,
        parameters: parameters,
        errorMessage: 'Could not fetch lead data');

    final List<dynamic> json = jsonDecode(response.body);
    final leads =
        json.map((leadJson) => Lead.fromJson(json: leadJson)).toList();

    /// Store locally
    await objectStore.storeObjects<Lead>(leads);
    return leads;
  }

  /// Deletes a [lead] locally and from the server
  Future<void> delete(Lead lead) async {
    final User? user = await objectStore.getUser();

    Map<String, String> parameters = {
      'email': user?.email ?? '',
      'password': await objectStore
          .getPassword(), // Have to use userStore.getPassword here because the user object has an encryptyed password
      'objectId': lead.id.toString(),
      'tableName': NovaOneTableHelper.instance.leads,
      'columnName': 'id',
    };

    postToNovaOneApi(
            uri: NovaOneUrl.novaOneApiDeleteObject, parameters: parameters)
        .then((Response response) => print(response.body));

    await objectStore.deleteObject<Lead>(lead.id);
  }

  /// Adds the [lead] locally and on the server
  Future<void> add(Lead lead) async {
    final User? user = await objectStore.getUser();

    final dateFormatter = DateFormat('yyyy-MM-dd HH:mm:ss-0400');
    final String dateFormattedString = dateFormatter.format(lead.dateOfInquiry);
    Map<String, String> parameters = {
      'email': user?.email ?? '',
      'password': await objectStore.getPassword(),
      'customerUserId': user?.customerId.toString() ?? '',
      'leadName': lead.name,
      'leadPhoneNumber': lead.phoneNumber ?? '',
      'leadEmail': lead.email ?? '',
      'leadRenterBrand': lead.renterBrand ?? 'Zillow',
      'dateOfInquiry': dateFormattedString,
      'leadCompanyId': lead.companyId.toString(),
    };

    /// Add user on the server
    postToNovaOneApi(uri: NovaOneUrl.novaOneApiAddLead, parameters: parameters)
        .then((Response response) => print(response.body));
  }

  /// Updates the lead
  Future<Lead?> update(
      {required Lead lead,
      required Map<UpdateObject, dynamic> properties}) async {
    final User? user = await objectStore.getUser();

    /// Add in the column names we will update in the database
    /// and update the user locally
    Map<String, String> columns = {};

    Lead? updatedLead;
    if (properties.containsKey(UpdateObject.LeadName)) {
      final String updatedName = properties[UpdateObject.LeadName];
      columns[NovaOneTableColumns.instance.leadName] = updatedName;
      updatedLead = lead.copyWith(name: updatedName);
    }

    if (properties.containsKey(UpdateObject.LeadRenterBrand)) {
      final String updatedRenterBrand =
          properties[UpdateObject.LeadRenterBrand];
      columns[NovaOneTableColumns.instance.leadRenterBrand] =
          updatedRenterBrand;
      updatedLead = lead.copyWith(renterBrand: updatedRenterBrand);
    }

    if (properties.containsKey(UpdateObject.LeadEmail)) {
      final String updatedEmail = properties[UpdateObject.LeadEmail];
      columns[NovaOneTableColumns.instance.leadEmail] = updatedEmail;
      updatedLead = lead.copyWith(email: updatedEmail);
    }

    if (properties.containsKey(UpdateObject.LeadCompany)) {
      final List<String> updatedCompanyListString =
          (properties[UpdateObject.LeadCompany] as String).split(' ');
      final String companyId = updatedCompanyListString[0];

      /// Get everything after the company ID in the list
      final List<String> companyNameList = updatedCompanyListString
          .getRange(1, updatedCompanyListString.length)
          .toList();

      /// Join everything in the list with a space since we split everything in the list with a space
      final String companyName = companyNameList.join(' ');

      columns[NovaOneTableColumns.instance.leadCompanyId] = companyId;
      updatedLead = lead.copyWith(
          companyId: int.parse(companyId), companyName: companyName);
    }

    if (properties.containsKey(UpdateObject.LeadPhone)) {
      final String updatedPhone = properties[UpdateObject.LeadPhone];
      columns[NovaOneTableColumns.instance.leadPhone] = updatedPhone;
      updatedLead = lead.copyWith(phoneNumber: updatedPhone);
    }

    if (properties.containsKey(UpdateObject.LeadMadeAppointment)) {
      final String updatedMadeApoointment =
          properties[UpdateObject.LeadMadeAppointment];
      columns[NovaOneTableColumns.instance.leadMadeAppointment] =
          updatedMadeApoointment;
      updatedLead = lead.copyWith(
          madeAppointment: updatedMadeApoointment == 't' ? true : false);
    }

    if (properties.containsKey(UpdateObject.LeadSentEmailDate)) {
      final DateTime updatedSentEmailDate =
          DateTime.tryParse(properties[UpdateObject.LeadSentEmailDate]) ??
              DateTime.now();
      final dateFormatter = DateFormat('yyyy-MM-dd HH:mm:ss-0400');
      final String dateFormattedString =
          dateFormatter.format(updatedSentEmailDate);
      columns[NovaOneTableColumns.instance.leadSentEmailDate] =
          dateFormattedString;
      updatedLead = lead.copyWith(sentEmailDate: updatedSentEmailDate);
    }

    // Encode columns as a string and send to API
    final jsonEncodedColumns = jsonEncode(columns);

    Map<String, String> parameters = {
      'email': user?.email ?? '',
      'password': await objectStore
          .getPassword(), // Have to use userStore.getPassword here because the user object has an encryptyed password
      'objectId': lead.id.toString(),
      'tableName': NovaOneTableHelper.instance.leads,
      'columns': jsonEncodedColumns,
    };

    /// Update user on the server
    postToNovaOneApi(
            uri: NovaOneUrl.novaOneApiUpdateObject, parameters: parameters)
        .then((Response response) => print(response.body));

    /// Update locally
    if (updatedLead != null) {
      objectStore.updateObject<Lead>(updatedLead);
    }

    return updatedLead;
  }
}
