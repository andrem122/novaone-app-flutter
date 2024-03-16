import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:novaone/api/companiesApiClient.dart';
import 'package:novaone/auth/auth.dart';
import 'package:novaone/models/models.dart';
import 'package:novaone/novaOneTableHelper.dart';
import 'package:novaone/utils/baseBloc.dart';

part 'companies_screen_event.dart';
part 'companies_screen_state.dart';

class CompaniesScreenBloc
    extends Bloc<CompaniesScreenEvent, CompaniesScreenState> {
  CompaniesScreenBloc(
      {required this.objectStore, required this.companiesApiClient})
      : super(CompaniesScreenInitial()) {
    on<CompaniesScreenStart>(_start);
    on<CompaniesScreenLoadedFromNav>(_loadedFromNav);
    on<CompaniesScreenRefreshTable>(_refresh);
  }

  final ObjectStore objectStore;
  final CompaniesApiClient companiesApiClient;

  _start(CompaniesScreenStart event, Emitter<CompaniesScreenState> emit) async {
    emit(CompaniesScreenLoading(key: UniqueKey()));
  }

  /// Gets the locally stored object data
  Future<List<NovaOneListTableItemData>?> _getLocalCompanies() async {
    /// Get locally stored leads
    final List<Company> companies =
        await objectStore.getObjects<Company>(orderBy: 'id DESC');

    /// Convert to table items
    return NovaOneTableHelper.instance.convertObjectsToListTableItemData(
      objects: companies,
    );
  }

  _refresh(CompaniesScreenRefreshTable event,
      Emitter<CompaniesScreenState> emit) async {
    if (event.forceRemote == true) {
      emit(CompaniesScreenLoading(key: UniqueKey()));
      try {
        await companiesApiClient.getRecentCompanies();
      } catch (error) {
        print(
            'CompaniesScreenBloc._refresh: Could not remotely refresh data: $error');
      }
    }

    final listTableItems = await _getLocalCompanies();
    if (listTableItems != null) {
      emit(CompaniesScreenLoaded(listTableItems));
    }
  }

  _loadedFromNav(
      CompaniesScreenLoadedFromNav event, Emitter<CompaniesScreenState> emit) {
    emit(CompaniesScreenLoaded(event.listTableItems));
  }
}
