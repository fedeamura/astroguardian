import 'dart:async';
import 'dart:ui' as ui;

import 'package:astro_guardian/game/border.dart';
import 'package:astro_guardian/game/util/lerp.dart';
import 'package:astro_guardian/game/util/painter/image.dart';
import 'package:astro_guardian/game_hud/game_hud.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:model/model.dart';

class HudMenuButtonComponent extends PositionComponent with HasGameRef<GameHudComponent>, TapCallbacks {
  late BorderComponent _borderComponent;
  late ui.Image _imageMenu;
  late ui.Image _imageExclamation;

  late SpriteComponent _spriteComponent;

  bool _visible = false;

  @override
  FutureOr<void> onLoad() async {
    anchor = Anchor.center;
    _visible = _calculateVisibility();

    _imageMenu = ImagePainterUtil.drawPixelsString(
      paint: ui.Paint()..color = Colors.white,
      data: '''
      .........
      .........
      ..xxxxx..
      .........
      ..xxxxx..
      .........
      ..xxxxx..
      .........
      .........
      ''',
    );

    _imageExclamation = ImagePainterUtil.drawPixelsString(
      paint: ui.Paint()..color = Colors.white,
      data: '''
      .........
      ...xxx...
      ...xxx...
      ...xxx...
      ...xxx...
      .........
      ...xxx...
      ...xxx...
      .........
      ''',
    );

    _borderComponent = BorderComponent(
      gameScaleProvider: () => game.gameComponent.gameScale,
    );
    await add(_borderComponent);

    _spriteComponent = SpriteComponent(
      sprite: Sprite(
        _imageMenu,
        srcSize: Vector2.all(9),
      ),
    );
    await add(_spriteComponent);

    if (!_visible) {
      _borderComponent.opacity = 0.0;
      _spriteComponent.opacity = 0.0;
      scale = Vector2.all(0.7);
    }
    return super.onLoad();
  }

  @override
  void update(double dt) {
    _updateSize(dt);
    _updateVisibility(dt);
    _updateIcon();
    super.update(dt);
  }

  _updateSize(double dt) {
    final scale = game.gameComponent.gameScale;
    final padding = 4.0 * scale;
    final p = game.gameComponent.paddingProvider();

    final s = Vector2(8 * scale, 8 * scale);
    size = s;
    _borderComponent.size = s;
    _borderComponent.position = Vector2.all(0);

    position = Vector2(
      p.left + padding + s.x * 0.5,
      p.top + padding + s.y * 0.5,
    );

    _spriteComponent.size = s - Vector2.all(scale * 4);
    _spriteComponent.position = Vector2.all(scale * 2);
  }

  _updateVisibility(double dt) {
    _visible = _calculateVisibility();

    final scaleValue = LerpUtils.d(
      dt,
      target: _visible ? 1.0 : 0.7,
      value: scale.x,
      time: 0.1,
    ).clamp(0.0, 10.0);
    scale = Vector2.all(scaleValue);

    final opacityValue = LerpUtils.d(
      dt,
      target: _visible ? 1.0 : 0.0,
      value: _borderComponent.opacity,
      time: 0.1,
    ).clamp(0.0, 1.0);

    _borderComponent.opacity = opacityValue;
    _spriteComponent.opacity = opacityValue;
  }

  _updateIcon() {
    final withPoints = game.gameComponent.game.ship.pendingAbilityPoints > 0;
    if (withPoints) {
      _borderComponent.backgroundColor = Colors.amber;
      _spriteComponent.sprite = Sprite(_imageExclamation, srcSize: Vector2.all(9));
    } else {
      _borderComponent.backgroundColor = Colors.black;
      _spriteComponent.sprite = Sprite(_imageMenu, srcSize: Vector2.all(9));
    }
  }

  @override
  void onTapUp(TapUpEvent event) {
    game.menuCallback?.call();
    super.onTapUp(event);
  }

  bool _calculateVisibility() {
    if (!game.gameComponent.game.tutorial) return true;
    final conversations = game.gameComponent.game.conversations;
    return conversations[ConversationType.tutorialLevelUp] == true;
  }
}
