import 'dart:convert';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:novaone/api/api.dart';
import 'package:novaone/auth/auth.dart';
import 'package:novaone/enums/enums.dart';
import 'package:novaone/models/models.dart';
import 'package:novaone/novaOneTableHelper.dart';
import 'package:novaone/novaOneUrl.dart';
import 'package:novaone/utils/utils.dart';

class AppointmentsApiClient extends BaseApiClient<Appointment> {
  AppointmentsApiClient(
      {required Client client, required ObjectStore objectStore})
      : super(client: client, objectStore: objectStore);

  /// Gets the user's recent most recent appointments from the Novaone API
  ///
  /// Returns an [ApiMessageException] object if the request fails
  /// and data if the request was successful
  Future<List<Appointment>> getRecentAppointments() async {
    final User? user = await objectStore.getUser();

    Map<String, String> parameters = {
      'email': user?.email ?? '',
      'password': await objectStore
          .getPassword(), // Have to use userStore.getPassword here because the user object has an encryptyed password
      'customerUserId': user?.customerId.toString() ?? '',
    };
    final response = await postToNovaOneApi(
        uri: NovaOneUrl.novaOneApiAppointmentsData,
        parameters: parameters,
        errorMessage: 'Could not fetch leads data');

    final List<dynamic> json = jsonDecode(response.body);
    final appointments = json
        .map((appointmentJson) => Appointment.fromJson(json: appointmentJson))
        .toList();

    /// Store locally
    await objectStore.storeObjects<Appointment>(appointments);

    return appointments;
  }

  /// Adds the [appointment] locally and on the server
  Future<ApiMessageException?> add(Appointment appointment) async {
    final dateFormatter = DateFormat('yyyy-MM-dd HH:mm:ss-0400');
    final String dateFormattedString = dateFormatter.format(appointment.time);
    Map<String, String> parameters = {
      'name': appointment.name,
      'unit_type': appointment.unitType ?? '',
      'phone_number': StringFormatter.instance
          .formatPhoneNumberForApiCall(appointment.phoneNumber),
      'time': dateFormattedString,
    };

    /// Add on the server
    try {
      await postToNovaOneApi(
              uri: NovaOneUrl.novaOneApiAddAppointment(appointment.companyId),
              parameters: parameters)
          .then((Response response) => print(response.body));
    } catch (error) {
      /// Handle any errors from the server when making an appointment
      if (error is ApiMessageException) {
        return error;
      }
    }

    return null;
  }

  /// Deletes an [appointment] locally and from the server
  Future<void> delete(Appointment appointment) async {
    final User? user = await objectStore.getUser();

    Map<String, String> parameters = {
      'email': user?.email ?? '',
      'password': await objectStore.getPassword(),
      'objectId': appointment.id.toString(),
      'columnName': 'id',
    };

    postToNovaOneApi(
            uri: NovaOneUrl.novaOneApiDeleteAppointmentRealEstate,
            parameters: parameters)
        .then((Response response) => print(response.body));

    await objectStore.deleteObject<Appointment>(appointment.id);
  }

  /// Updates the appointment
  Future<Appointment?> update(
      {required Appointment appointment,
      required Map<UpdateObject, dynamic> properties}) async {
    final User? user = await objectStore.getUser();

    /// Add in the column names we will update in the database
    /// and update the user locally
    Map<String, String> columns = {};

    Appointment? updatedAppointment;
    if (properties.containsKey(
      UpdateObject.AppointmentName,
    )) {
      final String updatedName = properties[UpdateObject.AppointmentName];
      columns[NovaOneTableColumns.instance.appointmentName] = updatedName;
      updatedAppointment = appointment.copyWith(name: updatedName);
    }

    if (properties.containsKey(UpdateObject.AppointmentPhoneNumber)) {
      final String updatedPhoneNumber =
          properties[UpdateObject.AppointmentPhoneNumber];
      columns[NovaOneTableColumns.instance.appointmentPhone] =
          updatedPhoneNumber;
      updatedAppointment =
          appointment.copyWith(phoneNumber: updatedPhoneNumber);
    }

    if (properties.containsKey(UpdateObject.AppointmentUnitType)) {
      final String updatedUnitType =
          properties[UpdateObject.AppointmentUnitType];
      columns[NovaOneTableColumns.instance.appointmentUnitType] =
          updatedUnitType;
      updatedAppointment = appointment.copyWith(unitType: updatedUnitType);
    }

    if (properties.containsKey(UpdateObject.AppointmentTime)) {
      final DateTime updatedTime =
          DateTime.tryParse(properties[UpdateObject.AppointmentTime]) ??
              DateTime.now();
      final dateFormatter = DateFormat('yyyy-MM-dd HH:mm:ss-0400');
      final String dateFormattedString = dateFormatter.format(updatedTime);
      columns[NovaOneTableColumns.instance.appointmentTime] =
          dateFormattedString;
      updatedAppointment = appointment.copyWith(time: updatedTime);
    }

    if (properties.containsKey(UpdateObject.AppointmentConfirmed)) {
      final String updatedAppointmentConfirmed =
          properties[UpdateObject.AppointmentConfirmed];
      columns[NovaOneTableColumns.instance.appointmentConfirmed] =
          updatedAppointmentConfirmed;
      updatedAppointment = appointment.copyWith(
          confirmed: updatedAppointmentConfirmed == 't' ? true : false);
    }

    // Encode columns as a string and send to API
    final jsonEncodedColumns = jsonEncode(columns);

    Map<String, String> parameters = {
      'email': user?.email ?? '',
      'password': await objectStore
          .getPassword(), // Have to use userStore.getPassword here because the user object has an encryptyed password
      'objectId': appointment.id.toString(),
      'tableName': properties.containsKey(UpdateObject.AppointmentUnitType)
          ? NovaOneTableHelper.instance.appointmentsRealEstate
          : NovaOneTableHelper.instance.appointmentsBase,
      'columns': jsonEncodedColumns,
    };

    /// Update user on the server
    final uri = properties.containsKey(UpdateObject.AppointmentUnitType)
        ? NovaOneUrl.novaOneApiUpdateAppointment
        : NovaOneUrl.novaOneApiUpdateObject;
    postToNovaOneApi(uri: uri, parameters: parameters)
        .then((Response response) => print(response.body));

    /// Update locally
    if (updatedAppointment != null) {
      objectStore.updateObject<Appointment>(updatedAppointment);
    }

    return updatedAppointment;
  }
}
