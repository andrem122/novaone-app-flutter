import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:novaone/api/appointmentsApiClient.dart';
import 'package:novaone/auth/auth.dart';
import 'package:novaone/models/models.dart';
import 'package:novaone/novaOneTableHelper.dart';
import 'package:novaone/utils/baseBloc.dart';
part 'appointments_screen_event.dart';
part 'appointments_screen_state.dart';

class AppointmentsScreenBloc
    extends Bloc<AppointmentsScreenEvent, AppointmentsScreenState> {
  AppointmentsScreenBloc(
      {required this.objectStore, required this.appointmentsApiClient})
      : super(AppointmentsScreenInitial()) {
    on<AppointmentsScreenStart>(_start);
    on<AppointmentsScreenLoadedFromNav>(_loadedFromNav);
    on<AppointmentsScreenRefreshTable>(_refresh);
  }

  final ObjectStore objectStore;
  final AppointmentsApiClient appointmentsApiClient;

  /// Gets the locally stored object data
  Future<List<NovaOneListTableItemData>?> _getLocalAppointments() async {
    /// Get locally stored leads
    final List<Appointment> appointments =
        await objectStore.getObjects<Appointment>(orderBy: 'id DESC');

    /// Convert to table items
    return NovaOneTableHelper.instance.convertObjectsToListTableItemData(
      objects: appointments,
    );
  }

  _refresh(AppointmentsScreenRefreshTable event,
      Emitter<AppointmentsScreenState> emit) async {
    if (event.forceRemote == true) {
      emit(AppointmentsScreenLoading(key: UniqueKey()));
      try {
        await appointmentsApiClient.getRecentAppointments();
      } catch (error) {
        print(
            'AppointmentsScreenBloc._refresh: Could not remotely refresh data: $error');
      }
    }

    final listTableItems = await _getLocalAppointments();
    final List<Company> companies = await objectStore.getObjects<Company>();
    if (listTableItems != null) {
      emit(
        AppointmentsScreenLoaded(
            listTableItems: listTableItems, companies: companies),
      );
    } else {
      emit(AppointmentsScreenEmpty(companies));
    }
  }

  _start(AppointmentsScreenStart event,
      Emitter<AppointmentsScreenState> emit) async {
    emit(
      AppointmentsScreenLoading(key: UniqueKey()),
    );
  }

  _loadedFromNav(AppointmentsScreenLoadedFromNav event,
      Emitter<AppointmentsScreenState> emit) async {
    final List<Company> companies = await objectStore.getObjects<Company>();

    if (event.listTableItems.isEmpty) {
      emit(AppointmentsScreenEmpty(companies));
    } else {
      emit(
        AppointmentsScreenLoaded(
            listTableItems: event.listTableItems, companies: companies),
      );
    }
  }
}
