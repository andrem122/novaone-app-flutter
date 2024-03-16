part of 'leads_screen_bloc.dart';

abstract class LeadsScreenEvent extends Equatable {
  const LeadsScreenEvent();

  @override
  List<Object> get props => [];
}

/// The leads screen has started loading
class LeadsScreenStart extends LeadsScreenEvent {
  @override
  List<Object> get props => super.props + [];
}

/// The leads screen has had all of its initial data loaded from the nav screen.
/// The data is then passed to the leads screen.
class LeadsScreenLoadedFromNav extends LeadsScreenEvent {
  final List<NovaOneListTableItemData> listTableItems;

  LeadsScreenLoadedFromNav({required this.listTableItems});

  @override
  List<Object> get props => super.props + [listTableItems];
}

/// Refresh the items in the table
class LeadsScreenRefreshTable extends LeadsScreenEvent {
  final Key key;

  /// A boolean to indicate whether or not we want to make a remote call for data from the server
  final bool forceRemote;

  LeadsScreenRefreshTable({required this.key, this.forceRemote = false});

  @override
  List<Object> get props => super.props + [key];
}
