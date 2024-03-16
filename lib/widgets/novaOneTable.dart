import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:novaone/api/api.dart';
import 'package:novaone/enums/enums.dart';
import 'package:novaone/extensions/scaffoldExtension.dart';
import 'package:novaone/models/models.dart';
import 'package:novaone/novaOneTableHelper.dart';
import 'package:novaone/palette.dart';
import 'package:novaone/responsive/responsive.dart';
import 'package:novaone/screens/appointments/bloc/appointments_screen_bloc.dart';
import 'package:novaone/screens/companies/bloc/companies_screen_bloc.dart';
import 'package:novaone/screens/leads/bloc/leads_screen_bloc.dart';
import 'package:novaone/screens/screens.dart';
import 'package:novaone/utils/tableItemTappedHelper.dart';
import '../constants.dart';

class NovaOneTable extends StatefulWidget {
  final List<NovaOneTableItemData> tableItems;
  final NovaOneTableTypes tableType;
  final bool scrollable;
  final BaseApiClient? apiClient;
  static const String defaultDateFormat = 'MMM dd, yyyy | hh:mm a';

  NovaOneTable({
    Key? key,
    required this.tableItems,
    required this.tableType,
    this.scrollable = false,
    this.apiClient,
  }) : super(key: key);

  @override
  _NovaOneTableState createState() => _NovaOneTableState();
}

class _NovaOneTableState extends State<NovaOneTable> {
  late ScrollController controller;

  /// The boolean that indicates whether or not we are making
  /// an API call for more data to be appended to the table
  bool makingApiCallForData = false;

  /// All data has been fetched for the table/listview
  /// or there was never any data to begin with
  bool noMoreData = false;

  late List<NovaOneTableItemData> mutableTableItems;

  @override
  void initState() {
    super.initState();
    controller = new ScrollController()..addListener(_scrollListener);
  }

  @override
  void dispose() {
    controller.removeListener(_scrollListener);
    controller.dispose();
    super.dispose();
  }

  /// Listens for when the table is scrolled past a certain point
  /// and makes an API call for more data to be appended to the end
  /// of the table
  void _scrollListener() async {
    if (controller.position.extentAfter < 500 &&
        makingApiCallForData == false) {
      /// Make API call for more data and append to the
      /// existing list
      makingApiCallForData = true; // This boolean is needed

      List<BaseModel>? objects = [];
      try {
        objects = await widget.apiClient?.getMore(mutableTableItems.last.id);
        noMoreData = false;
        makingApiCallForData = false;
      } catch (error, stackTrace) {
        if (error is ApiMessageException) {
          print('Error fetching data to append to table view: ${error.reason}');
          noMoreData = true;
        } else {
          print('Error fetching data to append to table view: $error');
          print(stackTrace);
        }
        makingApiCallForData = false;
      }

      final List<NovaOneListTableItemData>? tableObjects = NovaOneTableHelper
          .instance
          .convertObjectsToListTableItemData(objects: objects);

      setState(() {
        if (tableObjects != null) {
          if (tableObjects.isNotEmpty) mutableTableItems.addAll(tableObjects);
        }
      });
    }
  }

