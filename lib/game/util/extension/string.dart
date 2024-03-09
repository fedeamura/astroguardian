import 'dart:developer';
import 'dart:ui';

extension StringColorExtension on String {
  Color get color {
    return Color(int.parse("FF$this", radix: 16));
  }
}
