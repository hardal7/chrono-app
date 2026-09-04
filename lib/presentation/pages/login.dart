import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';

import '../../handler/user.dart';
import '../../l10n/app_localizations.dart';
import '../../main.dart';
import 'home.dart';
import 'register.dart';
import 'reset_password.dart';
import '../style.dart';
import '../widgets/auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Name controller is either for username or email
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  bool _showError = false;
  late int? _status;

  Future<void> loginOnPressed() async {
    _status = await login(nameController.text, passwordController.text);

    if (_status == HttpStatus.ok) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('username', nameController.text);
      username = nameController.text;

      if (!mounted) return;
      setState(() {
        _showError = false;
      });

      Navigator.push(
        context,
        MaterialPageRoute(builder: (BuildContext context) => HomePage()),
      );
    } else {
      setState(() {
        _showError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Material(
      child: Padding(
        padding: pageInset,
        child: Column(
          spacing: 10,
          children: [
            Spacer(flex: 8),
            Text(
              l10n.loginToYourAccount,
              style: TextStyle(color: colors.secondary, fontSize: 24),
              textAlign: TextAlign.center,
            ),
            Spacer(flex: 2),
            InputField(fieldName: l10n.username, controller: nameController),
            InputField(
              fieldName: l10n.password,
              controller: passwordController,
              obscure: true,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => PasswordResetPage(),
                      ),
                      (route) => false,
                    );
                  },
                  child: Text(l10n.forgotPassword, style: bodyMin),
                ),
              ],
            ),
            Expanded(
              flex: 2,
              child: AuthButton(
                title: l10n.login,
                onPressed: () async {
                  await loginOnPressed();
                },
              ),
            ),
            if (_showError)
              Padding(
                padding: EdgeInsets.only(left: 20),
                child: Text(switch (_status) {
                  HttpStatus.notFound => l10n.userWithCredentialsNotFound,
                  HttpStatus.unauthorized => l10n.incorrectCredentials,
                  null => l10n.serverCurrentlyDown,
                  _ => l10n.unexpectedError,
                }, style: const TextStyle(color: Colors.red)),
              ),
            Text(
              l10n.orLoginWith,
              style: bodyMin.copyWith(color: colors.secondary),
              textAlign: TextAlign.center,
            ),
            Expanded(
              flex: 3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(child: ThirdPartyAuthButton(feature: 'Google')),
                  Expanded(child: ThirdPartyAuthButton(feature: 'Apple')),
                ],
              ),
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
                  children: [
                    TextSpan(
                      text: l10n.dontHaveAnAccount,
                      style: bodyMin.copyWith(color: colors.secondary),
                    ),
                    TextSpan(text: l10n.registerAnAccount, style: bodyMin),
                  ],
                ),
              ),
            ),
            Spacer(flex: 4),
          ],
        ),
      ),
    );
  }
}
