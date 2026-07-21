import '../../handler/register.dart';
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
  bool _showPasswordError = false;
  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final height = constraints.maxHeight;
        final width = constraints.maxWidth;
        return Material(
          color: backgroundColor,
          child: Padding(
            padding: EdgeInsetsGeometry.only(
              top: height / 20,
              bottom: height / 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 10.0,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: height / 20),
                  child: const Text(
                    'Register an account',
                    style: TextStyle(color: Colors.white60, fontSize: 24),
                    textAlign: TextAlign.center,
                  ),
                ),
                InputField(fieldName: 'Email', controller: emailController),
                InputField(
                  fieldName: 'Username',
                  controller: usernameController,
                ),
                InputField(
                  fieldName: 'Password',
                  controller: passwordController,
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: 5.0,
                    left: width / 25,
                    right: width / 25,
                  ),
                  child: AuthButton(
                    title: 'Register',
                    onPressed: () async {
                      final status = await register(
                        emailController.text,
                        usernameController.text,
                        passwordController.text,
                      );
                      if (status == 201) {
                        if (!context.mounted) return;
                        Navigator.pushNamed(context, 'Home');
                      } else {
                        setState(() {
                          _showPasswordError = true;
                        });
                      }
                    },
                  ),
                ),
                // TODO: handle all register errors (username taken etc.)
                if (_showPasswordError)
                  Text('error', style: const TextStyle(color: Colors.red)),
                Text(
                  'Or register with',
                  style: bodySmall,
                  textAlign: TextAlign.center,
                ),
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
                          text: 'Already have an account? ',
                          style: bodySmall,
                        ),
                        TextSpan(text: 'Login to account', style: labelSmall),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
