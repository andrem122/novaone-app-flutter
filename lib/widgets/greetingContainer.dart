import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:novaone/constants.dart';
import 'package:novaone/enums/enums.dart';
import 'package:novaone/models/user.dart';
import 'package:novaone/palette.dart';
import 'package:novaone/screens/input/bloc/input_bloc.dart';
import 'package:novaone/screens/screens.dart';
import 'package:novaone/widgets/whiteButton.dart';
import 'package:novaone/widgets/widgets.dart';

class GreetingContainer extends StatelessWidget {
  const GreetingContainer(
      {Key? key, this.user, required this.containerDecimalHeight})
      : super(key: key);

  final User? user;
  final double containerDecimalHeight;

  String get currentWeekDay {
    DateTime date = DateTime.now();
    return DateFormat('EEEE').format(date);
  }

  String? get greetingMessage {
    if (user != null) {
      return 'Hello ${user!.firstName}! It\'s $currentWeekDay, and you have 200 leads.';
    }
    return null;
  }

  _onDonebuttonPressed(BuildContext context) {
    int count = 0;
    Navigator.of(context).popUntil((_) => count++ >= 2);
  }

  @override
  Widget build(BuildContext context) {
    return GradientHeader(
      child: SafeArea(
        top: false,
        bottom: false,
        child: Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: 600),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    user != null
                        ? CircleAvatar(
                            backgroundColor: Palette.secondaryColor,
                            radius: 24,
                            child: Text(
                              user!.firstName[0],
                              style:
                                  TextStyle(color: Colors.white, fontSize: 22),
                            ),
                          )
                        : ShimmerLoading(
                            child: CircleAvatar(
                            radius: 24,
                          )),
                    user != null
                        ? WhiteButton(
                            buttonText: 'Get Help',
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      InputLayout(
                                    title: 'Support',
                                    description: 'Get help with your account',
                                    hintText:
                                        'Please describe your concerns here',
                                    inputWidgetType: InputWidgetType.Multiline,
                                    onSubmitButtonPressed: (String value) =>
                                        BlocProvider.of<InputBloc>(context).add(
                                            InputSupportRequestSubmitted(
                                                value)),
                                    onDoneButtonPressed: () =>
                                        _onDonebuttonPressed(context),
                                    submitButtonTitle: 'Send',
                                  ),
                                ),
                              );
                            },
                          )
                        : ShimmerLoading(
                            child: WhiteButton(
                              buttonText: 'Get Help',
                            ),
                          ),
                  ],
                ),
                const SizedBox(height: 40),
                user != null
                    ? Text(
                        greetingMessage!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      )
                    : Column(
                        children: <Widget>[
                          ShimmerLoading(
                              child: RoundedContainer(
                            width: 300,
                            height: 30,
                          )),
                          const SizedBox(
                            height: appVerticalSpacing,
                          ),
                          ShimmerLoading(
                              child: RoundedContainer(
                            width: 250,
                            height: 30,
                          ))
                        ],
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
