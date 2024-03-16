part of 'companies_screen_bloc.dart';

abstract class CompaniesScreenEvent extends BaseEvent {
  const CompaniesScreenEvent({Key? key}) : super(key: key);
}

/// The appointments screen has started loading
class CompaniesScreenStart extends CompaniesScreenEvent {
  const CompaniesScreenStart({required Key key}) : super(key: key);
}

/// The companies screen has had all of its initial data loaded from the nav screen.
/// The data is then passed to the companies screen.
class CompaniesScreenLoadedFromNav extends CompaniesScreenEvent {
  final List<NovaOneListTableItemData> listTableItems;

  CompaniesScreenLoadedFromNav({required this.listTableItems});

  @override
  List<Object?> get props => super.props + [listTableItems];
}

/// Refresh the items in the table
class CompaniesScreenRefreshTable extends CompaniesScreenEvent {
  /// A boolean to indicate whether or not we want to make a remote call for data from the server
  final bool forceRemote;

  CompaniesScreenRefreshTable({required Key key, this.forceRemote = false});
  @override
  List<Object?> get props => super.props + [forceRemote];
}
