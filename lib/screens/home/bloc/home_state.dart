part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

// Home page loading state
class HomeLoading extends HomeState {
  @override
  List<Object> get props => super.props + [];
}

// Home page loaded state
class HomeLoaded extends HomeState {
  final List<ChartMonthlyData> chartMonthlyData;
  final List<Lead> recentLeads;
  final List<Appointment> recentAppointments;
  final List<Company> companies;
  final List<ObjectCount> objectCounts;

  HomeLoaded({
    required this.chartMonthlyData,
    required this.recentLeads,
    required this.recentAppointments,
    required this.companies,
    required this.objectCounts,
  });

  @override
  List<Object> get props =>
      super.props +
      [
        chartMonthlyData,
        recentLeads,
        recentAppointments,
        companies,
        objectCounts
      ];
}

// Home page error state
class HomeError extends HomeState {
  final String error;
  final StackTrace stackTrace;

  HomeError({required this.error, required this.stackTrace});

  @override
  List<Object> get props => super.props + [error, stackTrace];
}
