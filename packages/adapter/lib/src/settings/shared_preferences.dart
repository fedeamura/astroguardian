import 'package:adapter/src/settings/interface/settings.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

class SharedPreferencesSettingsService extends SettingsService {
  late StreamingSharedPreferences _preferences;

  @override
  Future<void> init() async {
    _preferences = await StreamingSharedPreferences.instance;
  }

  @override
  Future<void> saveString(String key, String value) async {
    await _preferences.setString(
      key,
      value,
    );
  }

  @override
  String getString(
    String key, {
    String defaultValue = "",
  }) {
    return _preferences
        .getString(
          key,
          defaultValue: defaultValue,
        )
        .getValue();
  }

  @override
  Stream<String> streamString(
    String key, {
    String defaultValue = "",
  }) {
    return _preferences
        .getString(
          key,
          defaultValue: defaultValue,
        )
        .asBroadcastStream();
  }

  @override
  int getInt(String key, {int defaultValue = 0}) => _preferences
      .getInt(
        key,
        defaultValue: defaultValue,
      )
      .getValue();

  @override
  Future<void> saveInt(String key, int value) async {
    await _preferences.setInt(key, value);
  }

  @override
  Stream<int> streamInt(String key, {int defaultValue = 0}) => _preferences
      .getInt(
        key,
        defaultValue: defaultValue,
      )
      .asBroadcastStream();

  @override
  bool getBool(String key, {bool defaultValue = false}) => _preferences
      .getBool(
        key,
        defaultValue: defaultValue,
      )
      .getValue();

  @override
  Future<void> saveBool(String key, bool value) async {
    await _preferences.setBool(key, value);
  }

  @override
  Stream<bool> streamBool(String key, {bool defaultValue = false}) => _preferences
      .getBool(
        key,
        defaultValue: defaultValue,
      )
      .asBroadcastStream();

  // Double
  @override
  double getDouble(String key, {double defaultValue = 0.0}) => _preferences
      .getDouble(
        key,
        defaultValue: defaultValue,
      )
      .getValue();

  @override
  Future<void> saveDouble(String key, double value) async {
    await _preferences.setDouble(key, value);
  }

  @override
  Stream<double> streamDouble(String key, {double defaultValue = 0.0}) => _preferences
      .getDouble(
        key,
        defaultValue: defaultValue,
      )
      .asBroadcastStream();
}
