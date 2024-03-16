part of 'add_object_bloc.dart';

abstract class AddObjectEvent extends BaseEvent {
  const AddObjectEvent({Key? key}) : super(key: key);
}

class AddObjectStart extends AddObjectEvent {
  const AddObjectStart({required Key key}) : super(key: key);
}

/// All object info has been submitted
class AddObjectInformationSubmitted extends AddObjectEvent {
  final BaseModel object;

  AddObjectInformationSubmitted(this.object);

  @override
  List<Object?> get props => super.props + [object];
}
