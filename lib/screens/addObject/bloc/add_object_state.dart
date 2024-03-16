part of 'add_object_bloc.dart';

abstract class AddObjectState extends BaseState {
  const AddObjectState({Key? key}) : super(key: key);
}

class AddObjectLoaded extends AddObjectState {
  const AddObjectLoaded({required Key key}) : super(key: key);
}

class AddObjectEmpty extends AddObjectState {
  const AddObjectEmpty({required Key key}) : super(key: key);
}

/// An error has occurred while trying to add the appointment to the server database
class AddObjectAppointmentError extends AddObjectState {
  final ApiMessageException error;

  AddObjectAppointmentError(this.error);

  @override
  List<Object?> get props => super.props + [error];
}

class AddObjectLoading extends AddObjectState {
  const AddObjectLoading({required Key key}) : super(key: key);
}

/// The lead has been successfully created both on the server and locally
class AddObjectCreated extends AddObjectState {
  final BaseModel object;

  AddObjectCreated(this.object);
  @override
  List<Object?> get props => super.props + [object];
}

// Home page error state
class AddObjectError extends BaseStateError implements AddObjectState {
  final String error;
  final StackTrace stackTrace;

  const AddObjectError({required this.error, required this.stackTrace})
      : super(error: error, stackTrace: stackTrace);
}
