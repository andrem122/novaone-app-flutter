import 'package:novaone/models/baseModel.dart';

class User extends BaseModel {
  final int customerId;
  final int userId;
  final String password;
  final String lastLogin;
  final String username;
  String firstName;
  String lastName;
  String email;
  final String dateJoined;
  final bool isPaying;
  bool wantsSms;
  bool wantsEmailNotifications;
  String phoneNumber;
  final String customerType;

  // Computed properties
  String get fullName {
    return '$firstName $lastName';
  }

  User(
      {required this.customerId,
      required this.userId,
      required this.password,
      required this.lastLogin,
      required this.username,
      required this.firstName,
      required this.lastName,
      required this.email,
      required this.dateJoined,
      required this.isPaying,
      required this.wantsSms,
      required this.wantsEmailNotifications,
      required this.phoneNumber,
      required this.customerType})
      : super(id: customerId);

  @override
  List<Object> get props => [
        customerId,
        userId,
        password,
        lastLogin,
        username,
        firstName,
        lastName,
        email,
        dateJoined,
        isPaying,
        wantsSms,
        wantsEmailNotifications,
        phoneNumber,
        customerType
      ];
  factory User.fromJson({required Map<String, dynamic> json}) {
    return User(
      customerId: json['id'],
      userId: json['userId'],
      password: json['password'],
      lastLogin: json['lastLogin'],
      username: json['username'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      dateJoined: json['dateJoined'],
      isPaying: json['isPaying'],
      wantsSms: json['wantsSms'],
      wantsEmailNotifications: json['wantsEmailNotifications'],
      phoneNumber: json['phoneNumber'],
      customerType: json['customerType'],
    );
  }

  @override
  String toString() {
    return this.toMap().toString();
  }

  /// Converts the user object to a Map object
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': customerId,
      'userId': userId,
      'password': password,
      'lastLogin': lastLogin.toString(),
      'username': username,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'dateJoined': dateJoined.toString(),
      'isPaying': isPaying,
      'wantsSms': wantsSms,
      'wantsEmailNotifications': wantsEmailNotifications,
      'phoneNumber': phoneNumber,
      'customerType': customerType,
    };
  }

  /// Converts the user object to a Map object
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': customerId,
      'userId': userId,
      'password': password,
      'lastLogin': lastLogin.toString(),
      'username': username,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'dateJoined': dateJoined.toString(),
      'isPaying': isPaying,
      'wantsSms': wantsSms,
      'wantsEmailNotifications': wantsEmailNotifications,
      'phoneNumber': phoneNumber,
      'customerType': customerType,
    };
  }
}