  /// Refreshes the table with new data from the server
  Future<void> _onRefresh() async {
    /// Make an API call and get data from the server. The [refresh] method
    /// will also store the objects locally after they have been obtained from
    /// the server
    final List<BaseModel>? objects =
        await widget.apiClient?.refresh(mutableTableItems.last.id, context);
    final List<NovaOneListTableItemData>? tableItems = NovaOneTableHelper
        .instance
        .convertObjectsToListTableItemData(objects: objects);
    setState(() {
      if (tableItems != null) {
        mutableTableItems = tableItems;

        switch (objects?.first.runtimeType) {
          case Lead:
            BlocProvider.of<LeadsScreenBloc>(context)
                .add(LeadsScreenRefreshTable(key: UniqueKey()));
            break;
          case Appointment:
            BlocProvider.of<AppointmentsScreenBloc>(context)
                .add(AppointmentsScreenRefreshTable(key: UniqueKey()));
            break;
          case Company:
            BlocProvider.of<CompaniesScreenBloc>(context)
                .add(CompaniesScreenRefreshTable(key: UniqueKey()));
            break;
          default:
            throw TypeError();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    mutableTableItems = widget.tableItems;
    final Widget childWithRefresh = RefreshIndicator(
      onRefresh: _onRefresh,
      child: ListView.builder(
          controller: controller,
          shrinkWrap: true,
          physics: widget.scrollable == false
              ? NeverScrollableScrollPhysics()
              : AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemCount: mutableTableItems.length,
          itemBuilder: (BuildContext context, int index) {
            // Make sure to add no bottom border for the last item in the list
            final bool isLastItem =
                index == mutableTableItems.length - 1 ? true : false;
            final bool isFirstItem = index == 0 ? true : false;

            Widget tableItemWidget = Container();

            /// Determine what table item to render based on the table type
            switch (widget.tableType) {
              case NovaOneTableTypes.DetailTable:
                final NovaOneDetailTableItemData tableItem =
                    mutableTableItems[index] as NovaOneDetailTableItemData;

                tableItemWidget = _NovaOneDetailTableItem(
                  detailTableItem: tableItem,
                  isLastItem: isLastItem,
                  isFirstItem: isFirstItem,
                  popupMenuOptions: tableItem.popupMenuOptions,
                  onTap: tableItem.onPressed,
                  onPopupMenuItemSelected: (leadDetailMenuOptions) {
                    if (leadDetailMenuOptions == DetailTableMenuOptions.Edit) {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => InputLayout(
                                description: tableItem.updateDescription,
                                initialText: tableItem.initialText,
                                title: tableItem.updateTitle,
                                checkboxListItems: tableItem.checkboxListItems,
                                hintText: tableItem.updateFieldHintText,
                                inputWidgetType: tableItem.inputWidget,
                                onSubmitButtonPressed:
                                    tableItem.onSubmitButtonPressed,
                                onDoneButtonPressed:
                                    tableItem.onDoneButtonPressed,
                                onBinaryOptionSelected:
                                    tableItem.onBinaryOptionSelected,
                                submitButtonTitle: 'Update',
                              )));
                    } else {
                      Clipboard.setData(ClipboardData(text: tableItem.title));
                      Scaffold.of(context).showSuccessSnackBar(
                          message: 'Success! Text copied to clipboard.');
                    }
                  },
                );
                break;
              case NovaOneTableTypes.ListTable:
                final NovaOneListTableItemData tableItem =
                    mutableTableItems[index] as NovaOneListTableItemData;

                tableItemWidget = _NovaOneListTableItem(
                  isFirstItem: isFirstItem,
                  isLastItem: isLastItem,
                  listTableItem: tableItem,
                  onTap: () => TableItemTappedHelper.instance
                      .callOnTableItemTappedFunction(
                          object: tableItem.object,
                          context: context,
                          color: tableItem.color),
                  onPopupMenuItemSelected: (listTableItemMenuOptions) {
                    if (listTableItemMenuOptions ==
                        ListTableItemMenuOptions.Call) {}
                  },
                );
                break;
            }

            /// Show loading indicator if at the bottom of the table
            /// and we are making an API call for data
            if (makingApiCallForData && isLastItem && !noMoreData) {
              return Center(
                  child: Padding(
                padding: const EdgeInsets.only(top: 15),
                child: CircularProgressIndicator(
                  color: Palette.primaryColor,
                ),
              ));
            }

            return tableItemWidget;
          }),
    );

    final Widget childWithoutRefresh = ListView.builder(
        controller: controller,
        shrinkWrap: true,
        physics: widget.scrollable == false
            ? NeverScrollableScrollPhysics()
            : AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        itemCount: mutableTableItems.length,
        itemBuilder: (BuildContext context, int index) {
          // Make sure to add no bottom border for the last item in the list
          final bool isLastItem =
              index == mutableTableItems.length - 1 ? true : false;
          final bool isFirstItem = index == 0 ? true : false;

          Widget tableItemWidget = Container();

          /// Determine what table item to render based on the table type
          switch (widget.tableType) {
            case NovaOneTableTypes.DetailTable:
              final NovaOneDetailTableItemData tableItem =
                  mutableTableItems[index] as NovaOneDetailTableItemData;

              tableItemWidget = _NovaOneDetailTableItem(
                detailTableItem: tableItem,
                isLastItem: isLastItem,
                isFirstItem: isFirstItem,
                popupMenuOptions: tableItem.popupMenuOptions,
                onTap: tableItem.onPressed,
                onPopupMenuItemSelected: (leadDetailMenuOptions) {
                  if (leadDetailMenuOptions == DetailTableMenuOptions.Edit) {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => InputLayout(
                              initialText: tableItem.initialText,
                              description: tableItem.updateDescription,
                              checkboxListItems: tableItem.checkboxListItems,
                              title: tableItem.updateTitle,
                              hintText: tableItem.updateFieldHintText,
                              inputWidgetType: tableItem.inputWidget,
                              onSubmitButtonPressed:
                                  tableItem.onSubmitButtonPressed,
                              onDoneButtonPressed:
                                  tableItem.onDoneButtonPressed,
                              onBinaryOptionSelected:
                                  tableItem.onBinaryOptionSelected,
                              submitButtonTitle: 'Update',
                            )));
                  } else {
                    Clipboard.setData(ClipboardData(text: tableItem.title));
                    Scaffold.of(context).showSuccessSnackBar(
                        message: 'Success! Text copied to clipboard.');
                  }
                },
              );
              break;
            case NovaOneTableTypes.ListTable:
              final NovaOneListTableItemData tableItem =
                  mutableTableItems[index] as NovaOneListTableItemData;

              tableItemWidget = _NovaOneListTableItem(
                isFirstItem: isFirstItem,
                isLastItem: isLastItem,
                listTableItem: tableItem,
                onTap: () => TableItemTappedHelper.instance
                    .callOnTableItemTappedFunction(
                        object: tableItem.object,
                        context: context,
                        color: tableItem.color),
                onPopupMenuItemSelected: (listTableItemMenuOptions) {
                  if (listTableItemMenuOptions ==
                      ListTableItemMenuOptions.Call) {}
                },
              );
              break;
          }

          /// Show loading indicator if at the bottom of the table
          /// and we are making an API call for data
          if (makingApiCallForData && isLastItem && !noMoreData) {
            return Center(
                child: Padding(
              padding: const EdgeInsets.only(top: 15),
              child: CircularProgressIndicator(
                color: Palette.primaryColor,
              ),
            ));
          }

          return tableItemWidget;
        });

    final Widget childToUse = widget.tableType == NovaOneTableTypes.ListTable
        ? childWithRefresh
        : childWithoutRefresh;

    return ClipRRect(
      borderRadius: BorderRadius.circular(containerBorderRadius),
      child: childToUse,
    );
  }
}

