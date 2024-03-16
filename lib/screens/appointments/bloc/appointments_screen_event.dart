part of 'appointments_screen_bloc.dart';

abstract class AppointmentsScreenEvent extends BaseEvent {
  const AppointmentsScreenEvent({Key? key}) : super(key: key);
}

/// The appointments screen has started loading
class AppointmentsScreenStart extends AppointmentsScreenEvent {
  const AppointmentsScreenStart({required Key key}) : super(key: key);
}

/// The appointments screen has had all of its initial data loaded from the nav screen.
/// The data is then passed to the appointments screen.
class AppointmentsScreenLoadedFromNav extends AppointmentsScreenEvent {
  final List<NovaOneListTableItemData> listTableItems;

  const AppointmentsScreenLoadedFromNav({required this.listTableItems});

  @override
  List<Object?> get props => super.props + [listTableItems];
}

/// Refresh the items in the table
class AppointmentsScreenRefreshTable extends AppointmentsScreenEvent {
  /// A boolean to indicate whether or not we want to make a remote call for data from the server
  final bool forceRemote;

  const AppointmentsScreenRefreshTable(
      {required Key key, this.forceRemote = false})
      : super(key: key);

  @override
  List<Object?> get props => super.props + [forceRemote];
}
