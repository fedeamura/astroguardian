import 'dart:math' as math;

class RandomUtil {
  final math.Random _random;

  factory RandomUtil.seeded(int seed) => RandomUtil(seed: seed);

  RandomUtil({
    int? seed,
  }) : _random = math.Random(seed ?? DateTime.now().microsecondsSinceEpoch);

  double nextDouble() => _random.nextDouble();

  int nextIntInRange(int min, int max) {
    if (min == max) return min;
    if (min > max) throw ArgumentError("$min its not < $max");

    return min + _random.nextInt(max - min + 1);
  }

  double nextDoubleInRange(double min, double max) {
    if (min == max) return min;
    if (min > max) throw ArgumentError("$min its not < $max");
    return min + _random.nextDouble() * (max - min);
  }

  T item<T>(List<T> values) => values[nextIntInRange(0, values.length - 1)];

  double nextAngle() => _random.nextDouble() * math.pi * 2;
}

extension RandomUtilListExtension<T> on List<T> {
  T get random {
    return RandomUtil().item(this);
  }
}
