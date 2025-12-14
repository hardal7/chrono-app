import 'package:flutter/material.dart';
import 'package:chrono/features/user/boarding.dart';
import 'package:chrono/features/user/register.dart';
import 'package:chrono/features/user/resetPassword.dart';
import 'package:chrono/style.dart';

class InputField extends StatelessWidget {
  final String fieldName;

  const InputField({super.key, required this.fieldName});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            border: BoxBorder.all(color: foregroundColor),
          ),
          child: TextFormField(
            style: bodySmall,
            decoration: InputDecoration(
              hintText: fieldName,
              hintStyle: bodySmall,
            ),
          ),
        ),
      ],
    );
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      child: Padding(
        padding: EdgeInsetsGeometry.only(left: 50.0, right: 50.0, bottom: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 10.0,
          children: [
            const Text(
              'Sign in to your account',
              style: TextStyle(color: Colors.white, fontSize: 24),
              textAlign: TextAlign.center,
            ),
            InputField(fieldName: 'Email'),
            InputField(fieldName: 'Username'),
            InputField(fieldName: 'Password'),
            InkResponse(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PasswordResetPage()),
                );
              },

              child: Text(
                'Forgot password?',
                style: labelSmall,
                textAlign: TextAlign.right,
              ),
            ),
            AuthButton(feature: 'Login'),
            Text(
              'Or login with',
              style: bodySmall,
              textAlign: TextAlign.center,
            ),
            InkResponse(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterPage()),
                );
              },
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Don\'t have an account? ',
                      style: bodySmall,
                    ),
                    TextSpan(text: 'Create an account', style: labelSmall),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
