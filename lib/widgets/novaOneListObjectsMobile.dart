import 'package:flutter/material.dart';
import 'package:novaone/api/api.dart';
import 'package:novaone/constants.dart';
import 'package:novaone/enums/enums.dart';
import 'package:novaone/models/models.dart';
import 'package:novaone/palette.dart';
import 'package:novaone/widgets/widgets.dart';

class NovaOneListObjectsMobilePortrait extends StatefulWidget {
  final List<NovaOneListTableItemData> tableItems;
  final String title;
  final BaseApiClient? apiClient;
  final bool showBackButton;

  const NovaOneListObjectsMobilePortrait(
      {Key? key,
      required this.tableItems,
      required this.title,
      this.showBackButton = false,
      this.apiClient})
      : super(key: key);

  @override
  State<NovaOneListObjectsMobilePortrait> createState() =>
      _NovaOneListObjectsMobilePortraitState();
}

class _NovaOneListObjectsMobilePortraitState
    extends State<NovaOneListObjectsMobilePortrait> {
  late List<NovaOneListTableItemData> tableItems;
  late List<NovaOneListTableItemData> searchTableItems;
  final TextEditingController searchController = TextEditingController();

  _initialize() {
    tableItems = widget.tableItems;
    searchTableItems = tableItems;
  }

  @override
  void initState() {
    _initialize();
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _NovaOneListObjectsMobilePortraitHeader(
        onChanged: (String? value) {
          setState(() {
            if (searchController.text.isEmpty) {
              searchTableItems = tableItems;
            } else {
              searchTableItems = tableItems.where(
                (NovaOneListTableItemData tableItem) {
                  return tableItem.title
                          .toLowerCase()
                          .contains(value?.toLowerCase() ?? '') ||
                      tableItem.subtitle
                          .toLowerCase()
                          .contains(value?.toLowerCase() ?? '');
                },
              ).toList();
            }
          });
        },
        showBackButton: widget.showBackButton,
        title: widget.title,
        searchController: searchController,
        onClearSearchText: () => setState(() {
          searchTableItems = tableItems;
        }),
      ),
      Flexible(
        child: Padding(
          padding:
              const EdgeInsets.fromLTRB(defaultPadding, 40, defaultPadding, 5),
          child: NovaOneTable(
            tableItems: searchTableItems,
            tableType: NovaOneTableTypes.ListTable,
            scrollable: true,
            apiClient: widget.apiClient,
          ),
        ),
      ),
    ]);
  }
}

class _NovaOneListObjectsMobilePortraitHeader extends StatelessWidget {
  final String title;
  final bool showBackButton;
  final TextEditingController searchController;

  /// The function that is called when the user changes the text in the search box
  final Function(String? value) onChanged;

  /// The function that is called when the user clears the text in the search box by tapping the clear button
  final Function() onClearSearchText;

  const _NovaOneListObjectsMobilePortraitHeader(
      {Key? key,
      required this.title,
      required this.showBackButton,
      required this.onChanged,
      required this.searchController,
      required this.onClearSearchText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.width > 320 ? size.height * 0.25 : size.height * 0.26,
      child: Stack(
        children: <Widget>[
          GradientHeader(
            containerDecimalHeight: size.width > 320 ? 0.20 : 0.17,
            child: SafeArea(
                child: Center(
                    child: Text(
              title,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.bold),
            ))),
          ),
          showBackButton
              ? Positioned(
                  top: 0,
                  left: 0,
                  child: SafeArea(
                    child: IconButton(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(
                        Icons.arrow_back_sharp,
                        color: Colors.white,
                        size: backButtonSize,
                      ),
                    ),
                  ),
                )
              : SizedBox.shrink(),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: RoundedContainer(
                height: 54,
                boxShadow: [
                  BoxShadow(
                      blurRadius: 50,
                      offset: Offset(0, 10),
                      color: Palette.primaryColor.withOpacity(0.23))
                ],
                child: TextFormField(
                  controller: searchController,
                  autocorrect: true,
                  decoration: InputDecoration(
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    hintText: 'Search',
                    suffixIcon: IconButton(
                        onPressed: () {
                          searchController.clear();
                          onClearSearchText();
                        },
                        icon: Icon(Icons.clear_outlined)),
                  ),
                  onChanged: onChanged,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
