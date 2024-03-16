import 'package:novaone/models/models.dart';
import 'package:novaone/utils/dateTimeHelper.dart';
import 'package:novaone/extensions/extensions.dart';

class Appointment extends BaseModel {
  final int id;
  final String name;
  final String phoneNumber;
  final DateTime time;
  final DateTime? created;
  final String timeZone;
  final bool confirmed;
  final int companyId;
  final String? unitType;
  final String? email;
  final String? dateOfBirth;
  final String? testType;
  final String? gender;
  final String? address;
  final String? city;
  final String? zip;

  Appointment(
      {required this.name,
      required this.id,
      required this.phoneNumber,
      required this.time,
      this.created,
      required this.timeZone,
      required this.confirmed,
      required this.companyId,
      this.unitType,
      this.email,
      this.dateOfBirth,
      this.testType,
      this.gender,
      this.address,
      this.city,
      this.zip})
      : super(id: id);

  @override
  factory Appointment.fromJson({required Map<String, dynamic> json}) {
    return Appointment(
      id: json['id'],
      name: json['name'],
      phoneNumber: json['phoneNumber'],
      time: DateTimeHelper.instance.convertToDateTime(
              json['time'], DateTimeHelper.standardDateStringFormat,
              secondaryFormat: "yyyy-MM-dd HH:mm:ss+Z") ??
          DateTime.now(),
      created: DateTimeHelper.instance.convertToDateTime(
            json['created'],
            DateTimeHelper.standardDateStringFormat,
          ) ??
          DateTime.now(),
      timeZone: json['timeZone'],
      confirmed: BaseModel.convertIntToBool(json['confirmed']),
      companyId: json['companyId'],
      unitType: json['unitType'],
      email: json['email'],
      dateOfBirth: json['dateOfBirth'],
      testType: json['testType'],
      gender: json['gender'],
      address: json['address'],
      city: json['city'],
      zip: json['zip'],
    );
  }

  Appointment copyWith({
    int? id,
    String? name,
    String? phoneNumber,
    DateTime? time,
    DateTime? created,
    String? timeZone,
    bool? confirmed,
    int? companyId,
    String? unitType,
    String? email,
    String? dateOfBirth,
    String? testType,
    String? gender,
    String? address,
    String? city,
    String? zip,
  }) =>
      Appointment(
        id: id ?? this.id,
        name: name ?? this.name,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        time: time ?? this.time,
        created: created ?? this.created,
        timeZone: timeZone ?? this.timeZone,
        confirmed: confirmed ?? this.confirmed,
        companyId: companyId ?? this.companyId,
        unitType: unitType ?? this.unitType,
        email: email ?? this.email,
        dateOfBirth: dateOfBirth ?? this.dateOfBirth,
        testType: testType ?? this.testType,
        gender: gender ?? this.gender,
        address: address ?? this.address,
        city: city ?? this.city,
        zip: zip ?? this.zip,
      );

  @override
  List<Object?> get props => [
        id,
        name,
        phoneNumber,
        time,
        created,
        timeZone,
        confirmed,
        companyId,
        unitType,
        email,
        dateOfBirth,
        testType,
        gender,
        address,
        city,
        zip
      ];

  @override
  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'phoneNumber': phoneNumber,
        'time': time.toString(),
        'created': created.toString(),
        'timeZone': timeZone,
        'confirmed': confirmed.toInt,
        'companyId': companyId,
        'unitType': unitType,
        'email': email,
        'dateOfBirth': dateOfBirth,
        'testType': testType,
        'gender': gender,
        'address': address,
        'city': city,
        'zip': zip,
      };
}
