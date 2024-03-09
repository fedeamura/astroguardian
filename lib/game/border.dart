import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import 'util/colors.dart';

class BorderComponent extends RectangleComponent {
  final double Function() gameScaleProvider;
  bool visible = true;

  Color backgroundColor = GameColors.black;

  BorderComponent({
    required this.gameScaleProvider,
  });


  @override
  FutureOr<void> onLoad() {
    paint = Paint()..color=Colors.transparent;
    opacity = 1.0;
    return super.onLoad();
  }
  @override
  void render(Canvas canvas) {
    super.render(canvas);

    if (visible) {
      final w = gameScaleProvider();

      canvas.drawRect(
        Rect.fromLTWH(0, 0, width, height),
        Paint()..color = backgroundColor.withOpacity(opacity),
      );

      // Top
      canvas.drawRect(
        Rect.fromLTWH(0, 0, width, w),
        Paint()..color = GameColors.black.withOpacity(opacity),
      );

      canvas.drawRect(
        Rect.fromLTWH(w, w, width - w * 2, w),
        Paint()..color = GameColors.white.withOpacity(opacity),
      );

      // Bottom
      canvas.drawRect(
        Rect.fromLTWH(0, height - w, width, w),
        Paint()..color = GameColors.black.withOpacity(opacity),
      );

      canvas.drawRect(
        Rect.fromLTWH(w, height - w * 2, width - w * 2, w),
        Paint()..color = GameColors.white.withOpacity(opacity),
      );

      // Left
      canvas.drawRect(
        Rect.fromLTWH(0, 0, w, height),
        Paint()..color = GameColors.black.withOpacity(opacity),
      );

      canvas.drawRect(
        Rect.fromLTWH(w, w, w, height - w * 2),
        Paint()..color = GameColors.white.withOpacity(opacity),
      );

      // Right
      canvas.drawRect(
        Rect.fromLTWH(width - w, 0, w, height),
        Paint()..color = GameColors.black.withOpacity(opacity),
      );

      canvas.drawRect(
        Rect.fromLTWH(width - w * 2, w, w, height - w * 2),
        Paint()..color = GameColors.white.withOpacity(opacity),
      );
    }
  }
}
