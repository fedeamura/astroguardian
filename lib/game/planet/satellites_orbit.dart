import 'dart:async';

import 'package:astro_guardian/game/game.dart';
import 'package:astro_guardian/game/util/extension/point.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:model/model.dart';

class PlanetSatellitesOrbitComponent extends PositionComponent with HasGameRef<GameComponent> {
  final Planet planet;

  PlanetSatellitesOrbitComponent(this.planet);

  @override
  FutureOr<void> onLoad() async {
    position = planet.globalPosition.vector2;
    return super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    if(CameraComponent.currentCamera==game.camera){
      _render(canvas);
    }

    super.render(canvas);
  }

  _render(Canvas canvas) {
    const w = 0.05;
    const o = 0.2;

    final paint = Paint()
      ..color = Colors.white.withOpacity(o)
      ..strokeWidth = w
      ..style = PaintingStyle.stroke;

    final satellites = planet.satellites.where((e) => e.orbitVisible).toList();

    for (var satellite in satellites) {
      final orbit = satellite.orbit;
      final a = orbit.a;
      final b = orbit.b;

      canvas.save();
      canvas.rotate(orbit.inclination);

      canvas.drawOval(
        Rect.fromCenter(
          center: Offset.zero,
          width: a * 2,
          height: b * 2,
        ),
        paint,
      );
      canvas.restore();
    }
  }
}
