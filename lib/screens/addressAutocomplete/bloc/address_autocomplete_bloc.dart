import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:novaone/api/googlePlacesApiClient.dart';
import 'package:novaone/models/googlePlacesPlace.dart';
import 'package:novaone/models/googlePlacesPredictions.dart';
import 'package:novaone/utils/baseBloc.dart';

part 'address_autocomplete_event.dart';
part 'address_autocomplete_state.dart';

class AddressAutocompleteBloc
    extends Bloc<AddressAutocompleteEvent, AddressAutocompleteState> {
  AddressAutocompleteBloc(this.googlePlacesApiClient)
      : super(AddressAutocompleteInitial()) {
    on<AddressAutocompleteInputSubmitted>(_handleSubmission);
    on<AddressAutocompleteItemTapped>(_handleTap);
    on<AddressAutocompleteStart>(_start);
  }

  final GooglePlacesApiClient googlePlacesApiClient;

  /// Handles the submission of input text for address predictions/autocompletion
  _handleSubmission(AddressAutocompleteInputSubmitted event,
      Emitter<AddressAutocompleteState> emit) async {
    /// Show the loading screen by emitting the loading state
    emit(AddressAutocompleteLoading(key: UniqueKey()));

    /// Get the predictions from the Google Places API client
    try {
      final List<GooglePlacesPrediction> predictions =
          await Future.delayed(Duration(milliseconds: 300), () async {
        return await googlePlacesApiClient.getSuggestions(event.input);
      });

      /// Emit the state with predictions
      emit(AddressAutocompletePredictions(predictions));
    } catch (error, stackTrace) {
      emit(AddressAutocompleteError(
          error: error.toString(), stackTrace: stackTrace));
    }
  }

  _handleTap(AddressAutocompleteItemTapped event,
      Emitter<AddressAutocompleteState> emit) async {
    try {
      final place =
          googlePlacesApiClient.getPlaceDetails(event.prediction.placeId);
      emit(AddressAutocompletePlaceFetching(place));
    } catch (error, stackTrace) {
      emit(AddressAutocompleteError(
          error: error.toString(), stackTrace: stackTrace));
    }
  }

  _start(
      AddressAutocompleteStart event, Emitter<AddressAutocompleteState> emit) {
    emit(AddressAutocompletePredictions([]));
  }
}
