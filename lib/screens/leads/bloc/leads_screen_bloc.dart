import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:novaone/api/leadsApiClient.dart';
import 'package:novaone/auth/auth.dart';
import 'package:novaone/models/models.dart';
import 'package:novaone/novaOneTableHelper.dart';

part 'leads_screen_event.dart';
part 'leads_screen_state.dart';

class LeadsScreenBloc extends Bloc<LeadsScreenEvent, LeadsScreenState> {
  LeadsScreenBloc({
    required this.objectStore,
    required this.leadsApiClient,
  }) : super(LeadsScreenInitial()) {
    on<LeadsScreenLoadedFromNav>(_loadedFromNav);
    on<LeadsScreenRefreshTable>(_refresh);
    on<LeadsScreenStart>(_start);
  }

  final ObjectStore objectStore;
  final LeadsApiClient leadsApiClient;

  /// Gets the locally stored object data
  Future<List<NovaOneListTableItemData>?> _getLocalLeads() async {
    /// Get locally stored leads
    final List<Lead> leads =
        await objectStore.getObjects<Lead>(orderBy: 'id DESC');

    /// Convert to table items
    return NovaOneTableHelper.instance
        .convertObjectsToListTableItemData(objects: leads);
  }

  _start(LeadsScreenStart event, Emitter<LeadsScreenState> emit) {
    emit(LeadsScreenLoading());
  }

  _refresh(
      LeadsScreenRefreshTable event, Emitter<LeadsScreenState> emit) async {
    if (event.forceRemote == true) {
      emit(LeadsScreenLoading());
      try {
        await leadsApiClient.getRecentLeads();
      } catch (error) {
        print(
            'LeadsScreenBloc._refresh: Could not remotely refresh data: $error');
      }
    }

    final listTableItems = await _getLocalLeads();
    final List<Company> companies = await objectStore.getObjects<Company>();
    if (listTableItems != null) {
      emit(LeadsScreenLoaded(
          listTableItems: listTableItems, companies: companies));
    } else {
      emit(LeadsScreenNoData(companies));
    }
  }

  _loadedFromNav(
      LeadsScreenLoadedFromNav event, Emitter<LeadsScreenState> emit) async {
    final List<Company> companies = await objectStore.getObjects<Company>();

    if (event.listTableItems.isEmpty) {
      emit(LeadsScreenNoData(companies));
    } else {
      emit(
        LeadsScreenLoaded(
            listTableItems: event.listTableItems, companies: companies),
      );
    }
  }
}
