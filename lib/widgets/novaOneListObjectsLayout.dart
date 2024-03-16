import 'package:flutter/material.dart';
import 'package:novaone/api/baseApiClient.dart';
import 'package:novaone/models/models.dart';
import 'package:novaone/palette.dart';
import 'package:novaone/responsive/responsive.dart';
import 'package:novaone/widgets/widgets.dart';

class NovaOneListObjectsLayout extends StatelessWidget {
  final List<NovaOneListTableItemData> tableItems;
  final String title;
  final String heroTag;
  final bool showBackButton;
  final BaseApiClient? apiClient;
  final Function()? onFloatingActionButtonPressed;
  final Key floatingActionButtonKey;

  const NovaOneListObjectsLayout(
      {Key? key,
      required this.tableItems,
      required this.title,
      required this.heroTag,
      this.showBackButton = false,
      this.apiClient,
      this.onFloatingActionButtonPressed,
      required this.floatingActionButtonKey})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        key: floatingActionButtonKey,
        heroTag: heroTag,
        onPressed: onFloatingActionButtonPressed,
        child: Icon(Icons.add),
        backgroundColor: Palette.primaryColor,
      ),
      body: ScreenTypeLayout(
        mobile: OrientationLayout(
          portrait: NovaOneListObjectsMobilePortrait(
            tableItems: tableItems,
            title: title,
            showBackButton: showBackButton,
            apiClient: apiClient,
          ),
        ),
      ),
    );
  }
}
