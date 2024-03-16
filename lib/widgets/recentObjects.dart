import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:novaone/models/models.dart';
import 'package:novaone/palette.dart';
import 'package:novaone/utils/utils.dart';
import '../constants.dart';

class RecentObjects extends StatelessWidget {
  final List<BaseModel> objects;

  const RecentObjects({
    Key? key,
    required this.objects,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        itemCount: objects.length,
        itemBuilder: (BuildContext context, int index) {
          // Make sure to add no bottom border for the last item in the list
          final bool isLastItem = index == objects.length - 1 ? true : false;
          final bool isFirstItem = index == 0 ? true : false;
          final _random = new Random();
          final Color leadColor =
              Palette.appColors[_random.nextInt(Palette.appColors.length)];

          String title = '';
          String subtitle = '';
          final BaseModel object = objects[index];
          switch (objects[index].runtimeType) {
            case Lead:
              final Lead lead = object as Lead;
              title = lead.name;
              subtitle =
                  DateFormat(DateTimeHelper.defaultOutputDateFormatWithTime)
                      .format(lead.sentTextDate ?? DateTime.now());
              break;
            case Appointment:
              final Appointment appointment = object as Appointment;
              title = appointment.name;
              subtitle =
                  DateFormat(DateTimeHelper.defaultOutputDateFormatWithTime)
                      .format(appointment.time);
              break;
            case Company:
              final Company company = object as Company;
              title = company.name;
              subtitle =
                  DateFormat(DateTimeHelper.defaultOutputDateFormatWithTime)
                      .format(company.created);
              break;
            default:
              print('No cases matched for recent objects.');
          }

          return _RecentObjectItem(
            object: object,
            leadColor: leadColor,
            isLastItem: isLastItem,
            isFirstItem: isFirstItem,
            onTap: () => TableItemTappedHelper.instance
                .callOnTableItemTappedFunction(
                    object: object, context: context, color: leadColor),
            subtitle: subtitle,
            title: title,
          );
        });
  }
}

class _RecentObjectItem extends StatelessWidget {
  final BaseModel object;
  final String title;
  final String subtitle;
  final bool isLastItem;
  final bool isFirstItem;
  final Color leadColor;
  final Function() onTap;

  const _RecentObjectItem({
    Key? key,
    required this.object,
    this.isLastItem = false,
    required this.onTap,
    required this.leadColor,
    this.isFirstItem = false,
    required this.title,
    required this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Set the border radius for the last and first items to be rounded corners
    BorderRadius borderRadius;
    if (isFirstItem) {
      // Top right and top left for the first item in the list
      borderRadius = BorderRadius.only(
          topRight: Radius.circular(containerBorderRadius),
          topLeft: Radius.circular(containerBorderRadius));
    } else if (isLastItem) {
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
        onTap: onTap,
        child: Container(
          height: 80,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border(
              bottom: isLastItem == false
                  ? BorderSide(width: 2, color: Colors.grey[200]!)
                  : BorderSide(width: 0, color: Colors.transparent),
            ),
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Row(
                  children: [
                    Container(
                      height: listTableItemCircleAvatarSize,
                      width: listTableItemCircleAvatarSize,
                      child: Center(
                        child: Text(
                          title[0].toUpperCase(),
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: listTableItemCircleAvatarFontSize),
                        ),
                      ),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: leadColor,
                          border: Border.all(color: Colors.white)),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          title,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        Text(
                          subtitle,
                          style: TextStyle(color: Colors.grey[500]),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                  icon: Icon(
                    Icons.arrow_forward_ios_sharp,
                    size: 18,
                    color: Colors.black,
                  ),
                  onPressed: onTap),
            ],
          ),
        ),
      ),
    );
  }
}
