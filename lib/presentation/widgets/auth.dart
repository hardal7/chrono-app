import '../../handler/auth.dart';
import '../pages/home.dart';
import '../pages/login.dart';
import '../pages/register.dart';
import '../pages/resetPassword.dart';
import '../style.dart';
import 'package:flutter/material.dart';

class AuthButton extends StatelessWidget {
  const AuthButton({
    super.key,
    required this.title,
    required this.route,
    this.inverted = false,
    this.onPressed,
  });
  final String title;
  final String route;
  final bool inverted;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        onPressed?.call();
        // TODO: implement server response
        bool success = true;
        if (success) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => route == 'Register'
                  ? RegisterPage()
                  : route == 'Login'
                  ? LoginPage()
                  : route == 'Home'
                  ? HomePage()
                  : PasswordResetPage(),
            ),
          );
        } else {
          // TODO: Display wrong password error
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: inverted ? backgroundColor : accentColor,
          border: BoxBorder.all(color: accentColor, width: 2.5),
          borderRadius: BorderRadius.circular(10),
        ),
        width: screenWidth,
        height: screenHeight / 40,
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: inverted ? accentColor : backgroundColor,
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
  const ThirdPartyAuthButton({super.key, required this.feature});
  final String feature;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        bool success = (feature == 'Google' ? googleAuth() : appleAuth());
        if (success) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (BuildContext context) => HomePage()),
            (route) => false,
          );
        } else {
          // TODO: Display Oauth error
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          border: BoxBorder.all(color: accentColor, width: 2.5),
          borderRadius: BorderRadius.circular(10),
        ),
        width: screenWidth / 10,
        height: screenHeight / 30,
        child: Center(
          child: ImageIcon(
            AssetImage(
              feature == 'Google'
                  ? 'assets/icons/google.png'
                  : 'assets/icons/apple.png',
            ),
            size: 24,
            color: Colors.white60,
          ),
        ),
      ),
    );
  }
}

class InputField extends StatelessWidget {
  const InputField({
    super.key,
    required this.fieldName,
    required this.controller,
  });
  final String fieldName;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(
            left: screenWidth / 20,
            right: screenWidth / 20,
          ),
          child: Container(
            width: screenWidth,
            decoration: BoxDecoration(
              border: BoxBorder.all(color: accentColor),
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            child: TextFormField(
              controller: controller,
              style: bodySmall,
              decoration: InputDecoration(
                hintText: fieldName,
                hintStyle: bodySmall,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: accentColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: accentColor),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
