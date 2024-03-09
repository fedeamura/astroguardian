import 'dart:math' as math;
import 'dart:ui';

import 'package:util/util.dart';
import 'package:model/model.dart';
import 'package:open_simplex_noise/open_simplex_noise.dart' as noise;

class GeneratePlanetSatelliteTerrainUseCase {
  final _rnd = RandomUtil();

  PlanetSatelliteTerrain call() {
    const resolution = 10;
    const frequency = 1.0;

    final terrain = Array<bool>();
    final n = noise.OpenSimplexNoise(_rnd.nextIntInRange(0, 1000000));
    int centerRow = resolution ~/ 2;
    int centerCol = resolution ~/ 2;

    for (int row = 0; row < resolution; row++) {
      for (int col = 0; col < resolution; col++) {
        final px = row.toDouble() / resolution;
        final py = col.toDouble() / resolution;
        var noiseValue = n.eval2D(px * frequency, py * frequency);
        noiseValue += 1;
        noiseValue = noiseValue / 2;
        noiseValue = noiseValue.clamp(0.0, 1.0);

        final distanceToCenter = math.sqrt(math.pow(row - resolution / 2, 2) + math.pow(col - resolution / 2, 2));
        final normalizedDistance = distanceToCenter / (resolution / 2);
        const smoothness = 1.0;
        final finalValue = noiseValue - normalizedDistance * smoothness;
        final value = finalValue > 0.0;
        terrain.putByIndex(row, col, value);
      }
    }

    const min = 2;
    for (int i = centerCol - min; i < centerCol + min; i++) {
      for (int j = centerRow - min; j < centerRow + min; j++) {
        terrain.putByIndex(i, j, true);
      }
    }

    int red = (_rnd.nextDouble() * 256).floor();
    int green = (_rnd.nextDouble() * 256).floor();
    int blue = (_rnd.nextDouble() * 256).floor();
    final color = Color.fromRGBO(red, green, blue, 1.0);

    return PlanetSatelliteTerrain(
      resolution: resolution,
      color: color.value,
      terrain: terrain,
      border: _generateBorder(terrain: terrain, resolution: resolution),
    );
  }

  Array<bool> _generateBorder({
    required Array<bool> terrain,
    required int resolution,
  }) {
    final pixels = terrain.entries.where((e) => e.value == true).toList();

    bool isTerrain(int x, int y) {
      return terrain.getByIndex(x, y) == true;
    }

    bool isBorder(int x, int y) {
      if (x == 0 || y == 0) return true;
      if (x == resolution - 1 || y == resolution - 1) return true;

      final valid = isTerrain(x, y);
      if (!valid) return false;

      if (!isTerrain(x - 1, y)) return true;
      if (!isTerrain(x + 1, y)) return true;
      if (!isTerrain(x, y - 1)) return true;
      if (!isTerrain(x, y + 1)) return true;

      return false;
    }

    final result = Array<bool>();
    for (var element in pixels) {
      if (isBorder(element.position.x, element.position.y)) {
        result.putByIndex(
          element.position.x,
          element.position.y,
          true,
        );
      }
    }

    return result;
  }
}
