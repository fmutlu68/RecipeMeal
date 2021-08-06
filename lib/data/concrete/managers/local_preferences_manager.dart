import 'package:shared_preferences/shared_preferences.dart';

class LocalPreferencesManager {
  static LocalPreferencesManager _instance = LocalPreferencesManager._init();
  static LocalPreferencesManager get instance => _instance;

  SharedPreferences _preferences;

  LocalPreferencesManager._init() {
    SharedPreferences.getInstance().then((value) {
      _preferences = value;
      initApp();
    });
  }
  static prefenecesInit() async {
    if (_instance._preferences == null) {
      _instance._preferences = await SharedPreferences.getInstance();
      initApp();
    }
    return;
  }

  static void initApp() {
    if (_instance._preferences.containsKey("Theme") == false) {
      _instance._preferences.setString("Theme", "Light");
    }
  }

  Future<void> setStringValue(String key, String value) async {
    await _preferences.setString(key, value);
  }

  Object getValue(String key) {
    return _preferences.get(key);
  }

  Set<String> getAllKeys() {
    return _preferences.getKeys();
  }
}
