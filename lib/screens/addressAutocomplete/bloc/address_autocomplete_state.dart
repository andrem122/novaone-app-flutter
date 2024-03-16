part of 'address_autocomplete_bloc.dart';

abstract class AddressAutocompleteState extends BaseState {
  const AddressAutocompleteState({Key? key}) : super(key: key);
}

class AddressAutocompleteInitial extends AddressAutocompleteState {}

/// The address autocomplete screen is loading
class AddressAutocompleteLoading extends AddressAutocompleteState {
  const AddressAutocompleteLoading({required Key key}) : super(key: key);
}

/// We have loaded all predictions from the Google Places API
class AddressAutocompletePredictions extends AddressAutocompleteState {
  final List<GooglePlacesPrediction> predictions;

  AddressAutocompletePredictions(this.predictions);

  @override
  List<Object?> get props => super.props + [predictions];
}

class AddressAutocompletePlaceFetching extends AddressAutocompleteState {
  final Future<GooglePlacesPlace> place;

  AddressAutocompletePlaceFetching(this.place);
  @override
  List<Object?> get props => super.props + [place];
}

// Home page error state
class AddressAutocompleteError extends BaseStateError
    implements AddressAutocompleteState {
  final String error;
  final StackTrace stackTrace;

  const AddressAutocompleteError(
      {required this.error, required this.stackTrace})
      : super(error: error, stackTrace: stackTrace);
}
