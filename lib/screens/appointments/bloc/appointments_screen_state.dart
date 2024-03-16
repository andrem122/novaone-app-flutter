part of 'appointments_screen_bloc.dart';

abstract class AppointmentsScreenState extends BaseState {
  const AppointmentsScreenState({Key? key}) : super(key: key);
}

/// The initial state of the appointments screen
class AppointmentsScreenInitial extends AppointmentsScreenState {}

/// The appointments screen is loading
class AppointmentsScreenLoading extends AppointmentsScreenState {
  const AppointmentsScreenLoading({required Key key}) : super(key: key);
}

/// The appointments screen has loaded all data
class AppointmentsScreenLoaded extends AppointmentsScreenState {
  final List<Company> companies;
  final List<NovaOneListTableItemData> listTableItems;

  AppointmentsScreenLoaded(
      {required this.listTableItems, required this.companies});

  @override
  List<Object?> get props => super.props + [listTableItems, companies];
}

/// There is no data for the appointments screen to display
class AppointmentsScreenEmpty extends AppointmentsScreenState {
  final List<Company> companies;

  AppointmentsScreenEmpty(this.companies);
  @override
  List<Object?> get props => super.props + [companies];
}

// Error state
class AppointmentsScreenError extends BaseStateError
    implements AppointmentsScreenState {
  final String error;
  final StackTrace? stackTrace;

  AppointmentsScreenError({required this.error, this.stackTrace})
      : super(error: error, stackTrace: stackTrace);
}
