import 'package:chrono/features/user/auth.dart';
import 'package:chrono/features/user/home.dart';
import 'package:chrono/features/user/login.dart';
import 'package:chrono/features/user/register.dart';
import 'package:chrono/features/user/resetPassword.dart';
import 'package:chrono/style.dart';
import 'package:flutter/material.dart';

class AuthButton extends StatelessWidget {
  final String title;
  final String route;
  final bool inverted;

  const AuthButton({
    super.key,
    required this.title,
    required this.route,
    this.inverted = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => route == 'Register'
                ? RegisterPage()
                : route == 'Login'
                ? LoginPage()
                : route == 'Home'
                ? HomePage()
                : PasswordResetPage(),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: inverted ? backgroundColor : foregroundColor,
          border: BoxBorder.all(color: foregroundColor, width: 2.5),
          borderRadius: BorderRadius.circular(10),
        ),
        width: 350,
        height: 50,
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: inverted ? foregroundColor : backgroundColor,
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

class ThirdPartyAuthButton extends StatelessWidget {
  final String feature;

  const ThirdPartyAuthButton({super.key, required this.feature});

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: () {
        feature == 'Google' ? googleAuth() : appleAuth();
      },
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          border: BoxBorder.all(color: foregroundColor, width: 2.5),
          borderRadius: BorderRadius.circular(10),
        ),
        width: 175,
        height: 75,
        child: Center(
          child: ImageIcon(
            AssetImage(
              feature == 'Google'
                  ? 'assets/icon/google.png'
                  : 'assets/icon/apple.png',
            ),
            size: 24,
          ),
        ),
      ),
    );
  }
}

class InputField extends StatelessWidget {
  final String fieldName;

  const InputField({super.key, required this.fieldName});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 350.0,
          height: 50.0,
          decoration: BoxDecoration(
            border: BoxBorder.all(color: foregroundColor),
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          child: TextFormField(
            style: bodySmall,
            decoration: InputDecoration(
              hintText: fieldName,
              hintStyle: bodySmall,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: foregroundColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: foregroundColor),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
