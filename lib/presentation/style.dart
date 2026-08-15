import 'package:flutter/material.dart';

const EdgeInsets pageInset = EdgeInsets.only(left: 20, right: 30, top: 20);

const Color backgroundColor = Color(0xFF0E0D0E);
const Color foregroundColor = Color(0xFFFFFFFF);
const Color secondaryColor = Color(0xFF9D9D9D);
const Color greenColor = Color(0xFF00BF60);
const Color accentColor = Color(0xFF5946B2);
const Color accentShadowColor = Color(0xBF5947AD);

const double minFontSize = 14;
const double smallFontSize = 20;
const double mediumFontSize = 24;
const double largeFontSize = 36;
const double maxFontSize = 84;

TextStyle bodyMin = const TextStyle(
  fontSize: minFontSize,
  fontWeight: FontWeight.w500,
  color: foregroundColor,
);
TextStyle bodySmall = const TextStyle(
  fontSize: smallFontSize,
  fontWeight: FontWeight.w500,
  color: foregroundColor,
);
TextStyle bodyMedium = const TextStyle(
  fontSize: mediumFontSize,
  fontWeight: FontWeight.w500,
  color: foregroundColor,
);
TextStyle bodyLarge = const TextStyle(
  fontSize: largeFontSize,
  fontWeight: FontWeight.w500,
  color: foregroundColor,
);
TextStyle bodyMax = const TextStyle(
  fontSize: maxFontSize,
  fontWeight: FontWeight.w500,
  color: foregroundColor,
);

TextStyle bodyMinGreen = const TextStyle(
  fontSize: minFontSize,
  fontWeight: FontWeight.w500,
  color: greenColor,
);
TextStyle bodySmallGreen = const TextStyle(
  fontSize: smallFontSize,
  fontWeight: FontWeight.w500,
  color: greenColor,
);
TextStyle bodyMediumGreen = const TextStyle(
  fontSize: mediumFontSize,
  fontWeight: FontWeight.w500,
  color: greenColor,
);

TextStyle bodyMinGrey = const TextStyle(
  fontSize: minFontSize,
  fontWeight: FontWeight.w500,
  color: secondaryColor,
);
const bodySmallGrey = TextStyle(
  fontSize: smallFontSize,
  fontWeight: FontWeight.w500,
  color: secondaryColor,
);
const bodyMediumGrey = TextStyle(
  fontSize: mediumFontSize,
  fontWeight: FontWeight.w500,
  color: secondaryColor,
);
TextStyle bodyLargeGrey = const TextStyle(
  fontSize: largeFontSize,
  color: secondaryColor,
  fontWeight: FontWeight.w500,
);
