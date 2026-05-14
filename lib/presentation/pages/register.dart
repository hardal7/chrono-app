import 'login.dart';
import '../style.dart';
import '../widgets/auth.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});

  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      child: Padding(
        padding: EdgeInsetsGeometry.only(
          top: screenHeight / 20,
          bottom: screenHeight / 15,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 10.0,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: screenHeight / 15),
              child: const Text(
                'Register an account',
                style: TextStyle(color: Colors.white60, fontSize: 24),
                textAlign: TextAlign.center,
              ),
            ),
            InputField(fieldName: 'Email', controller: emailController),
            InputField(fieldName: 'Username', controller: usernameController),
            InputField(fieldName: 'Password', controller: passwordController),
            Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: AuthButton(title: 'Register', route: 'Home'),
            ),
            Text(
              'Or register with',
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
