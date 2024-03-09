import 'dart:math' as math;

import 'package:model/model.dart';

class OrbitUtil {
  static double getAngleByPosition(
    PointDouble position,
  ) {
    return math.atan2(position.y, position.y);
  }

  static PointDouble getPositionByAngle({
    required double eccentricity,
    required double semiMajorAxis,
    required double angle,
  }) {
    final cosAngle = math.cos(angle);
    final sinAngle = math.sin(angle);

    final distanceFromFocus = semiMajorAxis * (1.0 - eccentricity);
    final x = distanceFromFocus * cosAngle;
    final y = distanceFromFocus * sinAngle;

    return PointDouble(x, y);
  }
}
