import 'package:flutter/material.dart';
import 'package:novaone/enums/enums.dart';
import 'package:novaone/models/models.dart';
import 'package:novaone/palette.dart';

class NovaOneDetailTableItemData extends NovaOneTableItemData {
  final String title;
  final int id;
  final String subtitle;
  final String updateTitle;
  final String updateDescription;
  final IconData iconData;
  final Color iconColor;
  final TextInputType keyboardType;
  final String updateFieldHintText;
  final InputWidgetType inputWidget;
  final List<PopupMenuEntry> popupMenuOptions;
  final BaseModel object;

  /// The function that is run when the submit button is pressed for the
  /// update view for this table item
  final Function(String value) onSubmitButtonPressed;

  /// The function to call when a binary button is pressed
  final void Function(String)? onBinaryOptionSelected;

  /// The function that is run when the submit button is pressed for the
  /// update view for this table item
  final Function() onDoneButtonPressed;

  /// The function that is called when a detail table item is tapped/pressed on
  final Function()? onPressed;

  /// The items listed in the checkbox list items screen if the [inputWidgetType] is is ListDays OR ListHours
  final List<Map<String, bool>>? checkboxListItems;

  /// The initial text to show for a text field if desired
  final String? initialText;

  const NovaOneDetailTableItemData(
      {required this.title,
      required this.object,
      this.onPressed,
      required this.id,
      required this.onSubmitButtonPressed,
      required this.onDoneButtonPressed,
      required this.updateTitle,
      required this.inputWidget,
      this.initialText,
      this.checkboxListItems,
      this.keyboardType = TextInputType.text,
      this.updateFieldHintText = 'Update Value',
      required this.updateDescription,
      required this.popupMenuOptions,
      required this.subtitle,
      required this.iconData,
      this.onBinaryOptionSelected,
      this.iconColor = Palette.primaryColor})
      : super(id: id, title: title, subtitle: subtitle, object: object);
}
