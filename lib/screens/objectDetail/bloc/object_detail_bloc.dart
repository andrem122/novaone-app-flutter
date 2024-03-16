import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:novaone/api/api.dart';
import 'package:novaone/models/models.dart';
import 'package:novaone/screens/appointments/bloc/appointments_screen_bloc.dart';
import 'package:novaone/screens/companies/bloc/companies_screen_bloc.dart';
import 'package:novaone/screens/leads/bloc/leads_screen_bloc.dart';
part 'object_detail_event.dart';
part 'object_detail_state.dart';

class ObjectDetailBloc extends Bloc<ObjectDetailEvent, ObjectDetailState> {
  ObjectDetailBloc({
    required this.leadsApiClient,
    required this.appointmentsApiClient,
    required this.companiesApiClient,
    required this.leadsScreenBloc,
    required this.appointmentsScreenBloc,
    required this.companiesScreenBloc,
  }) : super(ObjectDetailLoaded()) {
    on<ObjectDetailStart>(_start);
    on<ObjectDetailDeleteObject>(_deleteObject);
  }

  final LeadsApiClient leadsApiClient;
  final AppointmentsApiClient appointmentsApiClient;
  final CompaniesApiClient companiesApiClient;
  final LeadsScreenBloc leadsScreenBloc;
  final AppointmentsScreenBloc appointmentsScreenBloc;
  final CompaniesScreenBloc companiesScreenBloc;

  /// Determines the subclass of a [BaseModel] object and deletes it
  _deleteObject(
      ObjectDetailDeleteObject event, Emitter<ObjectDetailState> emit) async {
    final BaseModel object = event.object;
    switch (object.runtimeType) {
      case Lead:
        final lead = event.object as Lead;
        await leadsApiClient.delete(lead);

        leadsScreenBloc.add(
          LeadsScreenRefreshTable(
            key: UniqueKey(),
          ),
        );

        emit(ObjectDetailObjectDeleted());
        break;
      case Appointment:
        final appointment = event.object as Appointment;
        await appointmentsApiClient.delete(appointment);

        appointmentsScreenBloc
            .add(AppointmentsScreenRefreshTable(key: UniqueKey()));

        emit(ObjectDetailObjectDeleted());
        break;
      case Company:

        /// TODO: Get count of companies before deleteing. If the count is one, then emit error message

        final company = event.object as Company;
        await companiesApiClient.delete(company);

        companiesScreenBloc.add(CompaniesScreenRefreshTable(key: UniqueKey()));

        emit(ObjectDetailObjectDeleted());
        break;
      default:
        emit(ObjectDetailError(
            error: 'Could not determine object type when deleteing.'));
    }
  }

  /// The function that handles the startup of the object detail screen
  _start(ObjectDetailStart event, Emitter<ObjectDetailState> emit) {
    try {
      emit(ObjectDetailLoaded());
    } catch (error, stackTrace) {
      emit(ObjectDetailError(
        error: error.toString(),
        stackTrace: stackTrace,
      ));
    }
  }
}
