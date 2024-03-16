import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:novaone/constants.dart';
import 'package:novaone/enums/enums.dart';
import 'package:novaone/models/models.dart';
import 'package:novaone/palette.dart';
import 'package:novaone/screens/input/bloc/input_bloc.dart';
import 'package:novaone/screens/input/inputLayout.dart';
import 'package:novaone/screens/screens.dart';
import 'package:novaone/screens/settings/bloc/settings_bloc.dart';
import 'package:novaone/testData.dart';
import 'package:novaone/utils/utils.dart';
import 'package:novaone/widgets/widgets.dart';
import 'package:flutter/services.dart';
import 'package:novaone/extensions/extensions.dart';

class SettingsMobilePortrait extends StatefulWidget {
  final User user;

  const SettingsMobilePortrait({Key? key, required this.user})
      : super(key: key);

  @override
  _SettingsMobilePortraitState createState() => _SettingsMobilePortraitState();
}

class _SettingsMobilePortraitState extends State<SettingsMobilePortrait> {
  Widget _createPopUpMenuOptions(
      {required BuildContext context,
      required InputLayout editScreen,
      String? textToCopy}) {
    return PopupMenuButton(
      itemBuilder: (context) {
        return settingsPopupMenuOptions;
      },
      icon: Icon(Icons.more_vert),
      onSelected: (dynamic listTableItemMenuOptions) {
        if (listTableItemMenuOptions == ListTableItemMenuOptions.Edit) {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (BuildContext context) => editScreen));
        } else if (listTableItemMenuOptions == ListTableItemMenuOptions.Copy) {
          Clipboard.setData(ClipboardData(text: textToCopy));
          Scaffold.of(context).showSuccessSnackBar(
              message: 'Success! Text copied to clipboard.');
        }
      },
    );
  }

  /// The value for the toggle switch for the push notifications switch
  late bool _pushNotificationsValue = false;

  /// The value for the toggle switch for the email notifications switch
  late bool _emailNotificationsValue;

  /// The value for the toggle switch for the SMS notifications switch
  late bool _smsNotificationsValue;

  late TextEditingController _lastNameTextController;

  final String _submitButtonTitle = 'Update';

  @override
  void initState() {
    _initializeValues();
    super.initState();
  }

  @override
  void dispose() {
    _lastNameTextController.dispose();
    super.dispose();
  }

  Future<void> _initializeValues() async {
    _emailNotificationsValue = widget.user.wantsEmailNotifications;
    _smsNotificationsValue = widget.user.wantsSms;
    _lastNameTextController = TextEditingController();
  }

  _onDonebuttonPressed() {
    int count = 0;
    Navigator.of(context).popUntil((_) => count++ >= 2);
    BlocProvider.of<SettingsBloc>(context).add(SettingsStart());
  }

  @override
  Widget build(BuildContext context) {
    _lastNameTextController = TextEditingController();
    return Scaffold(
      body: Column(
        children: [
          NovaOneAppBar(
            title: 'Settings',
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(defaultPadding),
                    child: _SettingsTableSection(
                      sectionTitle: 'Account',
                      children: [
                        _SettingsTableItem(
                          title: 'Full Name',
                          subtitle: widget.user.fullName,
                          trailingWidget: _createPopUpMenuOptions(
                            context: context,
                            textToCopy: widget.user.fullName,
                            editScreen: InputLayout(
                              title: 'Update Name',
                              description: 'Type in your first and last name.',
                              hintText: 'First Name',
                              inputWidgetType: InputWidgetType.TextInput,
                              onSubmitButtonPressed: (String value) {
                                BlocProvider.of<InputBloc>(context).add(
                                    InputUpdateUser(properties: {
                                  UpdateObject.UserName: value
                                }));
                              },
                              onDoneButtonPressed: _onDonebuttonPressed,
                              extraInputs: <InputWidget>[
                                InputWidget(
                                    inputWidgetType: InputWidgetType.TextInput,
                                    controller: _lastNameTextController,
                                    hintText: 'Last Name',
                                    onCheckboxTap: (String? comapnyId) {}),
                              ],
                              submitButtonTitle: _submitButtonTitle,
                            ),
                          ),
                        ),
                        _SettingsTableItem(
                          title: 'Customer Number',
                          subtitle: '${widget.user.userId}',
                        ),
                        _SettingsTableItem(
                          title: 'Support',
                          subtitle: 'Get help with your account',
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (BuildContext context) => InputLayout(
                                title: 'Support',
                                description: 'Get help with your account',
                                hintText: 'Please describe your concerns here',
                                inputWidgetType: InputWidgetType.Multiline,
                                onSubmitButtonPressed: (String value) =>
                                    BlocProvider.of<InputBloc>(context).add(
                                        InputSupportRequestSubmitted(value)),
                                onDoneButtonPressed: () => _onDonebuttonPressed,
                                submitButtonTitle: 'Send',
                              ),
                            ),
                          ),
                          trailingWidget: Icon(Icons.arrow_forward_ios_sharp),
                        ),
                        _SettingsTableItem(
                          title: 'Password',
                          onTap: () =>
                              Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) => InputLayout(
                              title: 'Update Password',
                              description: 'Type in your new password',
                              hintText: 'Password',
                              inputWidgetType: InputWidgetType.TextInput,
                              onSubmitButtonPressed: (String value) {
                                BlocProvider.of<InputBloc>(context).add(
                                    InputUpdateUser(properties: {
                                  UpdateObject.UserPassword: value
                                }));
                              },
                              onDoneButtonPressed: _onDonebuttonPressed,
                              successSubtitle:
                                  'Your password has been successfully updated.',
                              submitButtonTitle: _submitButtonTitle,
                            ),
                          )),
                          subtitle: 'Update your current password',
                          trailingWidget: Icon(Icons.arrow_forward_ios_sharp),
                        ),
                        _SettingsTableItem(
                          title: 'Sign Out',
                          subtitle: 'Sign out of your account',
                          trailingWidget: Icon(Icons.arrow_forward_ios_sharp),
                          onTap: () => Navigator.of(context).push(
                            ModalPopup(
                              actionButtonTitle: 'Log Out',
                              title: 'Log Out?',
                              subtitle: 'Are you sure you want to log out?',
                              onActionButtonPressed: () =>
                                  BlocProvider.of<SettingsBloc>(context).add(
                                SettingsSignOutTapped(UniqueKey()),
                              ),
                            ),
                          ),
                          isLastItem: true,
                        ),
                        _SettingsTableItem(
                          title: 'Delete Account',
                          subtitle: 'Delete your account and all data',
                          trailingWidget: Icon(Icons.arrow_forward_ios_sharp),
                          onTap: () => Navigator.of(context).push(
                            ModalPopup(
                                actionButtonTitle: 'Yes',
                                title: 'Delete Your Account?',
                                subtitle:
                                    'Are you sure you want to delete your account? All of your data will be lost forever.',
                                onActionButtonPressed: () {}),
                          ),
                          isLastItem: true,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(defaultPadding),
                    child: _SettingsTableSection(
                      sectionTitle: 'Contact',
                      children: <Widget>[
                        _SettingsTableItem(
                          subtitle: StringFormatter.instance
                              .formatPhoneNumberForDisplay(
                                  widget.user.phoneNumber),
                          title: 'Phone Number',
                          isFirstItem: true,
                          trailingWidget: _createPopUpMenuOptions(
                            context: context,
                            textToCopy: StringFormatter.instance
                                .formatPhoneNumberForDisplay(
                                    widget.user.phoneNumber),
                            editScreen: InputLayout(
                              title: 'Edit Phone Number',
                              description: 'Type in your new phone number.',
                              hintText: 'Phone Number',
                              inputWidgetType: InputWidgetType.PhoneInput,
                              onSubmitButtonPressed: (String value) {
                                BlocProvider.of<InputBloc>(context).add(
                                    InputUpdateUser(properties: {
                                  UpdateObject.UserPhone: value
                                }));
                              },
                              onDoneButtonPressed: _onDonebuttonPressed,
                              submitButtonTitle: _submitButtonTitle,
                            ),
                          ),
                        ),
                        _SettingsTableItem(
                            subtitle: widget.user.email,
                            title: 'Email',
                            isLastItem: true,
                            trailingWidget: _createPopUpMenuOptions(
                              context: context,
                              textToCopy: widget.user.email,
                              editScreen: InputLayout(
                                title: 'Edit Email',
                                description: 'Type in your new email.',
                                hintText: 'Email Address',
                                inputWidgetType: InputWidgetType.EmailInput,
                                onSubmitButtonPressed: (String value) {
                                  BlocProvider.of<InputBloc>(context).add(
                                      InputUpdateUser(properties: {
                                    UpdateObject.UserEmail: value
                                  }));
                                },
                                onDoneButtonPressed: _onDonebuttonPressed,
                                submitButtonTitle: _submitButtonTitle,
                              ),
                            )),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(defaultPadding),
                    child: _SettingsTableSection(
                      sectionTitle: 'Notifications',
                      children: <Widget>[
                        _SettingsTableItem(
                          subtitle: 'Enable or disable SMS notifications',
                          title: 'SMS Notifications',
                          isFirstItem: true,
                          trailingWidget: Switch(
                              value: _smsNotificationsValue,
                              onChanged: (bool value) {
                                setState(() {
                                  _smsNotificationsValue = value;
                                });

                                BlocProvider.of<SettingsBloc>(context).add(
                                    SettingsNotificationItemTapped(
                                        settingsNotificationItem:
                                            SettingsNotificationItem.SMS,
                                        settingsNotificationItemValue: value));
                              }),
                        ),
                        _SettingsTableItem(
                          subtitle: 'Enable or disable email notifications',
                          title: 'Email Notifications',
                          trailingWidget: Switch(
                              value: _emailNotificationsValue,
                              onChanged: (bool value) {
                                setState(() {
                                  _emailNotificationsValue = value;
                                });

                                BlocProvider.of<SettingsBloc>(context).add(
                                    SettingsNotificationItemTapped(
                                        settingsNotificationItem:
                                            SettingsNotificationItem.Email,
                                        settingsNotificationItemValue: value));
                              }),
                        ),
                        _SettingsTableItem(
                          subtitle: 'Enable or disable push notifications',
                          title: 'Push Notifications',
                          isLastItem: true,
                          trailingWidget: Switch(
                              value: _pushNotificationsValue,
                              onChanged: (bool value) {
                                setState(() {
                                  _pushNotificationsValue = value;
                                });

                                BlocProvider.of<SettingsBloc>(context).add(
                                    SettingsNotificationItemTapped(
                                        settingsNotificationItem:
                                            SettingsNotificationItem
                                                .PushNotification,
                                        settingsNotificationItemValue: value));
                              }),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// A section of the settings table
///
/// Takes in a required [sectionTitle] for each section
/// and some [children] to fill up the section of the table
class _SettingsTableSection extends StatelessWidget {
  const _SettingsTableSection({
    Key? key,
    required this.sectionTitle,
    required this.children,
  }) : super(key: key);

  final List<Widget> children;
  final String sectionTitle;

  @override
  Widget build(BuildContext context) {
    return RoundedContainer(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(
            height: spaceBetweenSettingsItems,
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: defaultPadding, bottom: defaultPadding),
            child: Text(
              sectionTitle.toUpperCase(),
              style: Theme.of(context).textTheme.headline3!.copyWith(
                  color: Palette.primaryColor,
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ]..addAll(children),
      ),
    );
  }
}

/// A table item that goes into a table section
///
/// [isLastItem] will give the InkWell a rounded border for the bottom left and bottom right border radii
/// [isFirstItem] will give the InkWell a rounded border for the top left and top right border radii
class _SettingsTableItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget? trailingWidget;
  final Function()? onTap;
  final bool isLastItem;
  final bool isFirstItem;

  const _SettingsTableItem(
      {Key? key,
      required this.title,
      required this.subtitle,
      this.trailingWidget,
      this.onTap,
      this.isLastItem = false,
      this.isFirstItem = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    BorderRadius? itemBorderRadius;
    if (isFirstItem) {
      itemBorderRadius = BorderRadius.only(
          topLeft: Radius.circular(borderRadius),
          topRight: Radius.circular(borderRadius));
    } else if (isLastItem) {
      itemBorderRadius = BorderRadius.only(
          bottomLeft: Radius.circular(borderRadius),
          bottomRight: Radius.circular(borderRadius));
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: itemBorderRadius,
        onTap: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(title,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2!
                          .copyWith(fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(
                    height: 6,
                  ),
                  Text(
                    subtitle,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2
                        ?.copyWith(fontSize: 15),
                  ),
                ],
              ),
            ),
            if (trailingWidget != null) trailingWidget!,
          ],
        ),
      ),
    );
  }
}
