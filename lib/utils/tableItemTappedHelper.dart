import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:novaone/auth/auth.dart';
import 'package:novaone/models/models.dart';
import 'package:novaone/screens/objectDetail/objectDetailLayout.dart';
import 'package:novaone/utils/utils.dart';

class TableItemTappedHelper {
  static final TableItemTappedHelper instance =
      TableItemTappedHelper._internal();
  TableItemTappedHelper._internal();

  /// Calls the on table item tapped function associated
  /// with each model
  callOnTableItemTappedFunction(
      {required BaseModel object,
      required BuildContext context,
      required Color color}) {
    switch (object.runtimeType) {
      case Lead:
        final lead = object as Lead;
        _leadTableItemTapped(context: context, lead: lead, color: color);
        break;
      case Appointment:
        final appointment = object as Appointment;
        _appointmentTableItemTapped(
            context: context, appointment: appointment, color: color);
        break;
      case Company:
        final company = object as Company;
        _companyTableItemTapped(
            context: context, company: company, color: color);
        break;
      default:
        print(
            'No cases matched for TableItemTappedHelper.callOnTableItemTappedFunction');
    }
  }

  /// Navigates to the detail screen for table items tapped for a NovaOne
  /// list table.
  _leadTableItemTapped(
      {required BuildContext context,
      required Lead lead,
      required Color color}) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      return ObjectDetailLayout(
        objectColor: color,
        headerSubtitle: DateFormat(DateTimeHelper.defaultOutputDateFormat)
            .format(lead.dateOfInquiry),
        headerTitle: lead.name,
        object: lead,
        objectStore: context.read<ObjectStore>(),
      );
    }));
  }

  /// Navigates to the detail screen for table items tapped for a NovaOne
  /// list table.
  _appointmentTableItemTapped(
      {required BuildContext context,
      required Appointment appointment,
      required Color color}) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return ObjectDetailLayout(
        objectColor: color,
        headerSubtitle:
            DateFormat(DateTimeHelper.defaultOutputDateFormatWithTime)
                .format(appointment.time),
        headerTitle: appointment.name,
        object: appointment,
        objectStore: context.read<ObjectStore>(),
      );
    }));
  }

  /// Navigates to the detail screen for table items tapped for a NovaOne
  /// list table.
  _companyTableItemTapped(
      {required BuildContext context,
      required Company company,
      required Color color}) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return ObjectDetailLayout(
        objectColor: color,
        headerSubtitle:
            DateFormat(DateTimeHelper.defaultOutputDateFormatWithTime)
                .format(company.created),
        headerTitle: company.name,
        objectStore: context.read<ObjectStore>(),
        object: company,
      );
    }));
  }
}
