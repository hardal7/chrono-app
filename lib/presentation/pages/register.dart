import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';

import '../../handler/user.dart';
import '../../l10n/app_localizations.dart';
import '../../main.dart';
import 'home.dart';
import 'login.dart';
import '../style.dart';
import '../widgets/auth.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _showError = false;
  late int? _status;
  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> registerOnPressed() async {
    _status = await register(
      emailController.text,
      usernameController.text,
      passwordController.text,
    );

    if (_status == HttpStatus.ok) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('username', usernameController.text);
      username = usernameController.text;

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
          spacing: 10.0,
          children: [
            Spacer(flex: 8),
            Text(
              l10n.registerAnAccount,
              style: TextStyle(color: colors.secondary, fontSize: 24),
              textAlign: TextAlign.center,
            ),
            Spacer(flex: 2),
            InputField(fieldName: l10n.email, controller: emailController),
            InputField(
              fieldName: l10n.username,
              controller: usernameController,
            ),
            InputField(
              fieldName: l10n.password,
              controller: passwordController,
              obscure: true,
            ),
            Expanded(
              flex: 2,
              child: AuthButton(
                title: l10n.register,
                onPressed: registerOnPressed,
              ),
            ),
            if (_showError)
              Text(switch (_status) {
                HttpStatus.conflict => l10n.userWithCredentialsAlreadyExists,
                HttpStatus.internalServerError => l10n.failedToCreateUser,
                null => l10n.serverCurrentlyDown,
                _ => l10n.unexpectedError,
              }, style: const TextStyle(color: Colors.red)),
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
                      text: l10n.alreadyHaveAnAccount,
                      style: bodyMin.copyWith(color: colors.secondary),
                    ),
                    TextSpan(text: l10n.loginToAccount, style: bodyMin),
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
