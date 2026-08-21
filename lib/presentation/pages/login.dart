import 'dart:io';

import '../../handler/user.dart';
import 'home.dart';
import 'register.dart';
import 'reset_password.dart';
import '../style.dart';
import '../widgets/auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Name controller is either for username or email
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  bool _showError = false;
  late int? _status;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final height = constraints.maxHeight;
        final width = constraints.maxWidth;
        return Material(
          color: backgroundColor,
          child: Padding(
            padding: pageInset,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 10.0,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(vertical: height / 20),
                  child: const Text(
                    'Login to your account',
                    style: TextStyle(color: Colors.white60, fontSize: 24),
                    textAlign: TextAlign.center,
                  ),
                ),
                InputField(fieldName: 'Username', controller: nameController),
                InputField(
                  fieldName: 'Password',
                  controller: passwordController,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.only(right: 20),
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                PasswordResetPage(),
                          ),
                          (route) => false,
                        );
                      },
                      child: Text('Forgot password?', style: bodyMin),
                    ),
                  ),
                ),
                SizedBox(
                  height: height / 15,
                  width: width,
                  child: AuthButton(
                    title: 'Login',
                    onPressed: () async {
                      _status = await login(
                        nameController.text,
                        passwordController.text,
                      );
                      if (_status == HttpStatus.ok) {
                        if (!context.mounted) return;
                        _showError = false;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => HomePage(),
                          ),
                        );
                      } else {
                        setState(() {
                          _showError = true;
                        });
                      }
                    },
                  ),
                ),
                if (_showError)
                  Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Text(switch (_status) {
                      HttpStatus.notFound => 'User with credentials not found',
                      HttpStatus.unauthorized => 'Incorrect credentials',
                      null =>
                        'Server is currently down, please try again later.',
                      _ => 'An unexpected error occurred',
                    }, style: const TextStyle(color: Colors.red)),
                  ),
                Text(
                  'Or login with',
                  style: bodyMinGrey,
                  textAlign: TextAlign.center,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <SizedBox>[
                    SizedBox(
                      height: height / 10,
                      width: width / 3,
                      child: ThirdPartyAuthButton(feature: 'Google'),
                    ),
                    SizedBox(
                      height: height / 10,
                      width: width / 3,
                      child: ThirdPartyAuthButton(feature: 'Apple'),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => RegisterPage(),
                      ),
                      (route) => false,
                    );
                  },
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Don\'t have an account? ',
                          style: bodyMinGrey,
                        ),
                        TextSpan(text: 'Register an account', style: bodyMin),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
