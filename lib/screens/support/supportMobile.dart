import 'package:flutter/material.dart';
import 'package:novaone/constants.dart';
import 'package:novaone/enums/enums.dart';
import 'package:novaone/widgets/widgets.dart';

class SupportMobilePortrait extends StatefulWidget {
  const SupportMobilePortrait({Key? key}) : super(key: key);

  @override
  State<SupportMobilePortrait> createState() => _SupportMobilePortraitState();
}

class _SupportMobilePortraitState extends State<SupportMobilePortrait> {
  late TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 180,
            flexibleSpace: GradientHeader(
              child: SafeArea(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Support',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: appVerticalSpacing,
                  ),
                  Text(
                    'Get help with your account',
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        ?.copyWith(color: Colors.white, fontSize: 16),
                  ),
                ],
              )),
            ),
          ),
          SliverToBoxAdapter(
            child: InputWidget(
              inputWidgetType: InputWidgetType.TextInput,
              controller: _controller,
              hintText: 'Test',
              onCheckboxTap: (String? comapnyId) {},
            ),
          ),
        ],
      ),
    );
  }
}
