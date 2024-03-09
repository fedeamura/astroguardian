import 'dart:ui';

import 'package:flame/components.dart';
import 'package:model/model.dart';

extension OffsetExtension on PointDouble {
  Offset get offset {
    return Offset(x, y);
  }
}

extension PoinIntExtension on PointInt {
  Vector2 get vector2 {
    return Vector2(x.toDouble(), y.toDouble());
  }
}
