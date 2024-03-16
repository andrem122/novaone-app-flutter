import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:novaone/constants.dart';
import 'package:novaone/models/googlePlacesPlace.dart';
import 'package:novaone/models/googlePlacesPredictions.dart';
import 'package:novaone/palette.dart';
import 'package:novaone/screens/addressAutocomplete/bloc/address_autocomplete_bloc.dart';
import 'package:novaone/utils/utils.dart';
import 'package:novaone/widgets/widgets.dart';

class AddressAutocompleteMobilePortrait extends StatelessWidget {
  /// The validator for the text form field input
  final String? Function(String?) validator;
  const AddressAutocompleteMobilePortrait(
      {Key? key,
      required this.validator,
      required this.controller,
      required this.onAddressItemTap,
      this.autofocus})
      : super(key: key);

  final TextEditingController controller;
  final bool? autofocus;

  /// The function that is called when an item is tapped on in the
  /// suggestion list. A place will be fetched as a result so Future<GooglePlacesPlace> is returned
  final Function(Future<GooglePlacesPlace> place) onAddressItemTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Form(
            child: TextFormField(
          autofocus: autofocus ?? false,
          validator: validator,
          onChanged: (String text) {
            BlocProvider.of<AddressAutocompleteBloc>(context)
                .add(AddressAutocompleteInputSubmitted(text));
          },
          controller: controller,
          decoration: InputDecoration(
            border: textFormFieldBorderStyle,
            hintText: "Type address here...",
            focusColor: Colors.white,
            floatingLabelBehavior: FloatingLabelBehavior.never,
            prefixIcon: Icon(Icons.search),
            suffixIcon: IconButton(
              icon: Icon(Icons.clear),
              onPressed: () {
                controller.clear();
              },
            ),
          ),
        )),
        const SizedBox(
          height: appVerticalSpacing,
        ),
        BlocConsumer<AddressAutocompleteBloc, AddressAutocompleteState>(
          listener: (BuildContext context, AddressAutocompleteState state) {
            if (state is AddressAutocompletePlaceFetching) {
              onAddressItemTap(state.place);
            }
          },
          builder: (BuildContext context, AddressAutocompleteState state) {
            if (state is AddressAutocompleteLoading) {
              return _buildLoading(context: context);
            }

            /// If we have predictions for the address typed
            if (state is AddressAutocompletePredictions &&
                state.predictions.isNotEmpty) {
              return _buildSuggestionList(state.predictions);
            }

            if (state is AddressAutocompleteError) {
              return _buildError(context: context);
            }

            return SizedBox.shrink();
          },
        ),
      ],
    );
  }

  /// Builds the list of Google Places suggestions
  Widget _buildSuggestionList(List<GooglePlacesPrediction> predictions) {
    return RoundedContainer(
      child: ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              onTap: () {
                controller.text = predictions[index].description;

                /// Let the bloc know an item has been tapped and to fetch place details
                BlocProvider.of<AddressAutocompleteBloc>(context)
                    .add(AddressAutocompleteItemTapped(predictions[index]));

                /// Dismiss the keyboard
                UIUtils.instance.dismissKeyboard(context);
              },
              leading: Icon(Icons.place),
              title: Text(predictions[index].description),
            );
          },
          separatorBuilder: (BuildContext context, int index) => Divider(),
          itemCount: predictions.length),
    );
  }

  Widget _buildLoading({required BuildContext context}) {
    return Center(
      child: CircularProgressIndicator(
        color: Palette.primaryColor,
      ),
    );
  }

  Widget _buildError({required BuildContext context}) {
    return ErrorDisplay(
      onPressed: () {},
    );
  }
}
