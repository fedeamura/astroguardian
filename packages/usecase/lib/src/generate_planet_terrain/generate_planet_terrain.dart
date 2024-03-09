import 'dart:math' as math;

import 'package:util/util.dart';
import 'package:model/model.dart';
import 'package:open_simplex_noise/open_simplex_noise.dart' as noise;

import 'planet_colors.dart';

class GeneratePlanetTerrainUseCase {
  final _rnd = RandomUtil();

  PlanetTerrain call() {
    const resolution = 50.0;
    final colors = _rnd.item(planetColors);

    final terrain = Array<double>();
    final terrainNoise = noise.OpenSimplexNoise(_rnd.nextIntInRange(0, 999999));
    final terrainFrequency = _rnd.nextDoubleInRange(0.003, 0.05);

    final atmosphere = Array<double>();
    final atmosphereNoise = noise.OpenSimplexNoise(_rnd.nextIntInRange(0, 999999));
    final atmosphereFrequency = _rnd.nextDoubleInRange(0.005, 0.1);

    for (int j = 0; j < resolution * 2; j++) {
      for (int i = 0; i < resolution * 4; i++) {
        final theta = (i / (resolution * 4)) * math.pi * 2;
        final phi = (j / (resolution * 2)) * math.pi - math.pi / 2;
        final x = resolution * math.cos(phi) * math.cos(theta);
        final y = resolution * math.cos(phi) * math.sin(theta);
        final z = resolution * math.sin(phi);

        var elevation = terrainNoise.eval3D(x * terrainFrequency, y * terrainFrequency, z * terrainFrequency);
        elevation += 1;
        elevation = elevation / 2;
        elevation = elevation.clamp(0.0, 1.0);
        terrain.putByIndex(i, j, elevation);

        var atmosphereValue = atmosphereNoise.eval3D(x * atmosphereFrequency, y * atmosphereFrequency, z * atmosphereFrequency);
        atmosphereValue += 1;
        atmosphereValue = atmosphereValue / 2;
        atmosphereValue = atmosphereValue.clamp(0.0, 1.0);
        atmosphere.putByIndex(i, j, atmosphereValue);
      }
    }

    return PlanetTerrain(
      resolution: resolution,
      colors: colors,
      terrain: terrain,
      atmosphere: atmosphere,
    );
  }
}
