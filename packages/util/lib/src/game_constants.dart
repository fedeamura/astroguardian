class GameConstants {
  GameConstants._();

  static double get borderWidth => 3.0;

  static double get autoSaveInterval => 3000;

  static int get gameLimit => 999999;

  static double get generateMapDelay => 0.3;

  static int get chunkSize => 50;

  static int get renderDistance => 3;

  static double get minimapSize => chunkSize * (renderDistance * 1.5);

  static double get planetProbability => 0.4;

  static double get planetSatelliteMinOrbit => 0.1;

  static double get planetWithSatellitesProbability => 0.7;

  static int get planetSatelliteMaxCount => 1000;

  static bool get crtEnabled => false;

  static bool get noiseEnabled => true;

  static int get drawMaxOrbits => 50;

  static double get noiseDistance => 20.0;

  static int get noiseCount => 50;

  static bool get debug => true;

  static double get tutorialDistance => 10.0;
}
