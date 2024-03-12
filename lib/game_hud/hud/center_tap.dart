import 'dart:math' as math;

import 'package:astro_guardian/game_hud/game_hud.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

class HudCenterTapComponent extends RectangleComponent with HasGameRef<GameHudComponent>, TapCallbacks {
  @override
  void update(double dt) {
    final min = math.min(game.size.x, game.size.y);
    size = Vector2.all(min * 0.2);
    paint = Paint()..color = Colors.transparent;
    position = Vector2(
      (game.size.x - size.x) * 0.5,
      (game.size.y - size.y) * 0.5,
    );
    super.update(dt);
  }

  @override
  void onTapUp(TapUpEvent event) {
    super.onTapUp(event);

    game.gameComponent.world.shipComponent.toggleRecycle();
    game.gameComponent.keyConsumePressed = false;
  }
}
