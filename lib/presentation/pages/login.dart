import '../../handler/auth.dart';
import 'register.dart';
import 'resetPassword.dart';
import '../style.dart';
import '../widgets/auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  // Name controller is either for username or email
  final nameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 10.0,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
              top: screenHeight / 20,
              bottom: screenHeight / 20,
            ),
            child: const Text(
              'Login to your account',
              style: TextStyle(color: Colors.white60, fontSize: 24),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: screenHeight / 20, bottom: 10.0),
            child: InputField(
              fieldName: 'Username',
              controller: nameController,
            ),
          ),
          InputField(fieldName: 'Password', controller: passwordController),
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
            padding: EdgeInsets.only(
              top: 5.0,
              left: screenWidth / 25,
              right: screenWidth / 25,
            ),
            child: AuthButton(
              title: 'Login',
              route: 'Home',
              onPressed: () =>
                  login(nameController.text, passwordController.text),
            ),
          ),
          Text('Or login with', style: bodySmall, textAlign: TextAlign.center),
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
                  TextSpan(text: 'Don\'t have an account? ', style: bodySmall),
                  TextSpan(text: 'Register an account', style: labelSmall),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
