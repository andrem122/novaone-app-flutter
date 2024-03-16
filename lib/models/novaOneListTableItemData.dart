import 'package:flutter/material.dart';
import 'package:novaone/models/models.dart';
import 'package:novaone/palette.dart';

/// The model used for the data in the NovaOneListTableItem Widget
class NovaOneListTableItemData extends NovaOneTableItemData {
  /// The id of the object associated with the table item
  final int id;

  /// The title above the subtitle
  final String title;

  /// The subtitle below the main title
  final String subtitle;

  /// The color of the avatar circle
  final Color color;
  final List<PopupMenuEntry> popupMenuOptions;
  final BaseModel object;

  NovaOneListTableItemData({
    required this.title,
    required this.id,
    required this.object,
    this.color = Palette.primaryColor,
    required this.popupMenuOptions,
    required this.subtitle,
  }) : super(id: id, title: title, subtitle: subtitle, object: object);

  @override
  List<Object> get props => [title, subtitle, color, popupMenuOptions];
}
