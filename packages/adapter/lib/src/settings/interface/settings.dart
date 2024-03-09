abstract class SettingsService {
  Future<void> init();

  Future<void> saveString(String key, String value);

  String getString(
    String key, {
    String defaultValue = "",
  });

  Stream<String> streamString(
    String key, {
    String defaultValue = "",
  });

  Future<void> saveInt(String key, int value);

  int getInt(
    String key, {
    int defaultValue = 0,
  });

  Stream<int> streamInt(
    String key, {
    int defaultValue = 0,
  });

  // Bool
  Future<void> saveBool(String key, bool value);

  bool getBool(String key, {bool defaultValue = false});

  Stream<bool> streamBool(String key, {bool defaultValue = false});

  // Double
  Future<void> saveDouble(String key, double value);

  double getDouble(String key, {double defaultValue = 0.0});

  Stream<double> streamDouble(String key, {double defaultValue = 0.0});
}
