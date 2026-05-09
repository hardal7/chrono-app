import 'register.dart';
import 'resetPassword.dart';
import '../style.dart';
import '../widgets/auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      child: Padding(
        padding: EdgeInsetsGeometry.only(
          left: screenWidth / 10,
          right: screenWidth / 10,
          top: screenHeight / 8,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 10.0,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: screenHeight / 15),
              child: const Text(
                'Login to your account',
                style: TextStyle(color: Colors.white60, fontSize: 24),
                textAlign: TextAlign.center,
              ),
            ),
            InputField(fieldName: 'Email'),
            InputField(fieldName: 'Password'),
            Align(
              alignment: Alignment.center,
              child: TextButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => PasswordResetPage(),
                    ),
                    (route) => false,
                  );
                },
                child: Text('Forgot password?', style: labelSmall),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: AuthButton(title: 'Login', route: 'Home'),
            ),
            Text(
              'Or login with',
              style: bodySmall,
              textAlign: TextAlign.center,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ThirdPartyAuthButton(feature: 'Google'),
                ThirdPartyAuthButton(feature: 'Apple'),
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
