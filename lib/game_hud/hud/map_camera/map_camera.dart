import 'dart:async';
import 'dart:math' as math;

import 'package:astro_guardian/game/border.dart';
import 'package:astro_guardian/game/util/extension/point.dart';
import 'package:astro_guardian/game/util/lerp.dart';
import 'package:astro_guardian/game_hud/game_hud.dart';
import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:util/util.dart';

import 'indicator.dart';

class HudMapCameraComponent extends PositionComponent with HasGameRef<GameHudComponent>, TapCallbacks {
  late BorderComponent _borderComponent;
  late ClipComponent _clipComponent;
  late RectangleComponent _backgroundComponent;
  late CameraComponent _cameraComponent;
  late HudMapIndicatorComponent _initialPlanetIndicatorComponent;
  bool? _visible;

  bool get _calculateVisibility => true;

  @override
  FutureOr<void> onLoad() async {
    _borderComponent = BorderComponent(
      gameScaleProvider: () => game.gameComponent.gameScale,
    );
    await add(_borderComponent);

    _clipComponent = ClipComponent.rectangle();
    await add(_clipComponent);

    _backgroundComponent = RectangleComponent(paint: Paint()..color = Colors.black);
    await _clipComponent.add(_backgroundComponent);

    _cameraComponent = CameraComponent(world: game.gameComponent.world)..viewfinder.anchor = Anchor.center;
    _cameraComponent.viewport = FixedSizeViewport(100, 100);
    await game.add(_cameraComponent);

    _initialPlanetIndicatorComponent = HudMapIndicatorComponent(
      cameraComponent: _cameraComponent,
      color: Colors.amber,
      positionProvider: () => game.gameComponent.game.mapMarker.vector2,
      visibilityProvider: () => game.gameComponent.game.mapMarkerVisible,
    );
    await _cameraComponent.viewport.add(_initialPlanetIndicatorComponent);

    return super.onLoad();
  }

  @override
  void update(double dt) {
    _updateSize(dt);
    _updateVisibility();

    super.update(dt);
  }

  double? _mapSize;

  _updateSize(double dt) {
    final s = game.camera.viewport.size;
    final scale = game.gameComponent.gameScale;
    final padding = 4.0 * scale;
    final p = game.gameComponent.paddingProvider();

    final shorterSize = math.min(s.x, s.y);

    var mapSize = _mapSize ?? (shorterSize * (_expanded ? 0.4 : 0.2)).clamp(10.0, 250.0);
    mapSize = LerpUtils.d(
      dt,
      target: (shorterSize * (_expanded ? 0.4 : 0.2)).clamp(10.0, 250.0),
      value: mapSize,
      time: 0.2,
    ).clamp(1.0, 99999);
    _mapSize = mapSize;

    position.x = s.x - mapSize - padding - p.left;
    position.y = p.top + padding;
    size = Vector2.all(mapSize);

    _borderComponent.size = size;
    _clipComponent.size = size;

    _backgroundComponent.position = Vector2.all(scale * 3);
    _backgroundComponent.size = size - Vector2.all(scale * 6);
    _backgroundComponent.paint = Paint()..color = Colors.black;

    _cameraComponent.follow(game.gameComponent.world.shipComponent);
    _cameraComponent.viewfinder.visibleGameSize = Vector2.all(GameConstants.minimapSize);

    final vp = _cameraComponent.viewport;
    final innerSize = size - Vector2.all(scale * 6);
    if (vp is FixedSizeViewport && vp.size.x != innerSize.x && vp.size.y != innerSize.y) {
      vp.size = Vector2(innerSize.x, innerSize.y);
    }

    _cameraComponent.viewport.position = position.clone() + Vector2.all(scale * 3);
  }

  _updateVisibility() {
    final visible = _calculateVisibility;
    if (visible == _visible) return;

    _visible = visible;
  }

  bool _expanded = false;

  @override
  void onTapUp(TapUpEvent event) {
    super.onTapUp(event);
    _expanded = !_expanded;
  }
}
