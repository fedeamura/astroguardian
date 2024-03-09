import 'package:flutter/material.dart';

class GameColors {
  GameColors._();

  static Color get black => Colors.black;

  static Color get darker => _hexStringToColor("#464646");

  static Color get lighter => _hexStringToColor("#b4b4b4");

  static Color get white => Colors.white;
}

Color _hexStringToColor(String hexColor) {
  hexColor = hexColor.replaceAll("#", "");
  int hexValue = int.parse(hexColor, radix: 16);
  return Color(hexValue | 0xFF000000);
}
