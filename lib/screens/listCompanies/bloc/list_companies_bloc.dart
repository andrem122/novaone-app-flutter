import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:novaone/auth/auth.dart';
import 'package:novaone/models/models.dart';
import 'package:novaone/widgets/widgets.dart';

part 'list_companies_event.dart';
part 'list_companies_state.dart';

class ListCompaniesBloc extends Bloc<ListCompaniesEvent, ListCompaniesState> {
  final ObjectStore objectStore;

  ListCompaniesBloc(this.objectStore) : super(ListCompaniesLoaded([])) {
    on<ListCompaniesStart>(_start);
  }

  _start(ListCompaniesStart event, Emitter<ListCompaniesState> emit) async {
    final List<NovaOneListTableItemData> tableItems =
        await _generateListTableItems();
    emit(ListCompaniesLoaded(tableItems));
  }

  /// Gets companies from local storage and converts them to list table items
  Future<List<NovaOneListTableItemData>> _generateListTableItems() async {
    final List<Company> companies = await objectStore.getObjects<Company>();
    return companies
        .map((Company company) => NovaOneListTableItemData(
            id: company.id,
            object: company,
            popupMenuOptions: [],
            subtitle: DateFormat(NovaOneTable.defaultDateFormat)
                .format(company.created),
            title: company.name))
        .toList();
  }
}
