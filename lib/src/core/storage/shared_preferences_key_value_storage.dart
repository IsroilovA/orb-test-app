import 'package:orb_test_app/src/core/storage/key_value_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

final class SharedPreferencesKeyValueStorage implements KeyValueStorage {
  const SharedPreferencesKeyValueStorage(this._prefs);

  final SharedPreferences _prefs;

  @override
  String? readString(String key) => _prefs.getString(key);

  @override
  Future<void> writeString(String key, String value) => _prefs.setString(key, value);

  @override
  Future<void> remove(String key) => _prefs.remove(key);
}
