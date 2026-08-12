import 'dart:io';

import '../../handler/register.dart';
import 'home.dart';
import 'login.dart';
import '../style.dart';
import '../widgets/auth.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _showError = false;
  late int? _status;
  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final height = constraints.maxHeight;
        final width = constraints.maxWidth;
        return Material(
          color: backgroundColor,
          child: Padding(
            padding: EdgeInsetsGeometry.symmetric(vertical: height / 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 10.0,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: height / 20),
                  child: const Text(
                    'Register an account',
                    style: TextStyle(color: Colors.white60, fontSize: 24),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: InputField(
                    fieldName: 'Email',
                    controller: emailController,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: InputField(
                    fieldName: 'Username',
                    controller: usernameController,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: InputField(
                    fieldName: 'Password',
                    controller: passwordController,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 5, left: 20, right: 20),
                  child: SizedBox(
                    height: height / 15,
                    width: width,
                    child: AuthButton(
                      title: 'Register',
                      onPressed: () async {
                        _status = await register(
                          emailController.text,
                          usernameController.text,
                          passwordController.text,
                        );
                        if (_status == HttpStatus.created) {
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
                ),
                if (_showError)
                  Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Text(switch (_status) {
                      HttpStatus.conflict =>
                        'User with credentials already exists',
                      HttpStatus.internalServerError => 'Failed to create user',
                      null =>
                        'Server is currently down, please try again later.',
                      _ => 'An unexpected error occurred',
                    }, style: const TextStyle(color: Colors.red)),
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
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
                        builder: (BuildContext context) => LoginPage(),
                      ),
                      (route) => false,
                    );
                  },
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Already have an account? ',
                          style: bodySmallGrey,
                        ),
                        TextSpan(text: 'Login to account', style: bodySmall),
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
