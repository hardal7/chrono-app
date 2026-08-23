import 'package:flutter/material.dart';

final ValueNotifier<ThemeData> themeNotifier = ValueNotifier(darkTheme);

final darkTheme = ThemeData(
  colorScheme: ColorScheme(
    surface: _backgroundColor,
    onSurface: _foregroundColor,
    primary: _accentColor,
    onPrimary: _foregroundColor,
    secondary: _secondaryColor,
    onSecondary: _foregroundColor,
    error: Colors.red,
    onError: Colors.black,
    shadow: _accentShadowColor,
    brightness: Brightness.dark,
  ),
);

final lighTheme = ThemeData(
  colorScheme: ColorScheme(
    surface: _backgroundColorLight,
    onSurface: _foregroundColorLight,
    primary: _accentColorLight,
    onPrimary: _backgroundColorLight,
    secondary: _secondaryColorLight,
    onSecondary: _backgroundColorLight,
    error: Colors.red,
    onError: Colors.black,
    shadow: _accentShadowColorLight,
    brightness: Brightness.light,
  ),
);

const Color _backgroundColor = Color(0xFF0E0D0E);
const Color _foregroundColor = Color(0xFFFFFFFF);
const Color _accentColor = Color(0xFF5946B2);
const Color _accentShadowColor = Color(0xBF5947AD);
const Color _secondaryColor = Color(0xFF9D9D9D);

const Color _backgroundColorLight = Color(0xFFFFFFFF);
const Color _foregroundColorLight = Color(0xFF0E0D0E);
const Color _accentColorLight = Color(0xFF31B1EC);
const Color _accentShadowColorLight = Color(0xFF31B1EC);
const Color _secondaryColorLight = Color(0xFF9D9D9D);

const Color greenColor = Color(0xFF00BF60);

const FontWeight _w = FontWeight.w500;

const TextStyle bodyMin = TextStyle(fontSize: 14, fontWeight: _w);
const TextStyle bodySmall = TextStyle(fontSize: 20, fontWeight: _w);
const TextStyle bodyMedium = TextStyle(fontSize: 24, fontWeight: _w);
const TextStyle bodyLarge = TextStyle(fontSize: 36, fontWeight: _w);
const TextStyle bodyMax = TextStyle(fontSize: 84, fontWeight: _w);

const EdgeInsets pageInset = EdgeInsets.only(left: 20, right: 30, top: 20);
