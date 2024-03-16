part of 'support_bloc.dart';

abstract class SupportEvent extends Equatable {
  const SupportEvent();

  @override
  List<Object> get props => [];
}

/// The submit form has been submitted
class SupportFormSubmitted extends SupportEvent {
  final String message;

  SupportFormSubmitted(this.message);
}
