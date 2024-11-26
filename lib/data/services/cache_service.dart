import 'dart:typed_data';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
import 'package:get_it/get_it.dart';
import 'settings_service.dart';

/// CacheService handles caching of general data and images using Hive.
class CacheService {
  late Box<dynamic> _dataBox;
  late Box<dynamic> _imageBox;
  int _defaultTTL = 3600; // Default Time-to-Live (TTL) in seconds.
  final SettingsService _settingsService = GetIt.I<SettingsService>();

  /// Initializes Hive boxes for data and images.
  Future<void> initialize() async {
    print("[CacheService] Initializing...");
    _dataBox = await Hive.openBox('global_cache');
    _imageBox = await Hive.openBox('images_cache');
    print("[CacheService] Boxes initialized: global_cache and images_cache.");
  }

  /// Retrieves the current global TTL.
  int getCurrentTTL() => _defaultTTL;

  /// Sets the global TTL for both data and image caches.
  Future<void> setGlobalTTL(int ttl) async {
    _defaultTTL = ttl;
    await _updateTTL(_dataBox, ttl);
    await _updateTTL(_imageBox, ttl);
    print("[CacheService] Global TTL set to $ttl seconds.");
  }

  /// Updates the TTL for all items in a given cache box.
  Future<void> _updateTTL(Box<dynamic> box, int ttl) async {
    for (final key in box.keys) {
      final cachedItem = box.get(key);
      if (cachedItem != null && cachedItem is Map) {
        cachedItem['expiry'] = DateTime.now()
            .add(Duration(seconds: ttl))
            .toIso8601String();
        await box.put(key, cachedItem);
      }
    }
  }

  /// Clears all data and image caches.
  Future<void> clearAllCache() async {
    await _dataBox.clear();
    await _imageBox.clear();
    print("[CacheService] All caches cleared.");
  }

  /// Checks if cache is enabled based on user settings.
  Future<bool> isCacheEnabled() async {
    return await _settingsService.isCacheEnabled();
  }

  /// Retrieves cached data or fetches fresh data if cache is disabled.
  Future<dynamic> getDataOrFetch(String key, Future<dynamic> Function() fetcher) async {
    if (await isCacheEnabled()) {
      final cachedData = getData(key);
      if (cachedData != null) {
        print("[CacheService] Using cached data for key: $key");
        return cachedData;
      }
    }

    print("[CacheService] Fetching fresh data for key: $key");
    final data = await fetcher();
    if (await isCacheEnabled()) {
      await setData(key, data);
    }
    return data;
  }

  /// Retrieves cached data for a given key.
  dynamic getData(String key) {
    final cachedItem = _dataBox.get(key);
    if (cachedItem != null && !_isExpired(cachedItem['expiry'])) {
      return cachedItem['data'];
    }
    _dataBox.delete(key); // Cleanup expired item.
    return null;
  }

  /// Stores data in the cache with an optional TTL.
  Future<void> setData(String key, dynamic value, [int? ttl]) async {
    final expiry = DateTime.now()
        .add(Duration(seconds: ttl ?? _defaultTTL))
        .toIso8601String();
    await _dataBox.put(key, {'data': value, 'expiry': expiry});
  }

  /// Retrieves a cached image for a given key.
  Uint8List? getImage(String key) {
    final cachedItem = _imageBox.get(key);
    if (cachedItem != null && !_isExpired(cachedItem['expiry'])) {
      return cachedItem['data'];
    }
    _imageBox.delete(key); // Cleanup expired item.
    return null;
  }

  /// Fetches an image, either from cache or network.
  Future<Uint8List?> fetchImage(String url, [int? ttl]) async {
    final cachedImage = getImage(url);
    if (cachedImage != null) {
      return cachedImage;
    } else {
      return await cacheImage(url, ttl);
    }
  }

  /// Caches an image from a URL and returns the cached image.
  Future<Uint8List?> cacheImage(String url, [int? ttl]) async {
    if (!_shouldCacheImage(url)) {
      print("[CacheService] Skipping caching for irrelevant image: $url");
      return null;
    }

    final cachedImage = getImage(url);
    if (cachedImage != null) {
      print("[CacheService] Using cached image for key: $url");
      return cachedImage;
    }

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final imageData = response.bodyBytes;
        final compressedData = compressImage(imageData);
        final expiry = DateTime.now()
            .add(Duration(seconds: ttl ?? _defaultTTL))
            .toIso8601String();
        await _imageBox.put(url, {'data': compressedData, 'expiry': expiry});
        print("[CacheService] Image cached successfully for key: $url");
        return compressedData;
      } else {
        print("[CacheService] Failed to fetch image. HTTP status: ${response.statusCode}");
      }
    } catch (e) {
      print("[CacheService] Error fetching image: $e");
    }
    return null;
  }

  /// Determines if an image should be cached based on its URL or attributes.
  bool _shouldCacheImage(String url) {
    final excludedPatterns = ['/plugins/'];
    for (final pattern in excludedPatterns) {
      if (url.toLowerCase().contains(pattern)) {
        return false;
      }
    }
    return true;
  }

  /// Compresses an image to reduce storage size while maintaining quality.
  Uint8List compressImage(Uint8List imageData) {
    final image = img.decodeImage(imageData);
    if (image != null) {
      return Uint8List.fromList(img.encodeJpg(image, quality: 80));
    }
    print("[CacheService] Failed to compress image.");
    return imageData;
  }

  /// Checks if a cached item has expired.
  bool _isExpired(String? expiry) {
    return expiry != null && DateTime.now().isAfter(DateTime.parse(expiry));
  }

  /// Removes a specific key from the cache.
  Future<void> removeKey(String key) async {
    if (_dataBox.containsKey(key)) {
      await _dataBox.delete(key);
      print("[CacheService] Key removed from data cache: $key");
    }
    if (_imageBox.containsKey(key)) {
      await _imageBox.delete(key);
      print("[CacheService] Key removed from image cache: $key");
    }
  }
}
