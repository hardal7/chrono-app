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
  });
  final String title;
  final String route;
  final bool inverted;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        bool success = route == 'Home' ? auth() : true;
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
        width: screenWidth / 1,
        height: screenWidth / 7,
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
        width: screenWidth / 4,
        height: screenHeight / 10,
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
  const InputField({super.key, required this.fieldName});
  final String fieldName;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          width: screenWidth / 1.2,
          height: screenHeight / 15,
          decoration: BoxDecoration(
            border: BoxBorder.all(color: accentColor),
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          child: TextFormField(
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
      ],
    );
  }
}
