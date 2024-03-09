import 'dart:async';

import 'package:astro_guardian/game/game.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'package:util/util.dart';

class ShipAttractionAreaComponent extends RectangleComponent with HasGameRef<GameComponent> {
  double _dt = 0;

  bool? _visible;

  OpacityEffect? _opacityEffect;


  @override
  FutureOr<void> onLoad() {
    opacity = 0.0;
    return super.onLoad();
  }

  @override
  void update(double dt) {
    _dt = (_dt + dt) % 999999;
    _updateVisibility();
    super.update(dt);
  }

  bool _calculateVisibility() {
    final particleCount = game.world.shipExperienceLayer.children.length;
    return particleCount > 0;
  }

  _updateVisibility() {
    final visible = _calculateVisibility();
    if (visible == _visible) return;
    _visible = visible;

    _opacityEffect?.removeFromParent();
    _opacityEffect = null;

    final effect = OpacityEffect.to(
      visible ? 1.0 : 0.0,
      EffectController(duration: 1.0),
      onComplete: () {
        _opacityEffect?.removeFromParent();
        _opacityEffect = null;
      },
    );
    add(effect);
    _opacityEffect = effect;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // Bag and particles attraction
    final r = game.game.ship.bagDistance;
    for (int i = 0; i < 5; i++) {
      final max = r * 0.2;
      final d = _dt * r * 0.2;
      final extra = (d % max);
      const minOpacity = 0.2;
      double opacity = minOpacity;
      if (i == 4) {
        opacity = MathRangeUtil.range(
          extra,
          0.0,
          max,
          minOpacity,
          0.0,
        );
      }

      opacity = opacity * this.opacity;

      canvas.drawCircle(
        Offset.zero,
        r * (i / 5) + extra,
        Paint()
          ..color = Colors.white.withOpacity(opacity)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.1,
      );
    }
  }
}
