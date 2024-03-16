part of 'companies_screen_bloc.dart';

abstract class CompaniesScreenState extends BaseState {
  const CompaniesScreenState({Key? key}) : super(key: key);
}

/// The initial state of the Companies screen
class CompaniesScreenInitial extends CompaniesScreenState {}

/// The companies screen is loading
class CompaniesScreenLoading extends CompaniesScreenState {
  const CompaniesScreenLoading({required Key key}) : super(key: key);
}

/// The companies screen has loaded all data
class CompaniesScreenLoaded extends CompaniesScreenState {
  final List<NovaOneListTableItemData> listTableItems;

  CompaniesScreenLoaded(this.listTableItems);

  @override
  List<Object?> get props => super.props + [listTableItems];
}

/// There is no data for the appointments screen to display
class CompaniesScreenEmpty extends CompaniesScreenState {
  const CompaniesScreenEmpty({required Key key}) : super(key: key);
}

/// Error state
class CompaniesScreenError extends BaseStateError
    implements CompaniesScreenState {
  final String error;
  final StackTrace stackTrace;

  const CompaniesScreenError({required this.error, required this.stackTrace})
      : super(error: error, stackTrace: stackTrace);
}
