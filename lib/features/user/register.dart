import 'package:chrono/features/user/login.dart';
import 'package:chrono/features/user/widgets.dart';
import 'package:chrono/style.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      child: Padding(
        padding: EdgeInsetsGeometry.only(left: 25.0, right: 25.0, top: 75.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 10.0,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 40.0),
              child: const Text(
                'Register an account',
                style: TextStyle(color: Colors.white60, fontSize: 24),
                textAlign: TextAlign.center,
              ),
            ),
            InputField(fieldName: 'Email'),
            InputField(fieldName: 'Username'),
            InputField(fieldName: 'Password'),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: AuthButton(title: 'Register', route: 'Home'),
            ),
            Text(
              'Or register with',
              style: bodySmall,
              textAlign: TextAlign.center,
            ),
            Row(
              spacing: 10.0,
              children: [
                ThirdPartyAuthButton(feature: 'Google'),
                ThirdPartyAuthButton(feature: 'Apple'),
              ],
            ),
            InkResponse(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Already have an account? ',
                      style: bodySmall,
                    ),
                    TextSpan(text: 'Login to account', style: labelSmall),
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
