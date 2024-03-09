import 'package:flutter/animation.dart';

class MathRangeUtil {
  MathRangeUtil._();

  static multiRange(
    double value,
    List<double> originalRange,
    List<double> destRange, {
    Curve curve = Curves.linear,
  }) {
    if (value < originalRange.first || value > originalRange.last) {
      throw ArgumentError('El valor está fuera del rango de origen');
    }

    int findStartIndex() {
      if (value == originalRange.first) return 0;

      for (int i = originalRange.length - 1; i >= 0; i--) {
        final element = originalRange[i];
        if (element < value) return i;
      }

      throw ArgumentError("invalid start");
    }

    int findEndIndex() {
      for (int i = 1; i < originalRange.length; i++) {
        final element = originalRange[i];
        if (element >= value) return i;
      }

      throw ArgumentError("invalid end");
    }

    final startIndex = findStartIndex();
    final endIndex = findEndIndex();

    return range(
      value,
      originalRange[startIndex],
      originalRange[endIndex],
      destRange[startIndex],
      destRange[endIndex],
      curve: curve,
    );
  }

  static double range(
    double value,
    double originMin,
    double originMax,
    double destMin,
    double destMax, {
    Curve curve = Curves.linear,
  }) {
    double normalizedValue = (value - originMin) / (originMax - originMin);
    double curvedValue = curve.transform(normalizedValue);
    return curvedValue * (destMax - destMin) + destMin;
  }
}

extension MathRangeUtilX on double {
  double range(
    double originMin,
    double originMax,
    double destMin,
    double destMax, {
    Curve curve = Curves.linear,
  }) {
    return MathRangeUtil.range(
      this,
      originMin,
      originMax,
      destMin,
      destMax,
      curve: curve,
    );
  }
}
