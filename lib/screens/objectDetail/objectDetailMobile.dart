import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:novaone/auth/auth.dart';
import 'package:novaone/constants.dart';
import 'package:novaone/enums/enums.dart';
import 'package:novaone/models/models.dart';
import 'package:novaone/novaOneUrl.dart';
import 'package:novaone/palette.dart';
import 'package:novaone/screens/input/bloc/input_bloc.dart';
import 'package:novaone/screens/objectDetail/bloc/object_detail_bloc.dart';
import 'package:novaone/utils/utils.dart';
import 'package:novaone/widgets/widgets.dart';

class ObjectDetailMobilePortrait extends StatefulWidget {
  final Color objectColor;

  /// The object that is being displayed
  final BaseModel object;

  final ObjectStore objectStore;

  ObjectDetailMobilePortrait({
    Key? key,
    required this.objectColor,
    required this.object,
    required this.objectStore,
  }) : super(key: key);

  @override
  State<ObjectDetailMobilePortrait> createState() =>
      _ObjectDetailMobilePortraitState();
}

class _ObjectDetailMobilePortraitState
    extends State<ObjectDetailMobilePortrait> {
  /// The main title that goes in the white box of the header
  late String headerTitle;

  /// The title that goes below the main title in the whie box of the header
  late String headerSubtitle;

  /// Gets the title to display in the [ObjectDetailHeader] widget
  Future<List<String>> _getHeaderTitleAndSubtitle(BaseModel object) async {
    switch (object.runtimeType) {
      case Lead:
        final lead = (await widget.objectStore
                .getObjects<Lead>(where: 'id = ?', whereArgs: [object.id]))
            .first;
        return [
          lead.name,
          DateFormat(DateTimeHelper.defaultOutputDateFormatWithTime)
              .format(lead.sentEmailDate ?? DateTime.now())
        ];
      case Appointment:
        final appointment = (await widget.objectStore.getObjects<Appointment>(
                where: 'id = ?', whereArgs: [object.id]))
            .first;
        return [
          appointment.name,
          DateFormat(DateTimeHelper.defaultOutputDateFormatWithTime)
              .format(appointment.time)
        ];
      case Company:
        final company = (await widget.objectStore
                .getObjects<Company>(where: 'id = ?', whereArgs: [object.id]))
            .first;
        return [
          company.name,
          DateFormat(DateTimeHelper.defaultOutputDateFormatWithTime)
              .format(company.created)
        ];
      default:
        throw TypeError();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: Future.wait(
            [
              _generateDetailTableItems(
                  context: context, object: widget.object),
              _getHeaderTitleAndSubtitle(widget.object),
            ],
            eagerError: true,
          ),
          builder:
              (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
            if (snapshot.hasData) {
              return CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(
                    actions: <Widget>[
                      if (widget.object.runtimeType != Company)
                        IconButton(
                          onPressed: () => UrlLauncherHelper.instance
                              .callNumber(widget.object),
                          icon: Icon(
                            Icons.phone,
                            color: Colors.white,
                            size: sliverAppBarIconSize,
                          ),
                        ),
                      if (widget.object.runtimeType == Lead)
                        IconButton(
                          onPressed: () =>
                              UrlLauncherHelper.instance.email(widget.object),
                          icon: Icon(
                            Icons.mail,
                            color: Colors.white,
                            size: sliverAppBarIconSize,
                          ),
                        ),
                      IconButton(
                          onPressed: () => Navigator.of(context).push(
                              ModalPopup(
                                  actionButtonTitle: 'Delete',
                                  title: 'Delete?',
                                  subtitle:
                                      'Are you sure you want to delete this?',
                                  onActionButtonPressed: () {
                                    BlocProvider.of<ObjectDetailBloc>(context)
                                        .add(
                                      ObjectDetailDeleteObject(
                                        object: widget.object,
                                      ),
                                    );
                                    _onDoneButtonPressed(context);
                                  })),
                          icon: Icon(
                            Icons.delete,
                            color: Colors.white,
                            size: sliverAppBarIconSize,
                          )),
                    ],
                    expandedHeight: 180,
                    iconTheme: IconThemeData(color: Colors.black),
                    flexibleSpace: ObjectDetailHeader(
                      leadColor: widget.objectColor,
                      containerDecimalHeight: 0.20,
                      headerTitle: snapshot.data?[1][0] ?? 'No Title',
                      headerSubtitle: snapshot.data?[1][1] ?? 'No Subtitle',
                    ),
                  ),
                  SliverPadding(
                      padding: const EdgeInsets.fromLTRB(appHorizontalSpacing,
                          100, appHorizontalSpacing, lastWidgetVerticalSpacing),
                      sliver: SliverToBoxAdapter(
                        child: SafeArea(
                          bottom: false,
                          top: false,
                          child: NovaOneTable(
                            tableItems: snapshot.data?.first ??
                                <NovaOneDetailTableItemData>[],
                            tableType: NovaOneTableTypes.DetailTable,
                          ),
                        ),
                      )),
                ],
              );
            }

            if (snapshot.hasError) {
              return ErrorDisplay(
                onPressed: () {},
              );
            }

            return Center(child: Text('Could not account for state'));
          }),
    );
  }

  /// Handles what happens when the submit button is pressed to update a value
  /// for an object
  _onSubmitButtonPressed<T extends BaseModel>(
      {required BuildContext context,
      required Map<UpdateObject, dynamic> properties,
      required T object}) {
    switch (object.runtimeType) {
      case Lead:
        final lead = object as Lead;
        BlocProvider.of<InputBloc>(context)
            .add(InputUpdateLead(lead: lead, properties: properties));
        break;
      case Appointment:
        final appointment = object as Appointment;
        BlocProvider.of<InputBloc>(context).add(InputUpdateAppointment(
            appointment: appointment, properties: properties));
        break;
      case Company:
        final company = object as Company;
        BlocProvider.of<InputBloc>(context)
            .add(InputUpdateCompany(company: company, properties: properties));
        break;
      default:
    }
  }

  /// Handles what happens when the done button is pressed after updating a value
  /// for an object
  _onDoneButtonPressed(BuildContext context) {
    int count = 0;
    Navigator.of(context).popUntil((_) => count++ >= 2);

    /// Call set state to show any data changes on screen
    setState(() {});
  }

  /// Generates the table items shown on the detail screen
  ///
  /// Requires a [context] and [object] that must extend the BaseModel class
  Future<List<NovaOneDetailTableItemData>> _generateDetailTableItems(
      {required BuildContext context, required BaseModel object}) async {
    final List<PopupMenuEntry> popupMenuOptions = [
      PopupMenuItem(
        value: DetailTableMenuOptions.Edit,
        child: Text('Edit'),
      ),
      PopupMenuItem(
        value: DetailTableMenuOptions.Copy,
        child: Text('Copy'),
      ),
    ];

    final List<PopupMenuEntry> popupMenuOptionsCopyOnly = [
      PopupMenuItem(
        value: DetailTableMenuOptions.Copy,
        child: Text('Copy'),
      ),
    ];

    switch (object.runtimeType) {
      case Lead:
        try {
          final lead = (await widget.objectStore
                  .getObjects<Lead>(where: 'id = ?', whereArgs: [object.id]))
              .first;
          return <NovaOneDetailTableItemData>[
            NovaOneDetailTableItemData(
              inputWidget: InputWidgetType.TextInput,
              title: ValueChecker.instance.isNullOrEmpty(lead.name)
                  ? 'No name'
                  : lead.name,
              subtitle: 'Name',
              iconData: Icons.person,
              iconColor: Palette.appColors[0],
              popupMenuOptions: popupMenuOptions,
              updateTitle: 'Update Name',
              updateDescription: 'Update the name of the lead.',
              updateFieldHintText: 'Name',
              id: lead.id,
              object: lead,
              onSubmitButtonPressed: (String value) {
                final Map<UpdateObject, String> properties = {
                  UpdateObject.LeadName: value
                };
                _onSubmitButtonPressed(
                    context: context, object: lead, properties: properties);
              },
              onDoneButtonPressed: () => _onDoneButtonPressed(context),
            ),
            NovaOneDetailTableItemData(
              inputWidget: InputWidgetType.CalendarInput,
              title: DateFormat(DateTimeHelper.defaultOutputDateFormatWithTime)
                  .format(lead.sentEmailDate ?? DateTime.now()),
              subtitle: 'Email Sent',
              iconData: Icons.send,
              iconColor: Palette.appColors[1],
              popupMenuOptions: popupMenuOptions,
              updateTitle: 'Update Email',
              updateDescription:
                  'Update the date the email was sent to the lead.',
              id: lead.id,
              object: lead,
              onSubmitButtonPressed: (String value) {
                final Map<UpdateObject, String> properties = {
                  UpdateObject.LeadSentEmailDate: value
                };
                _onSubmitButtonPressed(
                    context: context, object: lead, properties: properties);
              },
              onDoneButtonPressed: () => _onDoneButtonPressed(context),
            ),
            NovaOneDetailTableItemData(
              inputWidget: InputWidgetType.CalendarInput,
              title: DateFormat(DateTimeHelper.defaultOutputDateFormatWithTime)
                  .format(lead.sentTextDate ?? DateTime.now()),
              subtitle: 'Text Sent',
              iconData: Icons.textsms_rounded,
              iconColor: Palette.appColors[2],
              popupMenuOptions: popupMenuOptions,
              updateTitle: 'Update Sent Text Date',
              updateDescription:
                  'Update the date the text message was sent to the lead.',
              id: lead.id,
              object: lead,
              onSubmitButtonPressed: (String value) {},
              onDoneButtonPressed: () {},
            ),
            NovaOneDetailTableItemData(
              inputWidget: InputWidgetType.TextInput,
              title: ValueChecker.instance.isNullOrEmpty(lead.phoneNumber)
                  ? 'No phone number'
                  : lead.phoneNumber!,
              subtitle: 'Phone Number',
              iconData: Icons.phone,
              iconColor: Palette.appColors[1],
              popupMenuOptions: popupMenuOptions,
              updateTitle: 'Update Phone',
              updateDescription: 'Update the phone number of the lead.',
              updateFieldHintText: 'Phone Number',
              id: lead.id,
              object: lead,
              onSubmitButtonPressed: (String value) {
                final Map<UpdateObject, String> properties = {
                  UpdateObject.LeadPhone: value
                };
                _onSubmitButtonPressed(
                    context: context, object: lead, properties: properties);
              },
              onDoneButtonPressed: () => _onDoneButtonPressed(context),
            ),
            NovaOneDetailTableItemData(
              inputWidget: InputWidgetType.EmailInput,
              title: ValueChecker.instance.isNullOrEmpty(lead.email)
                  ? 'No email'
                  : lead.email!,
              subtitle: 'Email',
              iconData: Icons.email,
              iconColor: Palette.appColors[2],
              popupMenuOptions: popupMenuOptions,
              updateTitle: 'Update Email',
              updateDescription: 'Update the email of the lead.',
              updateFieldHintText: 'Email',
              id: lead.id,
              object: lead,
              onSubmitButtonPressed: (String value) {
                final Map<UpdateObject, String> properties = {
                  UpdateObject.LeadEmail: value
                };
                _onSubmitButtonPressed(
                    context: context, object: lead, properties: properties);
              },
              onDoneButtonPressed: () => _onDoneButtonPressed(context),
            ),
            NovaOneDetailTableItemData(
              inputWidget: InputWidgetType.DropdownRenterBrand,
              title: ValueChecker.instance.isNullOrEmpty(lead.renterBrand)
                  ? 'No renter brand'
                  : lead.renterBrand!,
              subtitle: 'Renter Brand',
              iconData: Icons.email,
              iconColor: Palette.appColors[2],
              popupMenuOptions: popupMenuOptions,
              updateTitle: 'Update Renter Brand',
              updateDescription: 'Update the renter brand of the lead.',
              updateFieldHintText: 'Renter Brand',
              id: lead.id,
              object: lead,
              onSubmitButtonPressed: (String value) {
                final Map<UpdateObject, String> properties = {
                  UpdateObject.LeadRenterBrand: value
                };
                _onSubmitButtonPressed(
                    context: context, object: lead, properties: properties);
              },
              onDoneButtonPressed: () => _onDoneButtonPressed(context),
            ),
            NovaOneDetailTableItemData(
              inputWidget: InputWidgetType.BinaryInput,
              title: lead.madeAppointment ? 'Yes' : 'No',
              subtitle: 'Made Appointment',
              iconData: Icons.calendar_today_rounded,
              iconColor: Palette.appColors[3],
              popupMenuOptions: popupMenuOptions,
              updateTitle: 'Update Status',
              updateDescription: 'Has the lead made an appointment?',
              id: lead.id,
              object: lead,
              onBinaryOptionSelected: (String value) {
                final Map<UpdateObject, String> properties = {
                  UpdateObject.LeadMadeAppointment: value
                };
                _onSubmitButtonPressed(
                    context: context, object: lead, properties: properties);
              },
              onDoneButtonPressed: () => _onDoneButtonPressed(context),
              onSubmitButtonPressed: (String value) {},
            ),
            NovaOneDetailTableItemData(
              inputWidget: InputWidgetType.ListInput,
              title: ValueChecker.instance.isNullOrEmpty(lead.companyName)
                  ? 'No company name'
                  : lead.companyName,
              subtitle: 'Company Name',
              iconData: Icons.business,
              iconColor: Palette.appColors[4],
              popupMenuOptions: popupMenuOptions,
              updateTitle: 'Update Company',
              updateDescription: 'Update the company of the lead.',
              id: lead.id,
              object: lead,
              onSubmitButtonPressed: (String value) {
                final Map<UpdateObject, String> properties = {
                  UpdateObject.LeadCompany: value
                };
                _onSubmitButtonPressed(
                    context: context, object: lead, properties: properties);
              },
              onDoneButtonPressed: () => _onDoneButtonPressed(context),
            ),
          ];
        } catch (error) {
          print(
              '_ObjectDetailMobilePortraitState._generateDetailTableItems: $error');
          return <NovaOneDetailTableItemData>[];
        }

      case Appointment:
        try {
          final appointment = (await widget.objectStore.getObjects<Appointment>(
                  where: 'id = ?', whereArgs: [object.id]))
              .first;
          return <NovaOneDetailTableItemData>[
            NovaOneDetailTableItemData(
              inputWidget: InputWidgetType.TextInput,
              title: appointment.name,
              subtitle: 'Name',
              iconData: Icons.person,
              iconColor: Palette.appColors[0],
              popupMenuOptions: popupMenuOptions,
              updateTitle: 'Update Name',
              updateDescription: 'Update the name of the appointment.',
              updateFieldHintText: 'Name',
              id: appointment.id,
              object: appointment,
              onSubmitButtonPressed: (String value) {
                final Map<UpdateObject, String> properties = {
                  UpdateObject.AppointmentName: value
                };
                _onSubmitButtonPressed(
                    context: context,
                    object: appointment,
                    properties: properties);
              },
              onDoneButtonPressed: () => _onDoneButtonPressed(context),
            ),
            NovaOneDetailTableItemData(
              inputWidget: InputWidgetType.PhoneInput,
              title: appointment.phoneNumber,
              subtitle: 'Phone Number',
              iconData: Icons.phone,
              iconColor: Palette.appColors[1],
              popupMenuOptions: popupMenuOptions,
              updateTitle: 'Update Phone',
              updateDescription: 'Update the phone number of the appointment.',
              updateFieldHintText: 'Phone Number',
              id: appointment.id,
              object: appointment,
              onSubmitButtonPressed: (String value) {
                final Map<UpdateObject, String> properties = {
                  UpdateObject.AppointmentPhoneNumber: value
                };
                _onSubmitButtonPressed(
                    context: context,
                    object: appointment,
                    properties: properties);
              },
              onDoneButtonPressed: () => _onDoneButtonPressed(context),
            ),
            NovaOneDetailTableItemData(
              inputWidget: InputWidgetType.CalendarInput,
              title: DateFormat(DateTimeHelper.defaultOutputDateFormatWithTime)
                  .format(appointment.time),
              subtitle: 'Time',
              iconData: Icons.calendar_today,
              iconColor: Palette.appColors[1],
              popupMenuOptions: popupMenuOptions,
              updateTitle: 'Update Time',
              updateDescription: 'Update the time of the appointment.',
              updateFieldHintText: 'Time',
              id: appointment.id,
              object: appointment,
              onSubmitButtonPressed: (String value) {
                final Map<UpdateObject, String> properties = {
                  UpdateObject.AppointmentTime: value
                };
                _onSubmitButtonPressed(
                    context: context,
                    object: appointment,
                    properties: properties);
              },
              onDoneButtonPressed: () => _onDoneButtonPressed(context),
            ),
            NovaOneDetailTableItemData(
              inputWidget: InputWidgetType.BinaryInput,
              title: appointment.confirmed ? 'Yes' : 'No',
              subtitle: 'Confirmed',
              iconData: Icons.calendar_today_rounded,
              iconColor: Palette.appColors[3],
              popupMenuOptions: popupMenuOptions,
              updateTitle: 'Update Status',
              updateDescription: 'Has the lead confirmed the appointment?',
              id: appointment.id,
              object: appointment,
              onBinaryOptionSelected: (String value) {
                final Map<UpdateObject, String> properties = {
                  UpdateObject.AppointmentConfirmed: value
                };
                _onSubmitButtonPressed(
                    context: context,
                    object: appointment,
                    properties: properties);
              },
              onDoneButtonPressed: () => _onDoneButtonPressed(context),
              onSubmitButtonPressed: (String value) {},
            ),
            NovaOneDetailTableItemData(
              inputWidget: InputWidgetType.DropdownUnitType,
              title: appointment.unitType ?? 'None',
              subtitle: 'Unit Type',
              iconData: Icons.apartment,
              iconColor: Palette.appColors[4],
              popupMenuOptions: popupMenuOptions,
              updateTitle: 'Update Unit Type',
              updateDescription: 'Update the unit type of the appoinment.',
              id: appointment.id,
              object: appointment,
              onSubmitButtonPressed: (String value) {
                final Map<UpdateObject, String> properties = {
                  UpdateObject.AppointmentUnitType: value
                };
                _onSubmitButtonPressed(
                    context: context,
                    object: appointment,
                    properties: properties);
              },
              onDoneButtonPressed: () => _onDoneButtonPressed(context),
            ),
          ];
        } catch (error) {
          print(
              '_ObjectDetailMobilePortraitState._generateDetailTableItems: $error');
          return <NovaOneDetailTableItemData>[];
        }

      case Company:
        try {
          final company = (await widget.objectStore
                  .getObjects<Company>(where: 'id = ?', whereArgs: [object.id]))
              .first;
          return <NovaOneDetailTableItemData>[
            NovaOneDetailTableItemData(
              inputWidget: InputWidgetType.TextInput,
              title: company.name,
              subtitle: 'Name',
              iconData: Icons.person,
              iconColor: Palette.appColors[0],
              popupMenuOptions: popupMenuOptions,
              updateTitle: 'Update Name',
              updateDescription: 'Update the name of the company.',
              updateFieldHintText: 'Name',
              id: company.id,
              object: company,
              onSubmitButtonPressed: (String value) {
                final Map<UpdateObject, String> properties = {
                  UpdateObject.CompanyName: value
                };
                _onSubmitButtonPressed(
                    context: context, object: company, properties: properties);
              },
              onDoneButtonPressed: () => _onDoneButtonPressed(context),
            ),
            NovaOneDetailTableItemData(
              inputWidget: InputWidgetType.AddressInput,
              title: company.address,
              subtitle: 'Address',
              iconData: Icons.business,
              iconColor: Palette.appColors[1],
              popupMenuOptions: popupMenuOptions,
              updateTitle: 'Update Address',
              updateDescription: 'Update the address of the company.',
              updateFieldHintText: 'Address',
              id: company.id,
              object: company,
              onSubmitButtonPressed: (String value) {
                final Map<UpdateObject, String> properties = {
                  UpdateObject.CompanyAddress: value
                };

                _onSubmitButtonPressed(
                    context: context, object: company, properties: properties);
              },
              onDoneButtonPressed: () => _onDoneButtonPressed(context),
            ),
            NovaOneDetailTableItemData(
              inputWidget: InputWidgetType.PhoneInput,
              title: company.phoneNumber,
              subtitle: 'Phone Number',
              iconData: Icons.phone,
              iconColor: Palette.appColors[1],
              popupMenuOptions: popupMenuOptions,
              updateTitle: 'Update Phone',
              updateDescription: 'Update the phone number of the company.',
              updateFieldHintText: 'Phone Number',
              id: company.id,
              object: company,
              onSubmitButtonPressed: (String value) {
                final Map<UpdateObject, String> properties = {
                  UpdateObject.CompanyPhoneNumber: value
                };
                _onSubmitButtonPressed(
                    context: context, object: company, properties: properties);
              },
              onDoneButtonPressed: () => _onDoneButtonPressed(context),
            ),
            NovaOneDetailTableItemData(
              inputWidget: InputWidgetType.EmailInput,
              title: company.email,
              subtitle: 'Email',
              iconData: Icons.email,
              iconColor: Palette.appColors[2],
              popupMenuOptions: popupMenuOptions,
              updateTitle: 'Update Email',
              updateDescription: 'Update the email of the company.',
              updateFieldHintText: 'Email',
              id: company.id,
              object: company,
              onSubmitButtonPressed: (String value) {
                final Map<UpdateObject, String> properties = {
                  UpdateObject.CompanyEmail: value
                };
                _onSubmitButtonPressed(
                    context: context, object: company, properties: properties);
              },
              onDoneButtonPressed: () => _onDoneButtonPressed(context),
            ),
            NovaOneDetailTableItemData(
              inputWidget: InputWidgetType.EmailInput,
              title: 'Tap To See Appointment Page',
              subtitle: 'Appointment Link',
              iconData: Icons.link,
              iconColor: Palette.appColors[2],
              popupMenuOptions: popupMenuOptionsCopyOnly,
              updateTitle: '',
              updateDescription: '',
              updateFieldHintText: '',
              onPressed: () {
                UrlLauncherHelper.instance.launchUrl(
                    NovaOneUrl.novaOneViewAppointmentPage(company.id)
                        .toString());
              },
              id: company.id,
              object: company,
              onSubmitButtonPressed: (String value) {},
              onDoneButtonPressed: () {},
            ),
            NovaOneDetailTableItemData(
              inputWidget: InputWidgetType.BinaryInput,
              title: company.allowSameDayAppointments ? 'Yes' : 'No',
              subtitle: 'Same Day Appointments',
              iconData: Icons.calendar_today,
              iconColor: Palette.appColors[2],
              popupMenuOptions: popupMenuOptions,
              updateTitle: 'Same Day Appointments',
              updateDescription:
                  'Allow same day appointments for this company?',
              updateFieldHintText: '',
              id: company.id,
              object: company,
              onBinaryOptionSelected: (String value) {
                final Map<UpdateObject, String> properties = {
                  UpdateObject.CompanySameDayAppointments: value
                };
                _onSubmitButtonPressed(
                    context: context, object: company, properties: properties);
              },
              onDoneButtonPressed: () => _onDoneButtonPressed(context),
              onSubmitButtonPressed: (String value) {},
            ),
            NovaOneDetailTableItemData(
              inputWidget: InputWidgetType.ListDays,
              title: 'Showing Days',
              subtitle: 'Showing Days',
              iconData: Icons.calendar_view_day,
              iconColor: Palette.appColors[2],
              popupMenuOptions: popupMenuOptions,
              updateTitle: 'Update Showing Days',
              updateDescription: 'Update the showing days of the company.',
              updateFieldHintText: '',
              id: company.id,
              checkboxListItems: _generateDaysOfTheWeekEnabled(company),
              object: company,
              onSubmitButtonPressed: (String value) {
                final Map<UpdateObject, String> properties = {
                  UpdateObject.CompanyDays: value
                };
                _onSubmitButtonPressed(
                    context: context, object: company, properties: properties);
              },
              onDoneButtonPressed: () => _onDoneButtonPressed(context),
            ),
            NovaOneDetailTableItemData(
              inputWidget: InputWidgetType.ListHours,
              title: 'Showing Hours',
              subtitle: 'Showing Hours',
              iconData: Icons.hourglass_bottom,
              iconColor: Palette.appColors[2],
              popupMenuOptions: popupMenuOptions,
              updateTitle: 'Update Showing Hours',
              updateDescription: 'Update the showing hours of the company.',
              updateFieldHintText: '',
              id: company.id,
              object: company,
              checkboxListItems: _generatHoursOfTheDayEnabled(company),
              onSubmitButtonPressed: (String value) {
                final Map<UpdateObject, String> properties = {
                  UpdateObject.CompanyHours: value
                };
                _onSubmitButtonPressed(
                    context: context, object: company, properties: properties);
              },
              onDoneButtonPressed: () => _onDoneButtonPressed(context),
            ),
            NovaOneDetailTableItemData(
              inputWidget: InputWidgetType.BinaryInput,
              title: company.autoRespondNumber ?? 'None',
              subtitle: 'Auto Respond Number',
              iconData: Icons.phone,
              iconColor: Palette.appColors[2],
              popupMenuOptions: popupMenuOptionsCopyOnly,
              updateTitle: '',
              updateDescription: '',
              updateFieldHintText: '',
              id: company.id,
              object: company,
              onSubmitButtonPressed: (String value) {
                final Map<UpdateObject, String> properties = {
                  UpdateObject.CompanyAutoRespondNumber: value
                };
                _onSubmitButtonPressed(
                    context: context, object: company, properties: properties);
              },
              onDoneButtonPressed: () => _onDoneButtonPressed(context),
            ),
            NovaOneDetailTableItemData(
              inputWidget: InputWidgetType.Multiline,
              title: 'Auto Respond Message',
              subtitle: 'Auto Respond Message',
              iconData: Icons.edit,
              iconColor: Palette.appColors[2],
              popupMenuOptions: popupMenuOptions,
              initialText: company.autoRespondText,
              updateTitle: 'Auto Respond Message',
              updateDescription:
                  'Update the auto respond message for this company.',
              updateFieldHintText: 'Auto Respond Message',
              id: company.id,
              object: company,
              onSubmitButtonPressed: (String value) {
                final Map<UpdateObject, String> properties = {
                  UpdateObject.CompanyAutoRespondText: value
                };
                _onSubmitButtonPressed(
                    context: context, object: company, properties: properties);
              },
              onDoneButtonPressed: () => _onDoneButtonPressed(context),
            ),
          ];
        } catch (error) {
          print(
              '_ObjectDetailMobilePortraitState._generateDetailTableItems: $error');
          return <NovaOneDetailTableItemData>[];
        }
      default:
        return <NovaOneDetailTableItemData>[];
    }
  }

  List<Map<String, bool>> _generateDaysOfTheWeekEnabled(Company company) {
    List<Map<String, bool>> daysOfTheWeek = [
      {'Sunday': false},
      {'Monday': false},
      {'Tuesday': false},
      {'Wednesday': false},
      {'Thursday': false},
      {'Friday': false},
      {'Saturday': false},
    ];
    final List<int> companyDaysInt = company.daysOfTheWeekEnabled
        .split(',')
        .map((String dayIndex) => int.parse(dayIndex))
        .toList();
    if (companyDaysInt.isNotEmpty) {
      companyDaysInt.forEach((int index) {
        final Map<String, bool> map = daysOfTheWeek[index];
        final String day = map.keys.first;
        map[day] = true;
      });
    }

    return daysOfTheWeek;
  }

  List<Map<String, bool>> _generatHoursOfTheDayEnabled(Company company) {
    List<Map<String, bool>> hours = [
      {'12:00 AM': false},
      {'1:00 AM': false},
      {'2:00 AM': false},
      {'3:00 AM': false},
      {'4:00 AM': false},
      {'5:00 AM': false},
      {'6:00 AM': false},
      {'7:00 AM': false},
      {'8:00 AM': false},
      {'9:00 AM': false},
      {'10:00 AM': false},
      {'11:00 AM': false},
      {'12:00 PM': false},
      {'1:00 PM': false},
      {'2:00 PM': false},
      {'3:00 PM': false},
      {'4:00 PM': false},
      {'5:00 PM': false},
      {'6:00 PM': false},
      {'7:00 PM': false},
      {'8:00 PM': false},
      {'9:00 PM': false},
      {'10:00 PM': false},
      {'11:00 PM': false},
    ];
    final List<int> companyHoursInt = company.hoursOfTheDayEnabled
        .split(',')
        .map((String dayIndex) => int.parse(dayIndex))
        .toList();
    if (companyHoursInt.isNotEmpty) {
      companyHoursInt.forEach((int index) {
        final Map<String, bool> map = hours[index];
        final String hour = map.keys.first;
        map[hour] = true;
      });
    }

    return hours;
  }
}
