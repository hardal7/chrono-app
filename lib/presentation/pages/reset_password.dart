import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

class PasswordResetPage extends StatelessWidget {
  const PasswordResetPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Text(l10n.resetPassword);
  }
}
