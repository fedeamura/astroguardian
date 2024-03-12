import 'dart:async';

import 'package:astro_guardian/game/border.dart';
import 'package:astro_guardian/game/util/lerp.dart';
import 'package:astro_guardian/game_hud/game_hud.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:model/model.dart';

class HudExperienceComponent extends PositionComponent with HasGameRef<GameHudComponent> {
  late BorderComponent _borderComponent;
  late RectangleComponent _component;

  double get _anim => 0.2;

  bool _visible = false;
  bool _first = true;

  @override
  FutureOr<void> onLoad() async {
    anchor = Anchor.center;
    _visible = _calculateVisibility();

    _borderComponent = BorderComponent(
      gameScaleProvider: () => game.gameComponent.gameScale,
    );
    await add(_borderComponent);

    _component = RectangleComponent();
    await add(_component);

    if (!_visible) {
      scale = Vector2.all(0.7);
      _borderComponent.opacity = 0.0;
      _component.opacity = 0.0;
    }

    return super.onLoad();
  }

  double? _w;

  @override
  void update(double dt) {
    super.update(dt);

    _updateSize(dt);
    _updateVisibility(dt);
  }

  _updateSize(double dt) {
    final scale = game.gameComponent.gameScale;
    final padding = 4.0 * scale;
    final p = game.gameComponent.paddingProvider();

    final s = Vector2(40 * scale, 6 * scale);
    size = s;
    _borderComponent.size = s;
    _borderComponent.position = Vector2(0, 0);

    if (_first) {
      _first = false;
      position.x = p.left + padding + s.x * 0.5 + 7 * scale;
    }

    final px = LerpUtils.d(
      dt,
      target: p.left + padding + s.x * 0.5 + 7 * scale,
      value: position.x,
      time: 0.1,
    );

    position = Vector2(
      px,
      p.top + padding + 7 * scale + s.y * 0.5,
    );

    final percentage = game.gameComponent.game.experiencePercentage;
    _component.paint = Paint()..color = Colors.amber;
    _component.position = _borderComponent.position + Vector2.all(scale * 2);

    var w = _w ?? _calculateContentWidth(percentage);
    w = LerpUtils.d(
      dt,
      target: _calculateContentWidth(percentage),
      value: w,
      time: _anim,
    );
    _w = w;

    _component.size = Vector2(
      w,
      (s - Vector2.all(scale * 4)).y,
    );
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
    _component.opacity = opacityValue;
  }

  double _calculateContentWidth(double p) {
    final scale = game.gameComponent.gameScale;
    return ((40 * scale) - (scale * 4)) * p;
  }

  bool _calculateVisibility() {
    if (!game.gameComponent.game.tutorial) return true;
    final conversations = game.gameComponent.game.conversations;
    return conversations[ConversationType.tutorialRecycle] == true;
  }
}
