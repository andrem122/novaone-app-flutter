part of 'input_bloc.dart';

abstract class InputEvent extends Equatable {
  const InputEvent();

  @override
  List<Object> get props => [];
}

/// Data was submitted to update the user's information
class InputUpdateUser extends InputEvent {
  final Map<UpdateObject, dynamic> properties;

  InputUpdateUser({required this.properties});
}

/// Data was submitted to update lead information
class InputUpdateLead extends InputEvent {
  final Lead lead;
  final Map<UpdateObject, dynamic> properties;

  InputUpdateLead({required this.lead, required this.properties});
}

/// Data was submitted to update appointment information
class InputUpdateAppointment extends InputEvent {
  final Appointment appointment;
  final Map<UpdateObject, dynamic> properties;

  InputUpdateAppointment({required this.appointment, required this.properties});
}

/// Data was submitted to update company information
class InputUpdateCompany extends InputEvent {
  final Company company;
  final Map<UpdateObject, dynamic> properties;

  InputUpdateCompany({required this.company, required this.properties});
}

/// The form has been submitted on the support screen
class InputSupportRequestSubmitted extends InputEvent {
  final String message;

  InputSupportRequestSubmitted(this.message);
}
