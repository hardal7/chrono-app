import 'package:chrono/features/user/register.dart';
import 'package:chrono/features/user/resetPassword.dart';
import 'package:chrono/features/user/widgets.dart';
import 'package:chrono/style.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

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
                'Login to your account',
                style: TextStyle(color: Colors.white60, fontSize: 24),
                textAlign: TextAlign.center,
              ),
            ),
            InputField(fieldName: 'Email'),
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
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: AuthButton(title: 'Login', route: 'Home'),
            ),
            Text(
              'Or login with',
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
                    TextSpan(text: 'Register an account', style: labelSmall),
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
