part of 'leads_screen_bloc.dart';

abstract class LeadsScreenState extends Equatable {
  const LeadsScreenState();

  @override
  List<Object> get props => [];
}

/// The initial state of the leads scree
class LeadsScreenInitial extends LeadsScreenState {
  @override
  List<Object> get props => super.props;
}

/// The leads screen is loading
class LeadsScreenLoading extends LeadsScreenState {
  @override
  List<Object> get props => super.props;
}

/// The leads screen has loaded all data
class LeadsScreenLoaded extends LeadsScreenState {
  final List<NovaOneListTableItemData> listTableItems;

  /// The list of companies that will be used in the dropdown of the add lead screen
  final List<Company> companies;

  LeadsScreenLoaded({required this.listTableItems, required this.companies});

  /// IMPORTANT: You must include the [props] property here because when a state is yielded from the bloc,
  /// Flutter Bloc compares the previous state to the new state to see if they are different using the
  /// equatable class. If they are different, then the new state is emitted to the BlocBuilder/BlocConsumer. If the states
  /// are not different, then no state will be output to the BlocBuilder/BlocConsumer.
  @override
  List<Object> get props => super.props + [listTableItems, companies];
}

/// There is no data for the leads screen to display
class LeadsScreenNoData extends LeadsScreenState {
  final List<Company> companies;

  const LeadsScreenNoData(this.companies);

  @override
  List<Object> get props => super.props + [companies];
}

// Error state
class LeadsScreenError extends LeadsScreenState {
  final String error;
  final StackTrace stackTrace;

  LeadsScreenError({required this.error, required this.stackTrace});

  @override
  List<Object> get props => super.props + [error, stackTrace];
}
