import 'package:flutter/material.dart';

extension ColorExtension on Color {
  Color lighten([double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(this);
    final hslLight = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));
    return hslLight.toColor();
  }

  Color contrast() {
    double luminance = computeLuminance();
    return luminance > 0.5 ? Colors.black : Colors.white;
  }
}
