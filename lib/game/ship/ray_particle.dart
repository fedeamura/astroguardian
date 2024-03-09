import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';

class ShipRayParticleComponent extends PositionComponent {
  final Vector2 startPosition;
  final double radius;

  ShipRayParticleComponent({
    required this.startPosition,
    required this.radius,
  });

  @override
  FutureOr<void> onLoad() async {
    position = startPosition;
    anchor = Anchor.center;
    size = Vector2.all(radius * 2);
    scale = Vector2.zero();

    add(
      ScaleEffect.to(Vector2.all(1.0), EffectController(duration: 0.2)),
    );

    add(
      TimerComponent(
        period: 0.2,
        autoStart: true,
        removeOnFinish: true,
        onTick: () {
          add(
            ScaleEffect.to(
              Vector2.zero(),
              EffectController(duration: 0.2),
              onComplete: () {
                removeFromParent();
              },
            ),
          );
        },
      ),
    );
    return super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    canvas.drawCircle(
      Offset(width * 0.5, height * 0.5),
      0.1,
      Paint()..color = Colors.white,
    );
    super.render(canvas);
  }
}
