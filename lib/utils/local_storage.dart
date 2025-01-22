import '../library.dart';

class LocalStorageService {
  // Initialize the box for local storage
  static final GetStorage _storage = GetStorage();

  // Store a value in local storage
  static Future<void> storeData(String key, dynamic value) async {
    await _storage.write(key, value);
  }

  // Retrieve a value from local storage
  static dynamic getData(String key) {
    return _storage.read(key);
  }

  // Remove a specific key from local storage
  static Future<void> removeData(String key) async {
    await _storage.remove(key);
  }

  // Clear all data in local storage
  static Future<void> clearAllData() async {
    await _storage.erase();
  }

  // Check if a key exists in local storage
  static bool containsKey(String key) {
    return _storage.hasData(key);
  }
}
