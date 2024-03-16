part of 'list_companies_bloc.dart';

abstract class ListCompaniesState extends Equatable {
  const ListCompaniesState();

  @override
  List<Object> get props => [];
}

class ListCompaniesLoaded extends ListCompaniesState {
  final List<NovaOneListTableItemData> tableItems;

  ListCompaniesLoaded(this.tableItems);
}
