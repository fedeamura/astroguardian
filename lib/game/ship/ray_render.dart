import 'dart:async';
import 'dart:math' as math;

import 'package:astro_guardian/game/game.dart';
import 'package:astro_guardian/game/util/lerp.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:util/util.dart';

import 'ray_particle.dart';

class ShipRayRenderComponent extends PositionComponent with HasGameRef<GameComponent> {
  double _percentage = 0.0;

  bool get isConsuming => game.keyConsumePressed && !game.game.ship.isBagFull;

  int get _lineCount => 50;

  int get _linePoints => 20;

  bool? _visible;
  final _rnd = RandomUtil();
  final _lineAmplitude = <int, double>{};
  final _lineAngleScale = <int, double>{};
  final _lineAngle = <int, double>{};
  final _lineLength = <int, double>{};
  final _lineColor = <int, double>{};

  final _selectedLineAmplitude = <int, double>{};
  final _selectedLineAngleScale = <int, double>{};
  final _selectedLineAngle = <int, double>{};
  final _selectedLineLength = <int, double>{};
  final _selectedLineColor = <int, double>{};

  final _animatedSelectedLineAngle = <int, double>{};
  final _animatedSelectedLineOpacity = <int, double>{};
  final _animatedSelectedLineLength = <int, double>{};
  double _animatedLineOpacity = 0.0;

  @override
  FutureOr<void> onLoad() async {
    anchor = Anchor.center;
    return super.onLoad();
  }

  @override
  void update(double dt) {
    final l = game.game.ship.rayLength.value;

    final shipPosition = game.world.shipComponent.position;
    final shipAngle = game.world.shipComponent.angle;
    angle = shipAngle + math.pi * 1.25;
    position = shipPosition;

    _percentage = LerpUtils.d(
      dt,
      target: isConsuming ? 1.0 : 0.0,
      value: _percentage,
      time: 0.1,
    );

    size = Vector2.all(l * _percentage);

    _calculate();
    _calculatedSelected(dt);
    _incrementAngle(dt);
    _addParticle(dt);
    super.update(dt);
  }

  _calculate() {
    if (isConsuming == _visible) return;
    _visible = isConsuming;

    if (isConsuming) {
      for (int i = 0; i <= _lineCount; i++) {
        _lineAngleScale[i] = _rnd.nextDoubleInRange(1, 2);
        _lineAmplitude[i] = _rnd.nextDoubleInRange(1.2, 1.5);
        _lineLength[i] = _rnd.nextDoubleInRange(0.8, 1.0);
        _lineColor[i] = _rnd.nextDoubleInRange(180.0, 300.0);

        _selectedLineAngleScale[i] = _rnd.nextDoubleInRange(1, 2);
        _selectedLineAmplitude[i] = _rnd.nextDoubleInRange(3.0, 4.0);
        _selectedLineLength[i] = 1.0;
        _selectedLineColor[i] = _rnd.nextDoubleInRange(200.0, 250.0);
      }
    }
  }

  _calculatedSelected(double dt) {
    final shipPosition = game.world.shipComponent.position;
    final shipAngle = game.world.shipComponent.angle;
    final count = game.game.ship.rayCount.value.floor();
    final selectedSatellites = game.world.shipComponent.rayComponent.selectedSatellites;

    _animatedLineOpacity = LerpUtils.d(
      dt,
      target: count == selectedSatellites.entries.length ? 0.0 : 1.0,
      value: _animatedLineOpacity,
      time: 0.1,
    );

    int index = 0;
    for (var element in selectedSatellites.entries) {
      final satellite = element.value;

      // Opacity
      _animatedSelectedLineOpacity[index] = LerpUtils.d(
        dt,
        target: 1,
        value: _animatedSelectedLineOpacity[index] ?? 0.0,
        time: 0.1,
      );

      // Length
      final currentLineLength = _animatedSelectedLineLength[index] ?? 0.0;
      final lineDistance = satellite.position.distanceTo(shipPosition);
      _animatedSelectedLineLength[index] = LerpUtils.d(
        dt,
        target: lineDistance,
        value: currentLineLength,
        time: 0.1,
      );

      // Angle
      var newAngle = math.atan2(
        satellite.position.y - shipPosition.y,
        satellite.position.x - shipPosition.x,
      );
      newAngle = newAngle - shipAngle + math.pi * 0.75;
      _animatedSelectedLineAngle[index] = newAngle;

      index++;
    }

    for (int i = index; i < count; i++) {
      // Opacity
      _animatedSelectedLineOpacity[i] = LerpUtils.d(
        dt,
        target: 0,
        value: _animatedSelectedLineOpacity[i] ?? 0.0,
        time: 0.1,
      );

      // Length
      final currentLineLength = _animatedSelectedLineLength[i] ?? 0.0;
      double newLineLength = 0.0;
      _animatedSelectedLineLength[i] = LerpUtils.d(
        dt,
        target: newLineLength,
        value: currentLineLength,
        time: 0.1,
      );
    }
  }

