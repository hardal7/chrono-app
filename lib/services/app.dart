import 'package:flutter/material.dart';

import '../presentation/style.dart';

class AppValues {
  AppValues({
    required this.locale,
    required this.theme,
    required this.username,
  });

  Locale locale;
  ThemeData theme;
  String username;
}

ValueNotifier<AppValues> appNotifier = ValueNotifier(
  AppValues(theme: darkTheme, locale: Locale('en'), username: ''),
);
