import 'package:novaone/models/models.dart';
import 'package:novaone/utils/utils.dart';
import 'package:novaone/extensions/extensions.dart';

class Lead extends BaseModel {
  final int id;
  final String name;
  final String? phoneNumber;
  final String? email;
  final DateTime dateOfInquiry;
  final String? renterBrand;
  final int companyId;
  final DateTime? sentTextDate;
  final DateTime? sentEmailDate;
  final bool filledOutForm;
  final bool madeAppointment;
  final String companyName;

  Lead(
      {required this.name,
      required this.id,
      this.phoneNumber,
      this.email,
      required this.dateOfInquiry,
      this.renterBrand,
      required this.companyId,
      this.sentTextDate,
      this.sentEmailDate,
      required this.filledOutForm,
      required this.madeAppointment,
      required this.companyName})
      : super(id: id);

  factory Lead.fromJson({required Map<String, dynamic> json}) {
    return Lead(
      id: json['id'],
      name: json['name'],
      phoneNumber: json['phoneNumber'],
      email: json['email'],
      dateOfInquiry: DateTimeHelper.instance.convertToDateTime(
            json['dateOfInquiry'],
            DateTimeHelper.standardDateStringFormat,
          ) ??
          DateTime.now(),
      renterBrand: json['renterBrand'],
      companyId: json['companyId'],
      sentTextDate: DateTimeHelper.instance.convertToDateTime(
        json['sentTextDate'],
        DateTimeHelper.standardDateStringFormat,
      ),
      sentEmailDate: DateTimeHelper.instance.convertToDateTime(
        json['sentEmailDate'],
        DateTimeHelper.standardDateStringFormat,
      ),
      filledOutForm: BaseModel.convertIntToBool(json['filledOutForm']),
      madeAppointment: BaseModel.convertIntToBool(json['madeAppointment']),
      companyName: json['companyName'],
    );
  }

  /// Converts the user object to a JSON map
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'phoneNumber': phoneNumber,
      'email': email,
      'dateOfInquiry': dateOfInquiry.toString(),
      'renterBrand': renterBrand,
      'companyId': companyId,
      'sentTextDate': sentTextDate.toString(),
      'sentEmailDate': sentEmailDate.toString(),
      'filledOutForm': filledOutForm.toInt,
      'madeAppointment': madeAppointment.toInt,
      'companyName': companyName,
    };
  }

  /// Copies the lead instance with certain desired property values
  Lead copyWith(
          {int? id,
          String? name,
          String? phoneNumber,
          String? email,
          DateTime? dateOfInquiry,
          String? renterBrand,
          int? companyId,
          DateTime? sentTextDate,
          DateTime? sentEmailDate,
          bool? filledOutForm,
          bool? madeAppointment,
          String? companyName}) =>
      Lead(
          id: id ?? this.id,
          name: name ?? this.name,
          phoneNumber: phoneNumber ?? this.phoneNumber,
          email: email ?? this.email,
          dateOfInquiry: dateOfInquiry ?? this.dateOfInquiry,
          renterBrand: renterBrand ?? this.renterBrand,
          companyId: companyId ?? this.companyId,
          sentTextDate: sentTextDate ?? this.sentTextDate,
          sentEmailDate: sentEmailDate ?? this.sentEmailDate,
          filledOutForm: filledOutForm ?? this.filledOutForm,
          madeAppointment: madeAppointment ?? this.madeAppointment,
          companyName: companyName ?? this.companyName);

  @override
  String toString() {
    return this.toMap().toString();
  }

  @override
  List<Object?> get props => [
        id,
        name,
        phoneNumber,
        email,
        dateOfInquiry,
        renterBrand,
        companyId,
        sentTextDate,
        sentEmailDate,
        filledOutForm,
        madeAppointment,
        companyName
      ];
}
