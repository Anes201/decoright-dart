import 'package:get_storage/get_storage.dart';

class TLocalStorage {
  // Singleton
  static final TLocalStorage instance = TLocalStorage._internal();

  TLocalStorage._internal();

  static Future<void> init() async {
    await GetStorage.init();
  }

  final GetStorage _storage = GetStorage();

  /// Save data of any type
  Future<void> saveData<T>(String key, T value) async {
    await _storage.write(key, value);
  }

  /// Read data with optional default value
  T? readData<T>(String key, {T? defaultValue}) {
    return _storage.read<T>(key) ?? defaultValue;
  }

  /// Remove one item
  Future<void> removeData(String key) async {
    await _storage.remove(key);
  }

  /// Check if key exists
  bool containsKey(String key) {
    return _storage.hasData(key);
  }

  /// Clear all storage
  Future<void> clearAll() async {
    await _storage.erase();
  }
}



/// *** *** *** *** *** Example *** *** *** *** *** ///

// LocalStorage localStorage = LocalStorage();
//
// // Save data
// localStorage.saveData('username', 'JohnDoe');
//
// // Read data
// String? username = localStorage.readData<String>('username');
// print('Username: $username'); // Output: Username: JohnDoe
//
// // Remove data
// localStorage.removeData('username');
//
// // Clear all data
// localStorage.clearAll();

