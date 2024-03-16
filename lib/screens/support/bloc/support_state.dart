part of 'support_bloc.dart';

abstract class SupportState extends Equatable {
  const SupportState();

  @override
  List<Object> get props => [];
}

class SupportInitial extends SupportState {}

class SupportError extends SupportState {
  final String error;
  final StackTrace stackTrace;

  SupportError({required this.error, required this.stackTrace});

  @override
  List<Object> get props => super.props + [error, stackTrace];
}
