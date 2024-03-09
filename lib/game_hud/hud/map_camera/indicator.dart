import 'dart:async';

import 'package:astro_guardian/game/util/lerp.dart';
import 'package:astro_guardian/game_hud/game_hud.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:util/util.dart';

class HudMapIndicatorComponent extends PositionComponent with HasGameRef<GameHudComponent> {
  final CameraComponent cameraComponent;
  final Color color;
  final Vector2 Function() positionProvider;
  final bool Function() visibilityProvider;

  HudMapIndicatorComponent({
    required this.cameraComponent,
    required this.color,
    required this.positionProvider,
    required this.visibilityProvider,
  });

  @override
  FutureOr<void> onLoad() {
    anchor = Anchor.center;
    return super.onLoad();
  }

  double _dt = 0;

  @override
  void update(double dt) {
    _dt += dt;
    _updateVisibility(dt);
    _updatePosition();
    super.update(dt);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final r = size.x * 1.5;
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

      opacity = opacity * _opacity;

      canvas.drawCircle(
        Offset(size.x * 0.5, size.y * 0.5),
        r * (i / 5) + extra,
        Paint()
          ..color = color.withOpacity(opacity)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.0,
      );
    }

    canvas.drawCircle(
      Offset(size.x * 0.5, size.y * 0.5),
      size.x * 0.5,
      Paint()..color = Colors.amber.withOpacity(_opacity),
    );
  }

  double _opacity = 0.0;

  _updateVisibility(double dt) {
    final visible = _calculateVisibility();

    _opacity = LerpUtils.d(
      dt,
      target: visible ? 1.0 : 0.0,
      value: _opacity,
      time: 1.0,
    ).clamp(0.0, 1.0);

    scale = Vector2.all(LerpUtils.d(
      dt,
      target: visible ? 1.5 : 1.0,
      value: scale.x,
      time: 1.0,
    ))
      ..clamp(Vector2.zero(), Vector2.all(9999));
  }

  _updatePosition() {
    position = _calculatePosition();
    size = Vector2.all(cameraComponent.viewport.size.x * 0.1);
  }

  Vector2 _calculatePosition() {
    final pos = positionProvider();
    final projection = cameraComponent.localToGlobal(pos);
    final p = projection - cameraComponent.viewport.position;

    p.clamp(
      Vector2.zero(),
      cameraComponent.viewport.size,
    );

    return p;
  }

  bool _calculateVisibility() {
    final visible = visibilityProvider();
    if (!visible) return false;

    final pos = _calculatePosition();
    final s = cameraComponent.viewport.size;
    if (pos.x > 0 && pos.x < s.x && pos.y > 0 && pos.y < s.y) return false;

    return true;
  }
}
