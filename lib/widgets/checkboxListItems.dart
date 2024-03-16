import 'package:flutter/material.dart';
import 'package:novaone/widgets/widgets.dart';

class CheckboxListItems extends StatefulWidget {
  const CheckboxListItems(
      {Key? key, required this.items, required this.onCheckboxTap})
      : super(key: key);

  /// The list of strings that will be shown on the screen
  final List<Map<String, bool>> items;

  /// The function that is called when a check box is tapped
  final Function(String?) onCheckboxTap;

  @override
  _CheckboxListItemsState createState() => _CheckboxListItemsState();
}

class _CheckboxListItemsState extends State<CheckboxListItems> {
  /// Keep a list of [bool] values to correspond to the checked state of each checkbox
  late List<bool> _checked;

  /// Initialize class variables and constants
  void _initialize() {
    _checked =
        widget.items.map((Map<String, bool> map) => map.values.first).toList();
  }

  @override
  initState() {
    super.initState();
    _initialize();
  }

  @override
  Widget build(BuildContext context) {
    return RoundedContainer(
      child: ListView.separated(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: widget.items.length,
        padding: EdgeInsets.zero,
        itemBuilder: (BuildContext context, int index) {
          return CheckboxListTile(
              title: Text(widget.items[index].keys.first),
              value: _checked[index],
              onChanged: (bool? value) {
                setState(() {
                  _checked[index] = !_checked[index];
                });

                /// Get the index of every checked item, and send
                /// as a comma seperated string ONLY if at least one item is checked
                if (_checked.contains(true)) {
                  final List<int> checkedIndices = [];

                  _checked.asMap().forEach((int key, bool value) {
                    if (value == true) {
                      checkedIndices.add(key);
                    }
                  });

                  final String checkedItemsString = checkedIndices.join(',');

                  widget.onCheckboxTap(checkedItemsString);
                } else {
                  widget.onCheckboxTap(null);
                }
              });
        },
        separatorBuilder: (BuildContext context, int index) {
          return Divider();
        },
      ),
    );
  }
}
