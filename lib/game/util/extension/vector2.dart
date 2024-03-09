import 'dart:ui';

import 'package:flame/components.dart';
import 'package:model/model.dart';

extension Vector2Extension on Vector2 {
  PointDouble get pointDouble {
    return PointDouble(x, y);
  }

  PointInt get pointInt {
    return PointInt(x.floor(), y.floor());
  }
}
