import 'dart:async';
import 'dart:ui' as ui;
import 'dart:ui';

import 'package:astro_guardian/game/border.dart';
import 'package:astro_guardian/game/util/lerp.dart';
import 'package:astro_guardian/game_hud/game_hud.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:model/model.dart';

class HudButtonComponent extends PositionComponent with HasGameRef<GameHudComponent>, TapCallbacks {
  final Color? color;
  final Function()? callbackTapDown;
  final Function()? callbackTapUp;
  late BorderComponent _borderComponent;
  final ui.Image? image;
  final PointInt? imageSize;
  bool visible = true;

  HudButtonComponent({
    this.callbackTapDown,
    this.callbackTapUp,
    this.color,
    this.image,
    this.imageSize,
  });

  SpriteComponent? _spriteComponent;

  @override
  FutureOr<void> onLoad() async {
    anchor = Anchor.center;
    _borderComponent = BorderComponent(
      gameScaleProvider: () => game.gameComponent.gameScale,
    );
    await add(_borderComponent);

    if (image != null) {
      _spriteComponent = SpriteComponent(
        sprite: Sprite(
          image!,
          srcSize: imageSize != null ? Vector2(imageSize!.x.toDouble(), imageSize!.y.toDouble()) : null,
        ),
      );
      await _borderComponent.add(_spriteComponent!);
    }

    if (!visible) {
      _borderComponent.opacity = 0;
      scale = Vector2.all(0.7);
    }
    return super.onLoad();
  }

  @override
  void update(double dt) {
    _borderComponent.size = size;
    _spriteComponent?.size = size - Vector2.all(game.gameComponent.gameScale * 6);
    _spriteComponent?.position = Vector2.all(game.gameComponent.gameScale * 3);

    if (color != null) {
      _borderComponent.backgroundColor = color!;
    }

    final scaleValue = LerpUtils.d(
      dt,
      target: visible ? 1.0 : 0.7,
      value: scale.x,
      time: 0.1,
    ).clamp(0.0, 10.0);
    scale = Vector2.all(scaleValue);

    final opacityValue = LerpUtils.d(
      dt,
      target: visible ? 1.0 : 0.0,
      value: _borderComponent.opacity,
      time: 0.1,
    ).clamp(0.0, 1.0);

    _borderComponent.opacity = opacityValue;
    super.update(dt);
  }

  @override
  void onTapDown(TapDownEvent event) {
    if (!visible) return;
    callbackTapDown?.call();
    super.onTapDown(event);
  }

  @override
  void onTapUp(TapUpEvent event) {
    if (!visible) return;
    callbackTapUp?.call();
    super.onTapUp(event);
  }

  @override
  void onTapCancel(TapCancelEvent event) {
    if (!visible) return;
    callbackTapUp?.call();
    super.onTapCancel(event);
  }
}
