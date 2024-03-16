import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:novaone/constants.dart';
import 'package:novaone/screens/login/bloc/login_bloc.dart';
import 'package:novaone/utils/utils.dart';
import 'package:novaone/widgets/widgets.dart';
import 'package:novaone/extensions/extensions.dart';

class LoginTabletPortrait extends StatefulWidget {
  @override
  _LoginTabletPortraitState createState() => _LoginTabletPortraitState();
}

class _LoginTabletPortraitState extends State<LoginTabletPortrait> {
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();
  FocusNode _focusNodeEmail = new FocusNode();
  FocusNode _focusNodePassWord = new FocusNode();

  // The user's email
  String? email;

  // The user's password
  String? password;

  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(defaultPadding),
      child: Center(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              const SizedBox(height: 40),
              Text(
                'Hello World',
                style: Theme.of(context).textTheme.headline1!.copyWith(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              const SizedBox(
                height: 7,
              ),
              Text(
                'Sign in to continue!',
                style: Theme.of(context).textTheme.headline3!.copyWith(
                    color: Colors.grey[400],
                    fontWeight: FontWeight.bold,
                    fontSize: 24),
              ),
              const SizedBox(
                height: 40,
              ),
              Image(
                image: AssetImage(logoImage),
                width: 160,
                height: 160,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.10,
              ),
              EnsureVisibleWhenFocused(
                focusNode: _focusNodeEmail,
                child: NovaOneTextInput(
                  focusNode: _focusNodeEmail,
                  maxLines: 1,
                  onChanged: (value) {
                    setState(() {
                      email = value;
                    });
                  },
                  controller: emailController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (email) {
                    if (email != null) {
                      if (email.isValidEmail) {
                        return null;
                      }
                    }

                    return 'Please enter a valid email';
                  },
                  border: Border.all(color: Colors.grey[300]!, width: 2),
                  keyboardType: TextInputType.emailAddress,
                  hintText: 'Your Email',
                  labelText: 'Email Address',
                  textAlign: TextAlign.left,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              EnsureVisibleWhenFocused(
                focusNode: _focusNodePassWord,
                child: NovaOneTextInput(
                  focusNode: _focusNodePassWord,
                  maxLines: 1,
                  onChanged: (value) {
                    setState(() {
                      password = value;
                    });
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (password) {
                    if (password != null) {
                      return password.isEmpty
                          ? 'Please enter a password'
                          : null;
                    }
                    return 'Please enter a password';
                  },
                  controller: passwordController,
                  border: Border.all(color: Colors.grey[300]!, width: 2),
                  keyboardType: TextInputType.visiblePassword,
                  hintText: 'Your Password',
                  obscureText: true,
                  labelText: 'Password',
                  textAlign: TextAlign.left,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'Forgot your password?',
                style: Theme.of(context)
                    .textTheme
                    .bodyText2!
                    .copyWith(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 40,
              ),
              NovaOneButton(
                key: Key(Keys.instance.loginButton),
                onPressed: () {
                  // First check if fields are empty before submitting request to API
                  if (_formKey.currentState!.validate()) {
                    BlocProvider.of<LoginBloc>(context).add(LoginButtonTapped(
                        email: emailController.text,
                        password: passwordController.text));
                  }
                },
                title: 'Login',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginTabletLandscape extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Center(child: Text('Login Screen')),
      ],
    );
  }
}
