part of 'list_companies_bloc.dart';

abstract class ListCompaniesEvent extends Equatable {
  const ListCompaniesEvent();

  @override
  List<Object> get props => [];
}

class ListCompaniesStart extends ListCompaniesEvent {}
