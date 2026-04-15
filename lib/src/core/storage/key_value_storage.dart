/// Minimal async key/value storage abstraction used for user preferences
/// (locale override, theme mode, etc.). Backed by shared_preferences today;
/// swap the impl without touching callers.
abstract interface class KeyValueStorage {
  String? readString(String key);

  Future<void> writeString(String key, String value);

  Future<void> remove(String key);
}
