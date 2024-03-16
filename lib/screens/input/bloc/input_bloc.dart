import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:novaone/api/api.dart';
import 'package:novaone/enums/enums.dart';
import 'package:novaone/models/models.dart';
part 'input_event.dart';
part 'input_state.dart';

class InputBloc extends Bloc<InputEvent, InputState> {
  InputBloc({
    required this.userApiClient,
    required this.leadsApiClient,
    required this.appointmentsApiClient,
    required this.companiesApiClient,
  }) : super(InputInitial()) {
    on<InputUpdateLead>(_updateLead);
    on<InputUpdateAppointment>(_updateAppointment);
    on<InputUpdateCompany>(_updateCompany);
    on<InputSupportRequestSubmitted>(_handleSupportRequest);
    on<InputUpdateUser>(_updateUser);
  }

  final UserApiClient userApiClient;
  final LeadsApiClient leadsApiClient;
  final CompaniesApiClient companiesApiClient;
  final AppointmentsApiClient appointmentsApiClient;

  /// Update the properties of the user both on the server and local database
  _updateUser(InputUpdateUser event, Emitter<InputState> emit) async {
    try {
      await userApiClient.updateUser(properties: event.properties);
      emit(InputSubmitCompleted());
    } catch (error, stackTrace) {
      print(stackTrace);
      emit(InputError(error: error.toString(), stackTrace: stackTrace));
    }
  }

  /// Handle the request for support
  _handleSupportRequest(
      InputSupportRequestSubmitted event, Emitter<InputState> emit) async {
    try {
      await userApiClient.sendSupportRequest(event.message);
      emit(InputSubmitCompleted());
    } catch (error, stackTrace) {
      print(stackTrace);
      emit(InputError(error: error.toString(), stackTrace: stackTrace));
    }
  }

  _updateLead(InputUpdateLead event, Emitter<InputState> emit) async {
    try {
      await leadsApiClient.update(
          lead: event.lead, properties: event.properties);
      emit(InputSubmitCompleted());
    } catch (error, stackTrace) {
      emit(InputError(error: error.toString(), stackTrace: stackTrace));
    }
  }

  _updateCompany(InputUpdateCompany event, Emitter<InputState> emit) async {
    try {
      await companiesApiClient.update(
          company: event.company, properties: event.properties);
      emit(InputSubmitCompleted());
    } catch (error, stackTrace) {
      emit(InputError(error: error.toString(), stackTrace: stackTrace));
    }
  }

  _updateAppointment(
      InputUpdateAppointment event, Emitter<InputState> emit) async {
    try {
      await appointmentsApiClient.update(
          appointment: event.appointment, properties: event.properties);
      emit(InputSubmitCompleted());
    } catch (error, stackTrace) {
      emit(InputError(error: error.toString(), stackTrace: stackTrace));
    }
  }
}
