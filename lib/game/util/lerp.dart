import 'dart:ui';


class LerpUtils {

  LerpUtils._();

  static double d(
    double dt, {
    required double target,
    required double value,
    required double time,
  }) {
    var t = (dt / time).clamp(0.0, 1.0);
    return lerpDouble(value, target, t) ?? target;
  }
}
