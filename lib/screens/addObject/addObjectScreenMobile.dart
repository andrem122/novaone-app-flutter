import 'package:flutter/material.dart';
import 'package:novaone/constants.dart';
import 'package:novaone/utils/utils.dart';
import 'package:novaone/widgets/widgets.dart';

class AddObjectScreenMobilePortrait extends StatefulWidget {
  const AddObjectScreenMobilePortrait(
      {Key? key,
      required this.fields,
      required this.appBarTitle,
      required this.onSubmitPressed})
      : super(key: key);

  /// The fields needed to create the form
  final List<Widget> fields;

  /// The title used for the app bar
  final String appBarTitle;

  /// The function that is called when the submit button is pressed
  ///
  /// This function will ONLY be called if all required fields are validated
  final Function() onSubmitPressed;

  @override
  State<AddObjectScreenMobilePortrait> createState() =>
      _AddObjectScreenMobilePortraitState();
}

class _AddObjectScreenMobilePortraitState
    extends State<AddObjectScreenMobilePortrait> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          NovaOneAppBar(
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            trailing: const SizedBox(
              width: 43,
            ),
            title: widget.appBarTitle,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                constraints: BoxConstraints(maxWidth: 800),
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: appHorizontalSpacing),
                    child: Column(
                      children: <Widget>[
                        const SizedBox(
                          height: appVerticalSpacing,
                        ),
                        ListView(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          children: widget.fields,
                        ),
                        const SizedBox(
                          height: appVerticalSpacing,
                        ),
                        RichText(
                          text: TextSpan(
                              text: 'Fields marked with a ',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  ?.copyWith(fontSize: 17),
                              children: [
                                TextSpan(
                                  text: '*',
                                  style: TextStyle(
                                    color: Colors.red,
                                  ),
                                ),
                                TextSpan(text: ' are required.')
                              ]),
                        ),
                        const SizedBox(
                          height: appVerticalSpacing,
                        ),
                        NovaOneButton(
                          key: Key(Keys.instance.addObjectButton),
                          onPressed: () {
                            /// If the form has been filled out correctly, then call the [widget.onSubmitPressed] function
                            if (_formKey.currentState!.validate()) {
                              /// IMPORTANT: each [TextFormField] must have a onSaved property that is not null to make this form work
                              _formKey.currentState?.save();
                              widget.onSubmitPressed();
                            }
                          },
                          title: widget.appBarTitle,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
