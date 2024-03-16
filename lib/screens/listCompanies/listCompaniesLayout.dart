import 'package:flutter/material.dart';
import 'package:novaone/responsive/responsive.dart';
import 'package:novaone/screens/listCompanies/listCompaniesMobile.dart';

class ListCompaniesLayout extends StatelessWidget {
  const ListCompaniesLayout(
      {Key? key, required this.onCheckboxTap, required this.companyCount})
      : super(key: key);

  /// The local count of companies that is used to initialize _checked in [ListCompaniesMobilePortrait]
  final int companyCount;

  /// The method that is called when the checkbox is tapped
  final void Function(String?) onCheckboxTap;

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
        mobile: OrientationLayout(
      portrait: ListCompaniesMobilePortrait(
        onCheckboxTap: onCheckboxTap,
        companyCount: companyCount,
      ),
    ));
  }
}
