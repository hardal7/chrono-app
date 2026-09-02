import 'package:flutter/gestures.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../l10n/app_localizations.dart';
import '../style.dart';
import '../widgets/auth.dart';
import 'package:flutter/material.dart';

// TODO: Onboarding should be before register
class BoardingPage extends StatelessWidget {
  const BoardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Material(
      child: Padding(
        padding: pageInset,
        child: Column(
          children: [
            Spacer(flex: 5),
            Row(
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
            Spacer(flex: 8),
            Text(
              l10n.welcome,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w500,
                color: colors.primary,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              l10n.appDescription,
              style: bodyMin.copyWith(color: colors.secondary),
              textAlign: TextAlign.center,
            ),
            Expanded(
              flex: 2,
              child: AuthButton(title: l10n.login, route: 'Login'),
            ),
            Expanded(
              flex: 2,
              child: AuthButton(
                title: l10n.signup,
                route: 'Register',
                inverted: true,
              ),
            ),
            Spacer(flex: 5),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: bodyMin.copyWith(color: colors.secondary),
                children: <TextSpan>[
                  TextSpan(text: '${l10n.userNotice} '),
                  TextSpan(
                    text: l10n.privacyPolicy,
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
                  TextSpan(text: ' ${l10n.and} '),
                  TextSpan(
                    text: l10n.userTerms,
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
            Spacer(flex: 2),
          ],
        ),
      ),
    );
  }
}
