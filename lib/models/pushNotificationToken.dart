import 'package:novaone/models/baseModel.dart';

class PushNotificationToken extends BaseModel {
  final int id;
  final String deviceToken;
  final int leadCount;
  final int appointmentCount;
  final int applicationCount;
  final String type;

  PushNotificationToken(
      {required this.id,
      required this.deviceToken,
      required this.leadCount,
      required this.appointmentCount,
      required this.applicationCount,
      required this.type})
      : super(id: id);

  @override
  Map<String, dynamic> toMap() => {
        'id': id,
        'device_token': deviceToken,
        'lead_count': leadCount,
        'appointment_count': appointmentCount,
        'application_count': applicationCount,
        'type': type,
      };

  factory PushNotificationToken.fromJson({required Map<String, dynamic> json}) {
    return PushNotificationToken(
        id: json['id'],
        deviceToken: json['device_token'],
        leadCount: json['lead_count'],
        appointmentCount: json['appointment_count'],
        applicationCount: json['application_count'],
        type: json['type']);
  }
}
