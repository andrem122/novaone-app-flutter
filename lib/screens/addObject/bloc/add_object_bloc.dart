import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:novaone/api/apiMessageException.dart';
import 'package:novaone/api/appointmentsApiClient.dart';
import 'package:novaone/api/companiesApiClient.dart';
import 'package:novaone/api/leadsApiClient.dart';
import 'package:novaone/models/models.dart';
import 'package:novaone/utils/utils.dart';

part 'add_object_event.dart';
part 'add_object_state.dart';

class AddObjectBloc extends Bloc<AddObjectEvent, AddObjectState> {
  AddObjectBloc({
    required this.leadsApiClient,
    required this.appointmentsApiClient,
    required this.companiesApiClient,
  }) : super(
          AddObjectLoaded(
            key: UniqueKey(),
          ),
        ) {
    on<AddObjectInformationSubmitted>(_handleSubmission);
    on<AddObjectStart>(_start);
  }

  final LeadsApiClient leadsApiClient;
  final AppointmentsApiClient appointmentsApiClient;
  final CompaniesApiClient companiesApiClient;

  /// Object info has been submitted
  FutureOr<void> _handleSubmission(
      AddObjectInformationSubmitted event, Emitter<AddObjectState> emit) async {
    try {
      switch (event.object.runtimeType) {
        case Lead:
          final lead = event.object as Lead;
          leadsApiClient.add(lead);
          emit(AddObjectCreated(lead));
          break;
        case Appointment:
          emit(
            AddObjectLoading(
              key: UniqueKey(),
            ),
          );
          final appointment = event.object as Appointment;
          final response =
              await Future.delayed(Duration(milliseconds: 300), () async {
            return await appointmentsApiClient.add(appointment);
          });
          if (response is ApiMessageException) {
            /// If there is an error from the server about why an appointment cannot be made, handle it
            emit(AddObjectAppointmentError(response));
          } else {
            emit(AddObjectCreated(appointment));
          }
          break;
        case Company:
          final company = event.object as Company;
          companiesApiClient.add(company);
          emit(AddObjectCreated(company));
          break;
        default:
      }
    } catch (error, stackTrace) {
      emit(AddObjectError(error: error.toString(), stackTrace: stackTrace));
    }
  }

  FutureOr<void> _start(AddObjectStart event, Emitter<AddObjectState> emit) {
    emit(
      AddObjectLoaded(
        key: UniqueKey(),
      ),
    );
  }
}
