import '../style.dart';
import '../widgets/auth.dart';
import 'package:flutter/material.dart';

class BoardingPage extends StatelessWidget {
  const BoardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 75.0),
            child: Row(
              spacing: 15.0,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ImageIcon(AssetImage('assets/icon/logo.png'), size: 24),
                Text(
                  'Chrono',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w500,
                    color: foregroundColor,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 400.0),
            child: Text(
              'Welcome to Chrono',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w500,
                color: foregroundColor,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 50.0,
              right: 50.0,
              bottom: 20.0,
            ),
            child: Text(
              'Start tracking your study habits for a more mindful studying experience.',
              style: bodySmall,
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              spacing: 15.0,
              children: <Widget>[
                AuthButton(title: 'Login', route: 'Login'),
                AuthButton(title: 'Sign Up', route: 'Register', inverted: true),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 50.0, right: 50.0),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: bodySmall,
                children: <TextSpan>[
                  TextSpan(text: 'By continuing you agree to the '),
                  TextSpan(
                    text: 'Privacy Policy',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: foregroundColor,
                    ),
                  ),
                  TextSpan(text: ' and '),
                  TextSpan(
                    text: 'User Terms',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: foregroundColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
