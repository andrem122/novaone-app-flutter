part of 'address_autocomplete_bloc.dart';

abstract class AddressAutocompleteEvent extends BaseEvent {
  const AddressAutocompleteEvent({Key? key}) : super(key: key);
}

/// The address autocomplete screen's initial event
class AddressAutocompleteStart extends AddressAutocompleteEvent {
  const AddressAutocompleteStart({required Key key}) : super(key: key);
}

/// Some text has been submitted for autocomplete suggestions
class AddressAutocompleteInputSubmitted extends AddressAutocompleteEvent {
  final String input;

  AddressAutocompleteInputSubmitted(this.input);

  @override
  List<Object?> get props => super.props + [input];
}

/// An item has been tapped in the address suggestion list
class AddressAutocompleteItemTapped extends AddressAutocompleteEvent {
  final GooglePlacesPrediction prediction;

  AddressAutocompleteItemTapped(this.prediction);

  @override
  List<Object?> get props => super.props + [prediction];
}
