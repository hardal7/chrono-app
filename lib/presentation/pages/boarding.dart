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
            padding: EdgeInsets.only(top: screenHeight / 20),
            child: Row(
              spacing: 15.0,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.access_time, size: 40, color: accentColor),
                Text(
                  'Chrono',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w500,
                    color: accentColor,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: screenHeight / 8),
            child: Text(
              'Welcome to Chrono',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w500,
                color: accentColor,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: screenWidth / 30,
              right: screenWidth / 30,
            ),
            child: Text(
              'Start tracking your study habits for a more mindful studying experience.',
              style: bodySmall,
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              spacing: 10.0,
              children: <Widget>[
                AuthButton(title: 'Login', route: 'Login'),
                AuthButton(title: 'Sign Up', route: 'Register', inverted: true),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: screenWidth / 100,
              right: screenWidth / 100,
            ),
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
                      color: accentColor,
                    ),
                  ),
                  TextSpan(text: ' and '),
                  TextSpan(
                    text: 'User Terms',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: accentColor,
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
