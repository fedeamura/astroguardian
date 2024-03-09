import 'dart:async';
import 'dart:ui' as ui;

import 'package:astro_guardian/game/game.dart';
import 'package:astro_guardian/game/util/extension/string.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:model/model.dart';

class PlanetRenderComponent extends PositionComponent with HasGameRef<GameComponent> {
  final Planet planet;

  PlanetRenderComponent({
    required this.planet,
  });

  late ClipComponent _clipComponent;
  late SpriteComponent _spriteTerrain1Component;
  late SpriteComponent _spriteTerrain2Component;
  late SpriteComponent _spriteAtmosphere1Component;
  late SpriteComponent _spriteAtmosphere2Component;
  late RectangleComponent _dimComponent;
  bool _toggleTerrain = true;
  bool _toggleAtmosphere = true;

  @override
  FutureOr<void> onLoad() {
    _clipComponent = ClipComponent.circle(
      size: Vector2.all(planet.radius * 2.0),
      anchor: Anchor.center,
      position: Vector2.all(planet.radius * 0.0),
    );
    add(_clipComponent);

    _spriteTerrain1Component = SpriteComponent(
      size: Vector2.all(planet.radius * 2.0),
      sprite: Sprite(_createTerrainImage(first: true)),
      position: Vector2(0, planet.radius.toDouble()),
      anchor: Anchor.center,
      paint: Paint()
        ..filterQuality = FilterQuality.none
        ..isAntiAlias = false,
    );
    _clipComponent.add(_spriteTerrain1Component);

    _spriteTerrain2Component = SpriteComponent(
      size: Vector2.all(planet.radius * 2.0),
      sprite: Sprite(_createTerrainImage(first: false)),
      position: Vector2(planet.radius * 2.0, planet.radius.toDouble()),
      anchor: Anchor.center,
      paint: Paint()
        ..filterQuality = FilterQuality.none
        ..isAntiAlias = false,
    );
    _clipComponent.add(_spriteTerrain2Component);

    _spriteAtmosphere1Component = SpriteComponent(
      size: Vector2.all(planet.radius * 2.0),
      sprite: Sprite(_createAtmosphereImage(first: true)),
      position: Vector2(0, planet.radius.toDouble()),
      anchor: Anchor.center,
      paint: Paint()
        ..filterQuality = FilterQuality.none
        ..isAntiAlias = false,
    );
    _clipComponent.add(_spriteAtmosphere1Component);

    _spriteAtmosphere2Component = SpriteComponent(
      size: Vector2.all(planet.radius * 2.0),
      sprite: Sprite(_createAtmosphereImage(first: false)),
      position: Vector2(planet.radius * 2.0, planet.radius.toDouble()),
      anchor: Anchor.center,
      paint: Paint()
        ..filterQuality = FilterQuality.none
        ..isAntiAlias = false,
    );
    _clipComponent.add(_spriteAtmosphere2Component);

    _dimComponent = RectangleComponent(
      paint: Paint()
        ..color = Colors.black
        ..blendMode = ui.BlendMode.color,
    );
    _clipComponent.add(_dimComponent);

    return super.onLoad();
  }

  _createTerrainImage({required bool first}) {
    final resolution = planet.terrain.resolution;

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    canvas.drawColor(Colors.white, ui.BlendMode.src);

    final colors = planet.terrain.colors;

    for (int j = 0; j < resolution.floor() * 2; j++) {
      for (int i = 0; i < resolution.floor() * 2; i++) {
        final elevation = planet.terrain.terrain.getByIndex(i + (first ? 0 : (resolution.floor() * 2)), j);
        final colorIndex = ((elevation ?? 0) * colors.length).floor();

        canvas.drawRect(
          Rect.fromLTWH(
            i.toDouble(),
            j.toDouble(),
            1.0,
            1.0,
          ),
          Paint()..color = colors[colorIndex].color,
        );
      }
    }

    final picture = recorder.endRecording();
    return picture.toImageSync(
      resolution.floor() * 2,
      resolution.floor() * 2,
    );
  }

  _createAtmosphereImage({required bool first}) {
    final resolution = planet.terrain.resolution;

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    for (int j = 0; j < resolution.floor() * 2; j++) {
      for (int i = 0; i < resolution.floor() * 2; i++) {
        final elevation = planet.terrain.atmosphere.getByIndex(i + (first ? 0 : (resolution.floor() * 2)), j) ?? 0.0;

        if (elevation > 0.6) {
          canvas.drawRect(
            Rect.fromLTWH(
              i.toDouble(),
              j.toDouble(),
              1.0,
              1.0,
            ),
            Paint()..color = Colors.white.withOpacity(0.6),
          );
        }
      }
    }

    final picture = recorder.endRecording();
    return picture.toImageSync(
      resolution.floor() * 2,
      resolution.floor() * 2,
    );
  }

  @override
  void update(double dt) {
    _moveTerrain(dt);
    _moveAtmosphere(dt);

    final s = planet.radius * 2;
    _dimComponent.size = Vector2.all(s.toDouble());
    _dimComponent.opacity = 1 - planet.percentage;

    super.update(dt);
  }


  @override
  void render(ui.Canvas canvas) {
    super.render(canvas);
    final isMainCamera = CameraComponent.currentCamera == game.camera;
    _spriteTerrain1Component.opacity = isMainCamera ? 1.0:0.0;
    _spriteTerrain2Component.opacity = isMainCamera ? 1.0:0.0;
    _spriteAtmosphere1Component.opacity = isMainCamera ? 1.0:0.0;
    _spriteAtmosphere2Component.opacity = isMainCamera ? 1.0:0.0;
  }


  _moveTerrain(double dt) {
    final s = planet.radius * 2;
    final d = planet.spinSpeed * s * dt;
    final sprite1 = _toggleTerrain ? _spriteTerrain1Component : _spriteTerrain2Component;
    final sprite2 = _toggleTerrain ? _spriteTerrain2Component : _spriteTerrain1Component;

    final x = sprite1.position.x - d;
    if (x < -s * 0.5) {
      sprite1.position.x = s * 1.5;
      sprite2.position.x = s * 0.5;
      _toggleTerrain = !_toggleTerrain;
    } else {
      sprite1.x = x;
      sprite2.x = x + s * 1.0;
    }
  }



  _moveAtmosphere(double dt) {
    final s = planet.radius * 2;
    final d = planet.spinSpeed * s * dt * 0.8;
    final sprite1 = _toggleAtmosphere ? _spriteAtmosphere1Component : _spriteAtmosphere2Component;
    final sprite2 = _toggleAtmosphere ? _spriteAtmosphere2Component : _spriteAtmosphere1Component;

    final x = sprite1.position.x - d;
    if (x < -s * 0.5) {
      sprite1.position.x = s * 1.5;
      sprite2.position.x = s * 0.5;
      _toggleAtmosphere = !_toggleAtmosphere;
    } else {
      sprite1.x = x;
      sprite2.x = x + s * 1.0;
    }
  }

}
