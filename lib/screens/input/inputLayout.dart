import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:novaone/enums/enums.dart';
import 'package:novaone/responsive/responsive.dart';
import 'package:novaone/screens/input/bloc/input_bloc.dart';
import 'package:novaone/utils/utils.dart';
import 'package:novaone/widgets/widgets.dart';
import '../screens.dart';

class InputLayout extends StatelessWidget {
  /// The title to show on the input screen
  final String title;

  /// The description to show on the input screen
  final String description;

  /// The hint text to show for the input on the input screen
  final String hintText;

  /// The type of input we want to display
  final InputWidgetType inputWidgetType;

  /// The optional back icon to show in the top left header when navigating back
  final IconData backIcon;

  /// The title to show on thee success screen after the submit button has been pressed
  final String? successTitle;

  /// The title to show on thee success screen after the submit button has been pressed
  final String? successSubtitle;

  /// The function to call when the submit button is pressed
  final void Function(String) onSubmitButtonPressed;

  /// The function to call when the done button is pressed on the success screen
  final void Function() onDoneButtonPressed;

  /// Extra inputs after the main input
  final List<InputWidget>? extraInputs;

  /// The function to call when a binary button is pressed
  final void Function(String)? onBinaryOptionSelected;

  /// The text that goes in the submit button
  final String submitButtonTitle;

  /// The items listed in the checkbox list items screen if the [inputWidgetType] is is ListDays OR ListHours
  final List<Map<String, bool>>? checkboxListItems;

  /// The initial text to show for a text field if desired
  final String? initialText;

  const InputLayout({
    Key? key,
    required this.title,
    required this.description,
    required this.hintText,
    required this.inputWidgetType,
    this.backIcon = Icons.arrow_back_sharp,
    required this.onSubmitButtonPressed,
    required this.onDoneButtonPressed,
    this.successTitle,
    this.successSubtitle,
    this.extraInputs,
    required this.submitButtonTitle,
    this.onBinaryOptionSelected,
    this.checkboxListItems,
    this.initialText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BlocBuilder<InputBloc, InputState>(
        builder: (BuildContext context, InputState state) {
          return _buildLoaded(context: context);
        },
      ),
    );
  }

  Widget _buildLoaded({required BuildContext context}) {
    return ScreenTypeLayout(
        mobile: OrientationLayout(
      portrait: InputMobilePortrait(
        inputWidgetType: inputWidgetType,
        checkboxListItems: checkboxListItems,
        description: description,
        extraInputs: extraInputs,
        title: title,
        hintText: hintText,
        initialText: initialText,
        backIcon: backIcon,
        onSubmitButtonPressed: (String value) {
          /// Remove the keyboard from view
          onSubmitButtonPressed(value);
          UIUtils.instance.pushSuccessScreen(
              context: context,
              onDoneButtonPressed: onDoneButtonPressed,
              successTitle: successTitle,
              successSubtitle: successSubtitle);
        },
        onBinaryOptionSelected: (String value) {
          if (onBinaryOptionSelected != null) {
            onBinaryOptionSelected!(value);
            UIUtils.instance.pushSuccessScreen(
                context: context,
                onDoneButtonPressed: onDoneButtonPressed,
                successTitle: successTitle,
                successSubtitle: successSubtitle);
          }
        },
        submitButtonTitle: submitButtonTitle,
      ),
    ));
  }
}
