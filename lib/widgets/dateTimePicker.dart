import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:novaone/constants.dart';
import 'package:novaone/palette.dart';
import 'package:novaone/widgets/widgets.dart';

class DateTimePicker extends StatefulWidget {
  /// The function that is called when a date has been selected from the date picker
  final void Function(DateTime? date) onDateSelected;

  /// The function that is called when a time has been selected from the time picker
  final void Function(TimeOfDay? time) onTimeSelected;

  const DateTimePicker(
      {Key? key, required this.onDateSelected, required this.onTimeSelected})
      : super(key: key);
  @override
  _DateTimePickerState createState() => _DateTimePickerState();
}

class _DateTimePickerState extends State<DateTimePicker> {
  /// The date that has been selected from the date popup
  DateTime selectedDate = DateTime.now();

  /// The time that has been selected from the time popup
  TimeOfDay selectedTime = TimeOfDay.now();

  /// The string used to show the selected time
  late String timeString;

  /// The string used to show the selected date
  late String dateString;

  /// The method that calls the popup to select a date from a calendar
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));

    /// If the user picks a date, set [selectedDate] and change the dateString
    /// so the UI is updated with the selected date
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        widget.onDateSelected(selectedDate);
        dateString = DateFormat.yMd().format(selectedDate);
      });
    }
  }

  /// The method that calls the popup to select a time from a calendar
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null) {
      setState(() {
        selectedTime = picked;
        widget.onTimeSelected(selectedTime);
        timeString = formatDate(
            DateTime(2019, 08, 1, selectedTime.hour, selectedTime.minute),
            [hh, ':', nn, " ", am]).toString();
      });
    }
  }

  @override
  void initState() {
    _initialize();
    super.initState();
  }

  /// Initialize date and time picked to the current date and time
  _initialize() {
    dateString = DateFormat.yMd().format(selectedDate);
    timeString = formatDate(selectedDate, [hh, ':', nn, " ", am]).toString();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Column(
            children: <Widget>[
              InputLabel(
                label: 'Choose Date',
              ),
              const SizedBox(
                height: appVerticalSpacing,
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 1),
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(borderRadius),
                  onTap: () {
                    _selectDate(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(defaultPadding),
                    child: Row(
                      children: <Widget>[
                        GradientIcon(
                            icon: Icons.calendar_today,
                            size: 25,
                            gradient: Palette.greetingContainerGradient),
                        Text(
                          dateString,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2
                              ?.copyWith(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          width: appHorizontalSpacing,
        ),
        Expanded(
          child: Column(
            children: <Widget>[
              InputLabel(
                label: 'Choose Time',
              ),
              const SizedBox(
                height: appVerticalSpacing,
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 1),
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(borderRadius),
                  onTap: () {
                    _selectTime(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(defaultPadding),
                    child: Row(
                      children: <Widget>[
                        GradientIcon(
                            icon: Icons.hourglass_bottom,
                            size: 25,
                            gradient: Palette.greetingContainerGradient),
                        Text(
                          timeString,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2
                              ?.copyWith(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
