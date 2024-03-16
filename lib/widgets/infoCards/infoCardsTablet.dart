import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:novaone/constants.dart';
import 'package:novaone/controllers/controller.dart';
import 'package:novaone/models/models.dart';
import 'package:novaone/palette.dart';
import 'package:novaone/widgets/circleButton.dart';
import 'package:novaone/widgets/infoCards/infoCards.dart';

class InfoCardsTablet extends InfoCardsBase {
  final List<Company> companies;

  InfoCardsTablet({
    required this.companies,
    required int leadCount,
    required int appointmentCount,
    required int companyCount,
  }) : super(
            companies: companies,
            leadCount: leadCount,
            appointmentCount: appointmentCount,
            companyCount: companyCount);

  @override
  _InfoCardsTabletState createState() => _InfoCardsTabletState();
}

class _InfoCardsTabletState extends InfoCardsBaseState {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 240,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _InfoCardTablet(
              onAdd: goToAddLeadScreen,
              onTap: () => context.read<NavScreenController>().index = 2,
              iconData: Icons.person,
              number: widget.leadCount,
              title: 'Leads',
              marginRight: appHorizontalSpacing,
            ),
            _InfoCardTablet(
              onAdd: goToAddAppointmentScreen,
              onTap: () => context.read<NavScreenController>().index = 1,
              iconData: Icons.person,
              number: widget.appointmentCount,
              title: 'Appointments',
              marginRight: appHorizontalSpacing,
            ),
            _InfoCardTablet(
              onAdd: goToAddCompanyScreen,
              onTap: () => context.read<NavScreenController>().index = 4,
              iconData: Icons.person,
              number: widget.companyCount,
              title: 'Companies',
            )
          ],
        ));
  }
}

class _InfoCardTablet extends StatelessWidget {
  final String title;
  final IconData iconData;
  final int number;
  final Function() onTap;
  final Function() onAdd;
  final double marginRight;

  const _InfoCardTablet(
      {Key? key,
      required this.title,
      required this.iconData,
      required this.number,
      this.marginRight = 0,
      required this.onTap,
      required this.onAdd})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: marginRight > 0
            ? EdgeInsets.only(right: marginRight)
            : EdgeInsets.only(right: 0),
        height: double.infinity,
        decoration: BoxDecoration(
          boxShadow: <BoxShadow>[
            BoxShadow(
                blurRadius: 50,
                color: Palette.primaryColor.withOpacity(0.23),
                offset: Offset(0, 10)),
          ],
        ),
        child: Material(
          borderRadius: BorderRadius.circular(containerBorderRadius),
          color: Colors.white,
          child: InkWell(
            borderRadius: BorderRadius.circular(containerBorderRadius),
            onTap: onTap,
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Positioned(
                  top: 8,
                  left: 8,
                  child: CircleButton(
                    iconData: Icons.add,
                    onPressed: onAdd,
                    backgroundColor: Palette.primaryColor,
                    iconColor: Colors.white,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        iconData,
                        size: 35,
                      ),
                      Text(
                        '$number',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Palette.primaryColor,
                            fontSize: 30,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        title,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
