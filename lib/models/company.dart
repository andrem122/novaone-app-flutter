import 'package:novaone/models/models.dart';
import 'package:novaone/utils/utils.dart';
import 'package:novaone/extensions/extensions.dart';

class Company extends BaseModel {
  final int id;
  final String name;
  final String address;
  final String phoneNumber;
  final String? autoRespondNumber;
  final String? autoRespondText;
  final String email;
  final DateTime created;
  final bool allowSameDayAppointments;
  final String daysOfTheWeekEnabled;
  final String hoursOfTheDayEnabled;
  final String city;
  final int customerUserId;
  final String state;
  final String zip;

  String get shortenedAddress => address.split(',')[0];

  Company(
      {required this.id,
      required this.name,
      required this.address,
      required this.phoneNumber,
      required this.autoRespondNumber,
      required this.autoRespondText,
      required this.email,
      required this.created,
      required this.allowSameDayAppointments,
      required this.daysOfTheWeekEnabled,
      required this.hoursOfTheDayEnabled,
      required this.city,
      required this.customerUserId,
      required this.state,
      required this.zip})
      : super(id: id);

  factory Company.fromJson({required Map<String, dynamic> json}) {
    return Company(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      phoneNumber: json['phoneNumber'],
      autoRespondNumber: json['autoRespondNumber'],
      autoRespondText: json['autoRespondText'],
      email: json['email'],
      created: DateTimeHelper.instance.convertToDateTime(
            json['created'],
            DateTimeHelper.standardDateStringFormat,
          ) ??
          DateTime.now(),
      allowSameDayAppointments:
          BaseModel.convertIntToBool(json['allowSameDayAppointments']),
      daysOfTheWeekEnabled: json['daysOfTheWeekEnabled'],
      hoursOfTheDayEnabled: json['hoursOfTheDayEnabled'],
      city: json['city'],
      customerUserId: json['customerUserId'],
      state: json['state'],
      zip: json['zip'],
    );
  }

  /// Copies a company object with certain properties being altered if desired
  Company copyWith(
          {int? id,
          String? name,
          String? address,
          String? phoneNumber,
          String? autoRespondNumber,
          String? autoRespondText,
          String? email,
          DateTime? created,
          bool? allowSameDayAppointments,
          String? daysOfTheWeekEnabled,
          String? hoursOfTheDayEnabled,
          String? city,
          int? customerUserId,
          String? state,
          String? zip}) =>
      Company(
          id: id ?? this.id,
          name: name ?? this.name,
          address: address ?? this.address,
          phoneNumber: phoneNumber ?? this.phoneNumber,
          autoRespondNumber: autoRespondNumber ?? this.autoRespondNumber,
          autoRespondText: autoRespondText ?? this.autoRespondText,
          email: email ?? this.email,
          created: created ?? this.created,
          allowSameDayAppointments:
              allowSameDayAppointments ?? this.allowSameDayAppointments,
          daysOfTheWeekEnabled:
              daysOfTheWeekEnabled ?? this.daysOfTheWeekEnabled,
          hoursOfTheDayEnabled:
              hoursOfTheDayEnabled ?? this.hoursOfTheDayEnabled,
          city: city ?? this.city,
          customerUserId: customerUserId ?? this.customerUserId,
          state: state ?? this.state,
          zip: zip ?? this.zip);

  @override
  List<Object?> get props => [
        id,
        name,
        address,
        phoneNumber,
        autoRespondNumber,
        autoRespondText,
        email,
        created,
        allowSameDayAppointments,
        daysOfTheWeekEnabled,
        hoursOfTheDayEnabled,
        city,
        customerUserId,
        state,
        zip,
      ];

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'phoneNumber': phoneNumber,
      'autoRespondNumber': autoRespondNumber,
      'autoRespondText': autoRespondText,
      'email': email,
      'created': created.toString(),
      'allowSameDayAppointments': allowSameDayAppointments.toInt,
      'daysOfTheWeekEnabled': daysOfTheWeekEnabled,
      'hoursOfTheDayEnabled': hoursOfTheDayEnabled,
      'city': city,
      'customerUserId': customerUserId,
      'state': state,
      'zip': zip,
    };
  }
}
