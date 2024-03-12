import 'dart:async';
import 'dart:math' as math;

import 'package:astro_guardian/game/game.dart';
import 'package:astro_guardian/game/util/lerp.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:util/util.dart';

import 'ray_particle.dart';

class ShipRayRenderComponent extends PositionComponent with HasGameRef<GameComponent> {
  bool get isConsuming => game.keyConsumePressed && !game.game.ship.isBagFull;

  int get _lineCount => 10;

  bool? _visible;
  final _rnd = RandomUtil();

  double _percentage = 0.0;
  final _lineWidth = <int, double>{};
  final _lineColor = <int, Color>{};
  final _linePercentage = <int, double>{};

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

    size = Vector2.all(l);

    _calculate();
    _incrementAngle(dt);
    _addParticle(dt);
    super.update(dt);
  }

  _calculate() {
    if (isConsuming == _visible) return;
    _visible = isConsuming;

    if (isConsuming) {
      for (int i = 0; i <= _lineCount; i++) {
        _lineWidth[i] = _rnd.nextDoubleInRange(0.01, 0.03);
        _linePercentage[i] = 1 - (i / _lineCount);
      }
    }
  }

  _incrementAngle(double dt) {
    for (int i = 0; i <= _lineCount; i++) {
      var p = (_linePercentage[i] ?? 0);
      const velocity = 0.2;
      p += velocity * dt;
      if (p >= 1) {
        final colorValue = _rnd.nextDoubleInRange(150, 300);
        final saturation = _rnd.nextDoubleInRange(0.0, 0.3);
        _lineColor[i] = HSVColor.fromAHSV(1.0, colorValue, saturation, 1.0).toColor();
        _lineWidth[i] = _rnd.nextDoubleInRange(0.01, 0.03);
      }

      p = p % 1;
      _linePercentage[i] = p;
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    _renderLines(canvas);
  }

  _renderLines(Canvas canvas) {
    if (_percentage <= 0.05) return;

    canvas.save();
    canvas.translate(width * 0.65, width * 0.65);
    canvas.rotate(-math.pi * 0.25);

    for (int i = 0; i < _lineCount; i++) {
      final p = (_linePercentage[i] ?? 0.0);
      final color = _lineColor[i] ?? Colors.transparent;

      final w = width * (1 - p);
      final opacity = MathRangeUtil.multiRange(
            p,
            [0, 0.3, 1.0],
            [0, 0.8, 0.0],
          ) *
          _percentage;

      final lineWidth = _lineWidth[i] ?? 0.0;

      final paint = Paint()
        ..color = color.withOpacity(opacity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = width * lineWidth
        ..strokeCap = StrokeCap.round;

      const m = 2.0;
      final rect = Rect.fromLTWH(
        width * m * 0.5 * p * _percentage - width * m * 0.5 * _percentage,
        0,
        w * m * _percentage,
        w * _percentage,
      );
      canvas.drawArc(
        rect,
        math.pi * 0.2,
        math.pi * 0.6,
        false,
        paint,
      );
    }
    canvas.restore();
  }

  var _delay = 0.0;

  _addParticle(double dt) {
    _delay += dt;
    if (_delay < 0.1) return;
    _delay = 0.0;

    final satellites = game.world.shipComponent.rayComponent.selectedSatellites;
    for (var element in satellites.entries) {
      for (int i = 0; i < 5; i++) {
        final angle = _rnd.nextDouble() * 2 * math.pi;
        final d = _rnd.nextDoubleInRange(0.1, 0.5);

        game.world.shipRayLayer.add(
          ShipRayParticleComponent(
            positionBuilder: () {
              final particleX = element.value.position.x + d * math.cos(angle);
              final particleY = element.value.position.y + d * math.sin(angle);

              return Vector2(
                particleX,
                particleY,
              );
            },
            opacityBuilder: () {
              final particleX = element.value.position.x + d * math.cos(angle);
              final particleY = element.value.position.y + d * math.sin(angle);
              final position = Vector2(particleX, particleY);
              final shipPosition = game.world.shipComponent.position;
              final maxDistance = game.game.ship.rayLength.value;
              final percentage = (position.distanceTo(shipPosition) / maxDistance).clamp(0.0, 1.0);
              return MathRangeUtil.multiRange(
                percentage,
                [0.00, 0.25, 0.50, 1.00],
                [0.00, 0.00, 0.25, 1.00],
              );
            },
          ),
        );
      }
    }
  }
}
