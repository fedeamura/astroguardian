import 'dart:async';
import 'dart:ui' as ui;

import 'package:astro_guardian/game/game.dart';
import 'package:astro_guardian/game/util/extension/string.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:model/model.dart';
import 'package:util/util.dart';

class PlanetRenderComponent extends PositionComponent with HasGameRef<GameComponent> {
  final Planet planet;

  PlanetRenderComponent({
    required this.planet,
  });

  ui.Image? _terrain1;
  ui.Image? _terrain2;
  ui.Image? _atmosphere1;
  ui.Image? _atmosphere2;

  double _percentage1 = 0.5;
  double _percentage2 = 1.0;

  @override
  FutureOr<void> onLoad() {
    size = Vector2.all(planet.radius * 2.0);
    anchor = Anchor.center;
    _createTerrainImage(first: true).then((value) => _terrain1 = value);
    _createTerrainImage(first: false).then((value) => _terrain2 = value);
    _createAtmosphereImage(first: true).then((value) => _atmosphere1 = value);
    _createAtmosphereImage(first: false).then((value) => _atmosphere2 = value);
    return super.onLoad();
  }

  Future<ui.Image> _createTerrainImage({required bool first}) async {
    final resolution = planet.terrain.resolution;

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    canvas.drawRect(Rect.fromLTWH(0, 0, resolution * 2, resolution * 2), Paint()..color = Colors.white);

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
    final uiImage = picture.toImageSync(
      resolution.floor() * 2,
      resolution.floor() * 2,
    );

    final byteData = await uiImage.toByteData();
    final image = img.Image.fromBytes(
      width: uiImage.width,
      height: uiImage.height,
      bytes: byteData!.buffer,
      numChannels: 4,
    );

    final resized = img.copyResize(
      image,
      width: (planet.radius * 2.0).floor(),
      height: (planet.radius * 2.0).floor(),
    );

    Completer<ui.Image> completer = Completer();

    ui.decodeImageFromList(img.encodePng(resized), (result) {
      completer.complete(result);
    });

    return completer.future;
  }

  Future<ui.Image> _createAtmosphereImage({required bool first}) async {
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
    final uiImage = picture.toImageSync(
      resolution.floor() * 2,
      resolution.floor() * 2,
    );

    final byteData = await uiImage.toByteData();
    final image = img.Image.fromBytes(
      width: uiImage.width,
      height: uiImage.height,
      bytes: byteData!.buffer,
      numChannels: 4,
    );

    final resized = img.copyResize(
      image,
      width: (planet.radius * 2.0).floor(),
      height: (planet.radius * 2.0).floor(),
    );

    Completer<ui.Image> completer = Completer();

    ui.decodeImageFromList(img.encodePng(resized), (result) {
      completer.complete(result);
    });

    return completer.future;
  }

  @override
  void update(double dt) {
    final d = 0.1 * dt;

    _percentage1 -= d;
    _percentage1 %= 1.0;

    _percentage2 -= d;
    _percentage2 %= 1.0;

    super.update(dt);
  }

  @override
  void render(ui.Canvas canvas) {
    super.render(canvas);
    var isMainCamera = CameraComponent.currentCamera == game.camera;

    final t1 = MathRangeUtil.range(
      _percentage1,
      0.0,
      1.0,
      -planet.radius * 2.0,
      planet.radius * 2.0,
    );

    final t2 = MathRangeUtil.range(
      _percentage2,
      0.0,
      1.0,
      -planet.radius * 2.0,
      planet.radius * 2.0,
    );

    if (isMainCamera) {
      canvas.save();
      final circlePath = Path()
        ..addOval(
          Rect.fromCircle(
            center: Offset(planet.radius, planet.radius),
            radius: planet.radius,
          ),
        );
      canvas.clipPath(circlePath);

      if (_terrain1 != null) {
        canvas.drawImageRect(
          _terrain1!,
          Rect.fromLTWH(
            0,
            0,
            _terrain1!.width.toDouble(),
            _terrain1!.height.toDouble(),
          ),
          Rect.fromLTWH(
            t1,
            0,
            planet.radius * 2.0,
            planet.radius * 2.0,
          ),
          Paint()
            ..filterQuality = FilterQuality.none
            ..isAntiAlias = false,
        );
      }

      if (_terrain2 != null) {
        canvas.drawImageRect(
          _terrain2!,
          Rect.fromLTWH(
            0,
            0,
            _terrain2!.width.toDouble(),
            _terrain2!.height.toDouble(),
          ),
          Rect.fromLTWH(
            t2,
            0,
            planet.radius * 2.0,
            planet.radius * 2.0,
          ),
          Paint()
            ..filterQuality = FilterQuality.none
            ..isAntiAlias = false,
        );
      }

      if (_atmosphere1 != null) {
        canvas.drawImageRect(
          _atmosphere1!,
          Rect.fromLTWH(
            0,
            0,
            _atmosphere1!.width.toDouble(),
            _atmosphere1!.height.toDouble(),
          ),
          Rect.fromLTWH(
            t1,
            0,
            planet.radius * 2.0,
            planet.radius * 2.0,
          ),
          Paint()
            ..filterQuality = FilterQuality.none
            ..isAntiAlias = false,
        );
      }

      if (_atmosphere2 != null) {
        canvas.drawImageRect(
          _atmosphere2!,
          Rect.fromLTWH(
            0,
            0,
            _atmosphere2!.width.toDouble(),
            _atmosphere2!.height.toDouble(),
          ),
          Rect.fromLTWH(
            t2,
            0,
            planet.radius * 2.0,
            planet.radius * 2.0,
          ),
          Paint()
            ..filterQuality = FilterQuality.none
            ..isAntiAlias = false,
        );
      }

      canvas.drawRect(
        Rect.fromLTWH(0.0, 0.0, planet.radius * 2, planet.radius * 2),
        Paint()
          ..color = Colors.black.withOpacity(1 - planet.percentage)
          ..blendMode = ui.BlendMode.color
          ..filterQuality = FilterQuality.none
          ..isAntiAlias = false,
      );

      canvas.restore();
    }
  }
}
