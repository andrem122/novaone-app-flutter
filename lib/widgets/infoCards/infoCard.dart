import 'package:flutter/material.dart';
import 'package:novaone/models/company.dart';
import 'package:novaone/widgets/infoCards/infoCards.dart';
import 'package:novaone/responsive/screenTypeLayout.dart';

class InfoCards extends StatelessWidget {
  final List<Company> companies;
  final int leadCount;
  final int appointmentCount;
  final int companyCount;

  const InfoCards(
      {Key? key,
      required this.companies,
      this.leadCount = 0,
      this.appointmentCount = 0,
      this.companyCount = 0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: InfoCardsMobile(
        companies: companies,
        appointmentCount: appointmentCount,
        companyCount: companyCount,
        leadCount: leadCount,
      ),
      tablet: InfoCardsTablet(
        companies: companies,
        appointmentCount: appointmentCount,
        companyCount: companyCount,
        leadCount: leadCount,
      ),
      desktop: InfoCardsTablet(
        companies: companies,
        appointmentCount: appointmentCount,
        leadCount: leadCount,
        companyCount: companyCount,
      ),
    );
  }
}
