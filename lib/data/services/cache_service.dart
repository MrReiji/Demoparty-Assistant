import 'package:hive/hive.dart';

class CacheService {
  late Box<dynamic> _cacheBox;

  /// Initializes Hive and opens the cache box.
  Future<void> initialize() async {
    print("[CacheService] Initializing...");
    _cacheBox = await Hive.openBox('global_cache');
    print("[CacheService] Cache box opened.");
  }

  /// Retrieves cached data for a given key.
  dynamic get(String key) {
    print("[CacheService] Retrieving cache for key: $key");
    final cachedItem = _cacheBox.get(key);
    if (cachedItem != null) {
      final expiry = cachedItem['expiry'];
      if (expiry != null && DateTime.now().isAfter(DateTime.parse(expiry))) {
        _cacheBox.delete(key);
        print("[CacheService] Cache expired for key: $key");
        return null; // Cache expired
      }
      return cachedItem['data'];
    }
    print("[CacheService] No cache found for key: $key");
    return null; // No cache found
  }

  /// Stores data in the cache with an optional TTL (in seconds).
  Future<void> set(String key, dynamic value, [int ttl = 10]) async {
    // TTL domyślnie ustawione na 10 sekund
    final expiry = DateTime.now().add(Duration(seconds: ttl)).toIso8601String();
    await _cacheBox.put(key, {'data': value, 'expiry': expiry});
    print("[CacheService] Cache updated for key: $key with expiry in $ttl seconds.");
  }

  /// Removes a key from the cache.
  Future<void> remove(String key) async {
    await _cacheBox.delete(key);
    print("[CacheService] Cache removed for key: $key");
  }

  /// Clears the entire cache.
  Future<void> clearCache() async {
    await _cacheBox.clear();
    print("[CacheService] Entire cache cleared.");
  }
}