/// Shows the details of an object's properties in a table item
class _NovaOneDetailTableItem extends StatefulWidget {
  final NovaOneDetailTableItemData detailTableItem;
  final bool isLastItem;
  final bool isFirstItem;

  final List<PopupMenuEntry> popupMenuOptions;
  final Function(dynamic) onPopupMenuItemSelected;
  final Function()? onTap;

  const _NovaOneDetailTableItem({
    Key? key,
    this.isLastItem = false,
    this.isFirstItem = false,
    this.onTap,
    required this.detailTableItem,
    required this.popupMenuOptions,
    required this.onPopupMenuItemSelected,
  }) : super(key: key);

  @override
  State<_NovaOneDetailTableItem> createState() =>
      _NovaOneDetailTableItemState();
}

class _NovaOneDetailTableItemState extends State<_NovaOneDetailTableItem> {
  @override
  Widget build(BuildContext context) {
    // Set the border radius for the last and first items to be rounded corners
    BorderRadius borderRadius;
    if (widget.isFirstItem) {
      // Top right and top left for the first item in the list
      borderRadius = BorderRadius.only(
          topRight: Radius.circular(containerBorderRadius),
          topLeft: Radius.circular(containerBorderRadius));
    } else if (widget.isLastItem) {
      borderRadius = BorderRadius.only(
          bottomRight: Radius.circular(containerBorderRadius),
          bottomLeft: Radius.circular(containerBorderRadius));
    } else {
      borderRadius = BorderRadius.zero;
    }

    return Material(
      color: Colors.white,
      borderRadius: borderRadius,
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: borderRadius,
        child: Container(
          padding: EdgeInsets.all(10),
          height: 80,
          decoration: BoxDecoration(
            border: Border(
              bottom: widget.isLastItem == false
                  ? BorderSide(width: 2, color: Colors.grey[200]!)
                  : BorderSide(width: 0, color: Colors.transparent),
            ),
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Row(
                  children: [
                    Icon(
                      widget.detailTableItem.iconData,
                      color: widget.detailTableItem.iconColor,
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width * 0.60,
                          child: Text(
                            widget.detailTableItem.title,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.60,
                          child: Text(
                            widget.detailTableItem.subtitle,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Colors.grey[500]),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              PopupMenuButton(
                itemBuilder: (context) {
                  return widget.popupMenuOptions;
                },
                icon: Icon(Icons.more_vert),
                onSelected: widget.onPopupMenuItemSelected,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Lists the basic properties of the object in a table item
class _NovaOneListTableItem extends StatefulWidget {
  final NovaOneListTableItemData listTableItem;
  final bool isLastItem;
  final bool isFirstItem;
  final Color color;

  final Function(dynamic) onPopupMenuItemSelected;

  /// The function that is called when this table item is tapped
  final void Function()? onTap;

  const _NovaOneListTableItem({
    Key? key,
    required this.listTableItem,
    this.isLastItem = false,
    this.onTap,
    this.color = Palette.primaryColor,
    this.isFirstItem = false,
    required this.onPopupMenuItemSelected,
  }) : super(key: key);

  @override
  State<_NovaOneListTableItem> createState() => _NovaOneListTableItemState();
}

class _NovaOneListTableItemState extends State<_NovaOneListTableItem> {
  @override
  Widget build(BuildContext context) {
    final SizingInformation sizingInformation =
        context.read<SizingInformation>();
    final double deviceWidth = sizingInformation.screenSize.width;

    // Set the border radius for the last and first items to be rounded corners
    BorderRadius borderRadius;
    if (widget.isFirstItem) {
      // Top right and top left for the first item in the list
      borderRadius = BorderRadius.only(
          topRight: Radius.circular(containerBorderRadius),
          topLeft: Radius.circular(containerBorderRadius));
    } else if (widget.isLastItem) {
      borderRadius = BorderRadius.only(
          bottomRight: Radius.circular(containerBorderRadius),
          bottomLeft: Radius.circular(containerBorderRadius));
    } else {
      borderRadius = BorderRadius.zero;
    }

    return Material(
      borderRadius: borderRadius,
      color: Colors.white,
      child: InkWell(
        borderRadius: borderRadius,
        onTap: widget.onTap,
        child: Container(
          height: 80,
          padding: EdgeInsets.all(defaultPadding),
          decoration: BoxDecoration(
            border: Border(
              bottom: widget.isLastItem == false
                  ? BorderSide(width: 2, color: Colors.grey[200]!)
                  : BorderSide(width: 0, color: Colors.transparent),
            ),
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  child: Row(
                    children: <Widget>[
                      Container(
                        height: listTableItemCircleAvatarSize,
                        width: listTableItemCircleAvatarSize,
                        child: Center(
                          child: Text(
                            widget.listTableItem.title[0].toUpperCase(),
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: listTableItemCircleAvatarFontSize),
                          ),
                        ),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: widget.color,
                            border: Border.all(color: Colors.white)),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Container(
                        width: deviceWidth <= 320
                            ? (0.53 * deviceWidth)
                            : (0.60 * deviceWidth),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              widget.listTableItem.title,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            Text(
                              widget.listTableItem.subtitle,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: Colors.grey[500]),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              PopupMenuButton(
                itemBuilder: (context) {
                  return widget.listTableItem.popupMenuOptions;
                },
                icon: Icon(Icons.more_vert),
                onSelected: widget.onPopupMenuItemSelected,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
