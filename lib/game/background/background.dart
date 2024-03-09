import 'dart:async';
import 'dart:math' as math;

import 'package:astro_guardian/game/game.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:model/model.dart';

class BackgroundComponent extends RectangleComponent with HasGameRef<GameComponent> {
  BackgroundComponent();

  final int _count = 3;

  final _chunks = Array<SpriteComponent>();

  @override
  FutureOr<void> onLoad() async {
    // anchor = Anchor.center;
    position = Vector2.zero();
    paint = Paint()..color = Colors.black;

    for (int y = 0; y < _count; y++) {
      for (int x = 0; x < _count; x++) {
        final c = SpriteComponent(
          sprite: Sprite(
            game.images.fromCache("background/0.png"),
          ),
        );
        await add(c);
        _chunks.put(
          PointInt(x, y),
          c,
        );
      }
    }

    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);

    size = game.camera.viewport.size;
    anchor = Anchor.center;
    position = size / 2;
    // angle = game.world.shipComponent.angle;
    scale = Vector2.all(1.0);
    paint = Paint()..color = Colors.black;

    final playerC = game.world.shipComponent.position;
    const d = 1;
    final dx = playerC.x * d;
    final dy = playerC.y * d;

    final max = math.max(size.x, size.y);
    final s = Vector2.all(max);

    for (int y = 0; y < _count; y++) {
      for (int x = 0; x < _count; x++) {
        final chunk = _chunks.getByIndex(x, y);
        if (chunk != null) {
          final p = Vector2(
                (x * s.x) + (size.x * 0.5) - (s.x * _count * 0.5),
                (y * s.y) + (size.y * 0.5) - (s.y * _count * 0.5),
              ) -
              Vector2(
                dx % s.x,
                dy % s.y,
              );

          chunk.opacity = 0.2;
          chunk.size = s;
          chunk.position = p;
        }
      }
    }
  }
}
