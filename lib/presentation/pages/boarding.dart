import 'package:flutter/gestures.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:url_launcher/url_launcher.dart';

import '../style.dart';
import '../widgets/auth.dart';
import 'package:flutter/material.dart';

class BoardingPage extends StatelessWidget {
  const BoardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final height = constraints.maxHeight;
        final width = constraints.maxWidth;

        return Material(
          child: Padding(
            padding: pageInset,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: height / 5),
                  child: Row(
                    spacing: 15.0,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.access_time, size: 48, color: colors.primary),
                      Text(
                        'Chrono',
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.w500,
                          color: colors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: height / 5),
                  child: Text(
                    'Welcome to Chrono',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w500,
                      color: colors.primary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Text(
                  'Start tracking your study habits for a more mindful studying experience.',
                  style: bodyMin.copyWith(color: colors.secondary),
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Column(
                    children: <SizedBox>[
                      SizedBox(
                        height: height / 15,
                        width: width,
                        child: AuthButton(title: 'Login', route: 'Login'),
                      ),
                      SizedBox(
                        height: height / 15,
                        width: width,
                        child: AuthButton(
                          title: 'Sign Up',
                          route: 'Register',
                          inverted: true,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: height / 20),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: bodyMin.copyWith(color: colors.secondary),
                          children: <TextSpan>[
                            TextSpan(text: 'By continuing you agree to the '),
                            TextSpan(
                              text: 'Privacy Policy',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: colors.primary,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () async {
                                  final url = Uri.parse(
                                    '${dotenv.get('SITE_URL')}/privacy',
                                  );
                                  await launchUrl(url);
                                },
                            ),
                            TextSpan(text: ' and '),
                            TextSpan(
                              text: 'User Terms',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: colors.primary,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () async {
                                  final url = Uri.parse(
                                    '${dotenv.get('SITE_URL')}/terms',
                                  );
                                  await launchUrl(url);
                                },
                            ),
                          ],
                        ),
                      ),
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
