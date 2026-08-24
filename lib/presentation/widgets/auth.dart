import '../../handler/oauth.dart';
import '../pages/home.dart';
import '../pages/login.dart';
import '../pages/register.dart';
import '../pages/reset_password.dart';
import '../style.dart';
import 'package:flutter/material.dart';

class AuthButton extends StatelessWidget {
  const AuthButton({
    super.key,
    required this.title,
    this.route = '',
    this.inverted = false,
    this.onPressed,
  });
  final String title;
  final String route;
  final bool inverted;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return TextButton(
      onPressed: () {
        onPressed?.call();
        if (route != '') {
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
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: inverted ? colors.surface : colors.primary,
          border: BoxBorder.all(color: colors.primary, width: 2.5),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: inverted ? colors.primary : colors.surface,
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
    final colors = Theme.of(context).colorScheme;

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
          color: colors.surface,
          border: BoxBorder.all(color: colors.primary, width: 2.5),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: ImageIcon(
            AssetImage(
              feature == 'Google'
                  ? 'assets/icons/google.png'
                  : 'assets/icons/apple.png',
            ),
            size: 24,
            color: colors.secondary,
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
    this.obscure = false,
  });
  final String fieldName;
  final TextEditingController controller;
  final bool obscure;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        border: BoxBorder.all(color: colors.primary),
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      child: TextFormField(
        controller: controller,
        style: bodyMin.copyWith(color: colors.secondary),
        obscureText: obscure,
        decoration: InputDecoration(
          hintText: fieldName,
          hintStyle: bodyMin.copyWith(color: colors.secondary),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: colors.primary),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: colors.primary),
          ),
        ),
      ),
    );
  }
}
