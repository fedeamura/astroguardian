import 'dart:async';

import 'package:astro_guardian/game_hud/game_hud.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:util/util.dart';

class HudFpsComponent extends RectangleComponent with HasGameRef<GameHudComponent> {
  late TextComponent _textComponent;
  late FpsComponent _fpsComponent;

  @override
  FutureOr<void> onLoad() async {
    _fpsComponent = FpsComponent();
    await add(_fpsComponent);

    _textComponent = TextComponent(
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 10,
          fontFamily: "Pixelify",
        ),
      ),
    );
    await add(_textComponent);
    return super.onLoad();
  }

  @override
  void update(double dt) {
    final p = game.gameComponent.paddingProvider();
    final scale = game.gameComponent.gameScale;
    final padding = scale * 4;
    final debug = GameConstants.debug;
    final pos = debug ? (game.size.y - 10 - p.bottom - padding) : (game.size.y);

    paint = Paint()..color = Colors.black;
    _textComponent.text = "${_fpsComponent.fps.toStringAsFixed(0)}FPS";

    size = Vector2(
      game.size.x,
      10 + p.bottom + padding,
    );
    position = Vector2(
      0,
      pos,
    );
    _textComponent.position = Vector2(
      p.left + padding,
      padding * 0.5,
    );
    super.update(dt);
  }
}
