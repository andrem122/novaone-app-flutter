import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:novaone/api/api.dart';
import 'package:novaone/models/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({
    required this.futurePrefs,
    required this.chartDataApiClient,
    required this.leadsApiClient,
    required this.appointmentsApiClient,
  }) : super(HomeLoading()) {
    on<HomeStart>(_start);
    on<HomeStartError>(_error);
  }

  final Future<SharedPreferences> futurePrefs;
  final DataApiClient chartDataApiClient;
  final LeadsApiClient leadsApiClient;
  final AppointmentsApiClient appointmentsApiClient;

  _error(HomeStartError event, Emitter<HomeState> emit) {
    /// An error has occurred while fetching data from the nav bloc or somewhere
    /// else where we want to pass data to the home screen bloc
    emit(HomeError(error: event.error, stackTrace: event.stackTrace));
  }

  /// Grabs all data needed to start up the home screen
  _start(HomeStart event, Emitter<HomeState> emit) async {
    // Indicate that the home screen is being loaded
    emit(HomeLoading());

    /// Initialize
    List<ChartMonthlyData> chartMonthlyData = [];
    List<ObjectCount> objectCounts = [];

    // Fetch needed data from API

    try {
      try {
        chartMonthlyData = await chartDataApiClient.getMonthyChartData();
      } catch (error) {
        print(
            'HomeBloc._start: Error occurred while fetching chart data: $error');
      }

      try {
        objectCounts = await chartDataApiClient.getObjectCounts();
      } catch (error) {
        print(
            'HomeBloc._start: Error occurred while fetching object count data: $error');
      }

      emit(
        HomeLoaded(
            chartMonthlyData: chartMonthlyData,
            recentLeads: event.recentLeads,
            recentAppointments: event.recentAppointments,
            companies: event.companies,
            objectCounts: objectCounts),
      );
    } catch (error, stacktrace) {
      emit(HomeError(error: error.toString(), stackTrace: stacktrace));
    }
  }
}
