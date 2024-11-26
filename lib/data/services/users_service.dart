import 'dart:convert';
import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:demoparty_assistant/data/services/cache_service.dart';
import 'package:demoparty_assistant/data/services/settings_service.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

class UsersService {
  final CacheService _cacheService = GetIt.I<CacheService>();
  final SettingsService _settingsService = GetIt.I<SettingsService>();
  static const String _cacheKey = 'users_list';

  /// Fetches the list of users from the website with caching support.
  /// Also calculates country statistics in one operation.
  Future<Map<String, dynamic>> fetchUsersWithStats({bool forceRefresh = false}) async {
    final isCacheEnabled = await _settingsService.isCacheEnabled();
    if (isCacheEnabled && !forceRefresh) {
      final cachedUsers = _cacheService.getData(_cacheKey);
      if (cachedUsers != null) {
        print("[UsersService] Returning cached users and statistics.");
        final decodedData = jsonDecode(cachedUsers);

        // Validate cached structure
        if (decodedData is Map<String, dynamic> &&
            decodedData['users'] is List &&
            decodedData['countryStats'] is Map) {
          return {
            'users': List<Map<String, String>>.from(
              decodedData['users'].map((user) => Map<String, String>.from(user)),
            ),
            'countryStats': Map<String, int>.from(decodedData['countryStats']),
          };
        } else {
          print("[UsersService] Cached data structure is invalid. Refetching.");
        }
      }
    }

    print("[UsersService] Fetching users from remote source.");
    final List<Map<String, String>> users = [];
    final Map<String, int> countryStats = {};

    try {
      final response = await http.get(Uri.parse('https://party.xenium.rocks/visitors'));

      if (response.statusCode == 200) {
        final BeautifulSoup soup = BeautifulSoup(response.body);
        final userList = soup.find('ul', class_: 'list-unstyled');
        final userItems = userList?.findAll('li') ?? [];

        for (var item in userItems) {
          final name = item.text.trim();
          final flagElement = item.find('i', class_: 'flag-');
          final countryCode = flagElement?.className.split('-').last ?? '';
          final countryName = flagElement?.attributes['title'] ?? '';

          if (name.isNotEmpty && countryName.isNotEmpty) {
            users.add({
              'name': name,
              'country': countryName,
              'countryCode': countryCode,
            });

            // Update country statistics
            countryStats[countryName] = (countryStats[countryName] ?? 0) + 1;
          }
        }

        if (isCacheEnabled) {
          await _cacheService.setData(
            _cacheKey,
            jsonEncode({
              'users': users,
              'countryStats': countryStats,
            }),
          );
        }
      } else {
        throw Exception("Failed to fetch users. HTTP Status: ${response.statusCode}");
      }
    } catch (e) {
      print("[UsersService] Error fetching users: $e");
      rethrow;
    }

    return {
      'users': users,
      'countryStats': countryStats,
    };
  }
}
