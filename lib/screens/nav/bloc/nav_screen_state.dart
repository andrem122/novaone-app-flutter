part of 'nav_screen_bloc.dart';

abstract class NavScreenState extends Equatable {
  const NavScreenState();

  @override
  List<Object> get props => [];
}

class NavScreenInitial extends NavScreenState {}

/// The nav screen has loaded all data necessary to display
class NavScreenLoaded extends NavScreenState {
  final List<Company> companies;

  const NavScreenLoaded(this.companies);

  @override
  List<Object> get props => super.props + [companies];
}

class NavScreenError extends NavScreenState {
  final String error;
  final StackTrace stackTrace;

  NavScreenError({required this.error, required this.stackTrace});

  @override
  List<Object> get props => super.props + [error, stackTrace];
}

/// Change the index so that the tab bar view can change
class NavScreenChangeTabView extends NavScreenState {
  final int selectedIndex;

  NavScreenChangeTabView({required this.selectedIndex});

  @override
  List<Object> get props => super.props + [selectedIndex];
}