  _incrementAngle(double dt) {
    for (int i = 0; i <= _lineCount; i++) {
      final lineAngleScale = _lineAngleScale[i] ?? 1.0;
      _lineAngle[i] = (_lineAngle[i] ?? 0.0) + dt * math.pi * 2 * lineAngleScale;

      final selectedLineAngleScale = _selectedLineAngleScale[i] ?? 1.0;
      _selectedLineAngle[i] = (_selectedLineAngle[i] ?? 0.0) + dt * math.pi * 2 * selectedLineAngleScale;
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    _renderLines(canvas);
    _renderSelectedLines(canvas);
  }

  _renderLines(Canvas canvas) {
    if (_percentage <= 0.05) return;

    final p = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = width * 0.01;

    for (int line = 0; line <= _lineCount; line++) {
      final startAngle = ((math.pi * 0.5) / _lineCount) * line;
      final path = Path();

      canvas.save();
      canvas.translate(width * 0.65, width * 0.65);
      canvas.rotate(startAngle);

      final amplitude = _lineAmplitude[line] ?? 0.0;
      final lineAngle = _lineAngle[line] ?? 0.0;
      final lineLength = _lineLength[line] ?? 1.0;
      final lineColor = _lineColor[line] ?? 0.0;
      final color = HSVColor.fromAHSV(1.0, lineColor, 0.3, 1.0).toColor().withOpacity(0.3 * _animatedLineOpacity);
      for (int i = 0; i < _linePoints; i++) {
        final percentage = i / _linePoints;
        final angle = math.pi * 2 * percentage * (amplitude * lineLength) + lineAngle;
        final d = width * 0.05;
        final x = percentage * width * lineLength;
        final y = d * math.sin(angle);

        if (i == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }

      canvas.drawPath(path, p..color = color);
      canvas.restore();
    }
  }

  _renderSelectedLines(Canvas canvas) {
    if (_percentage <= 0.05) return;

    final maxDistance = game.game.ship.rayLength.value;
    final count = game.game.ship.rayCount.value.floor();

    final paintLine = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = width * 0.03;

    final paintCircle = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..style = PaintingStyle.fill;

    for (int line = 0; line <= count; line++) {
      final lineOpacity = (_animatedSelectedLineOpacity[line] ?? 0.0).clamp(0.0, 1.0);
      final lineLength = _animatedSelectedLineLength[line] ?? 0.0;
      final lineLengthPercentage = (lineLength / maxDistance).clamp(0.0, 1.0);

      final path = Path();

      canvas.save();
      canvas.translate(width * 0.65, width * 0.65);
      canvas.rotate(_animatedSelectedLineAngle[line] ?? 0.0);

      final amplitude = (_selectedLineAmplitude[line] ?? 0.0);
      final lineAngle = _selectedLineAngle[line] ?? 0.0;
      final lineColor = _selectedLineColor[line] ?? 0.0;
      final color = HSVColor.fromAHSV(1.0, lineColor, 0.3, 1.0).toColor().withOpacity(lineOpacity);
      for (int i = 0; i < _linePoints; i++) {
        final percentage = i / _linePoints;
        final x = percentage * lineLengthPercentage * width;
        final angle = math.pi * 2 * percentage * (amplitude * lineLength) + lineAngle;
        final d = width * 0.02;
        final y = d * math.sin(angle);

        if (i == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }

      canvas.drawPath(path, paintLine..color = color);
      canvas.restore();
    }
  }

  var _delay = 0.0;

  _addParticle(double dt) {
    _delay += dt;
    if (_delay < 0.1) return;
    _delay = 0.0;

    final satellites = game.world.shipComponent.rayComponent.selectedSatellites;
    for (var element in satellites.entries) {
      for (int i = 0; i < 5; i++) {
        final r = element.value.satellite.radius * 0.5;

        final angle = _rnd.nextDouble() * 2 * math.pi;
        final d = _rnd.nextDoubleInRange(0.1, 0.5);
        final particleX = element.value.position.x + d * math.cos(angle);
        final particleY = element.value.position.y + d * math.sin(angle);
        game.world.shipRayLayer.add(
          ShipRayParticleComponent(
            startPosition: Vector2(
              particleX,
              particleY,
            ),
            radius: 0.2,
          ),
        );
      }
    }
  }
}
