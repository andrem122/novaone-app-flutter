import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:novaone/constants.dart';
import 'package:novaone/controllers/controller.dart';
import 'package:novaone/models/models.dart';
import 'package:novaone/palette.dart';
import 'package:novaone/widgets/infoCards/infoCards.dart';
import 'package:novaone/widgets/widgets.dart';

class InfoCardsMobile extends InfoCardsBase {
  final List<Company> companies;

  const InfoCardsMobile({
    Key? key,
    required this.companies,
    required int leadCount,
    required int appointmentCount,
    required int companyCount,
  }) : super(
            key: key,
            companies: companies,
            leadCount: leadCount,
            appointmentCount: appointmentCount,
            companyCount: companyCount);

  @override
  _InfoCardsMobileState createState() => _InfoCardsMobileState();
}

class _InfoCardsMobileState extends InfoCardsBaseState<InfoCardsMobile> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        _InfoCardMobile(
          onAdd: goToAddLeadScreen,
          iconData: Icons.people,
          onTap: () => context.read<NavScreenController>().index = 2,
          number: widget.leadCount,
          title: 'Leads',
          marginBottom: appVerticalSpacing,
          iconColor: Palette.secondaryColor,
          onArrowPressed: () => context.read<NavScreenController>().index = 2,
        ),
        _InfoCardMobile(
          onAdd: goToAddAppointmentScreen,
          onTap: () => context.read<NavScreenController>().index = 1,
          iconData: Icons.perm_contact_calendar,
          number: widget.appointmentCount,
          title: 'Appointments',
          marginBottom: appVerticalSpacing,
          iconColor: Palette.purpleColor,
          onArrowPressed: () => context.read<NavScreenController>().index = 1,
        ),
        _InfoCardMobile(
          onAdd: goToAddCompanyScreen,
          onTap: () => context.read<NavScreenController>().index = 4,
          iconData: Icons.business,
          number: widget.companyCount,
          title: 'Companies',
          iconColor: Palette.indigoColor,
          onArrowPressed: () => context.read<NavScreenController>().index = 4,
        )
      ],
    ));
  }
}

class _InfoCardMobile extends StatelessWidget {
  final String title;
  final IconData iconData;
  final int number;
  final double marginBottom;
  final Function() onAdd;
  final Function() onTap;
  final Function() onArrowPressed;
  final Color? iconColor;

  const _InfoCardMobile(
      {Key? key,
      required this.title,
      required this.iconData,
      required this.number,
      this.marginBottom = 0,
      required this.onAdd,
      this.iconColor,
      required this.onTap,
      required this.onArrowPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: marginBottom > 0
          ? EdgeInsets.only(bottom: marginBottom)
          : EdgeInsets.only(bottom: 0),
      height: 120,
      width: double.infinity,
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
                      color: iconColor,
                    ),
                    Text(
                      '$number',
                      overflow: TextOverflow.ellipsis,
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      title,
                      overflow: TextOverflow.ellipsis,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 37,
                right: 8,
                child: IconButton(
                    icon: Icon(Icons.arrow_forward_ios_sharp),
                    onPressed: onArrowPressed),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
