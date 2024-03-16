part of 'input_bloc.dart';

abstract class InputState extends Equatable {
  const InputState();

  @override
  List<Object> get props => [];
}

class InputInitial extends InputState {}

/// The input screen is loading
class InputLoading extends InputState {}

/// The submission of data on the input screen has been completed for the settings creen
class InputSubmitCompleted extends InputState {
  InputSubmitCompleted();
}

// Input page error state
class InputError extends InputState {
  final String error;
  final StackTrace stackTrace;

  InputError({required this.error, required this.stackTrace});

  @override
  List<Object> get props => super.props + [error, stackTrace];
}
