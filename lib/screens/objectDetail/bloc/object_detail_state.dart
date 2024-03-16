part of 'object_detail_bloc.dart';

abstract class ObjectDetailState extends Equatable {
  const ObjectDetailState();

  @override
  List<Object> get props => [];
}

/// The object detail screen has loaded
class ObjectDetailLoaded extends ObjectDetailState {}

/// An object has been successfully deleted from the object detail screen
class ObjectDetailObjectDeleted extends ObjectDetailState {}

class ObjectDetailError extends ObjectDetailState {
  final String error;
  final StackTrace? stackTrace;

  ObjectDetailError({required this.error, this.stackTrace});
}
