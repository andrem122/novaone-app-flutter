part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

/// User logs in and is taken to the home page
///
/// The data for HomeStart comes from the nav screen bloc
class HomeStart extends HomeEvent {
  final List<Lead> recentLeads;
  final List<Appointment> recentAppointments;
  final List<Company> companies;

  HomeStart({
    required this.recentAppointments,
    required this.recentLeads,
    required this.companies,
  });
}

/// A error has occurred on the nav screen while fetching data
class HomeStartError extends HomeEvent {
  final String error;
  final StackTrace stackTrace;

  HomeStartError({required this.error, required this.stackTrace});
}

/// An info card on the home page is tapped
class HomeInfoCardTapped extends HomeState {}
