part of 'object_detail_bloc.dart';

abstract class ObjectDetailEvent extends Equatable {
  const ObjectDetailEvent();

  @override
  List<Object> get props => [];
}

/// The lead detail screen's initial event
class ObjectDetailStart extends ObjectDetailEvent {}

/// An object has been selected to be deleted from the detail screen
class ObjectDetailDeleteObject extends ObjectDetailEvent {
  final BaseModel object;

  const ObjectDetailDeleteObject({required this.object});
}
