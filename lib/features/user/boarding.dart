import 'package:flutter/material.dart';
import 'package:study_app/features/user/login.dart';
import 'package:study_app/features/user/register.dart';

const Color backgroundColor = Color(0xFF151515);
const Color foregroundColor = Color(0xFF5946B2);

const subtitleStyle = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.w500,
  color: Colors.white60,
);

class AuthButton extends StatelessWidget {
  final String feature;

  const AuthButton({super.key, required this.feature});

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                (feature == 'Login' ? LoginPage() : RegisterPage()),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: feature == 'Login' ? foregroundColor : backgroundColor,
          border: BoxBorder.all(color: foregroundColor, width: 2.5),
          borderRadius: BorderRadius.circular(10),
        ),
        height: 50,
        width: 300,
        child: Center(
          child: Text(
            feature,
            style: TextStyle(
              color: feature == 'Login' ? backgroundColor : foregroundColor,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

class BoardingPage extends StatelessWidget {
  const BoardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 540.0),
            child: Text(
              'Welcome to Chrono',
              style: TextStyle(
                fontSize: 32,
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
              'Track your study sessions. Watch your progress add up.',
              style: subtitleStyle,
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              spacing: 15.0,
              children: [
                AuthButton(feature: 'Login'),
                AuthButton(feature: 'Sign Up'),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 50.0, right: 50.0),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: subtitleStyle,
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
