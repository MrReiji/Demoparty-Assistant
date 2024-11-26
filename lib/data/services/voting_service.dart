import 'dart:convert';
import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:demoparty_assistant/data/services/cache_service.dart';
import 'package:demoparty_assistant/data/services/settings_service.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

class VotingService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final CacheService _cacheService = GetIt.I<CacheService>();
  final SettingsService _settingsService = GetIt.I<SettingsService>();

  static const String _categoriesCacheKey = 'voting_categories';
  static const String _entriesCacheKeyPrefix = 'voting_entries_';

  /// Pobierz ciasteczko sesji
  Future<Map<String, String>> _getHeaders() async {
    final sessionCookie = await _storage.read(key: 'session_cookie');
    if (sessionCookie == null || sessionCookie.isEmpty) {
      throw Exception("Session expired. Please log in again.");
    }
    print("[VotingService] Session cookie fetched successfully.");
    return {"Cookie": sessionCookie};
  }

  /// Pobierz kategorie głosowania z obsługą cachowania
  Future<List<Category>> fetchCategories({bool forceRefresh = false}) async {
    final isCacheEnabled = await _settingsService.isCacheEnabled();
    print("[VotingService] Cache enabled: $isCacheEnabled");
    if (isCacheEnabled && !forceRefresh) {
      final cachedCategories = _cacheService.getData(_categoriesCacheKey);
      if (cachedCategories != null) {
        print("[VotingService] Returning cached categories.");
        final List<dynamic> decodedData = jsonDecode(cachedCategories);
        return decodedData.map((cat) => Category(name: cat['name'], url: cat['url'])).toList();
      }
    }

    const url = 'https://party.xenium.rocks/voting';
    print("[VotingService] Fetching categories from: $url");

    final headers = await _getHeaders();

    try {
      final response = await http.get(Uri.parse(url), headers: headers);
      if (response.statusCode != 200) {
        throw Exception("Failed to load categories. Status code: ${response.statusCode}");
      }

      final soup = BeautifulSoup(response.body);
      final categories = soup.findAll('li').where((li) {
        final ulParent = li.parent;
        return ulParent == null || !ulParent.classes.contains('nav') || !ulParent.classes.contains('navbar-nav');
      }).map((li) {
        final link = li.find('a');
        if (link == null) return null;
        final name = link.text.trim();
        final url = 'https://party.xenium.rocks${link.attributes['href']}';
        return Category(name: name, url: url);
      }).whereType<Category>().toList();

      if (isCacheEnabled) {
        await _cacheService.setData(
          _categoriesCacheKey,
          jsonEncode(categories.map((cat) => {'name': cat.name, 'url': cat.url}).toList()),
        );
      }

      return categories;
    } catch (e) {
      print("[VotingService] Error fetching categories: $e");
      rethrow;
    }
  }

  /// Pobierz dane głosowania dla wybranej kategorii z obsługą cachowania
  Future<List<VotingEntry>> fetchVotingData(String url, {bool forceRefresh = false}) async {
    final isCacheEnabled = await _settingsService.isCacheEnabled();
    final cacheKey = '$_entriesCacheKeyPrefix${Uri.parse(url).pathSegments.last}';

    if (isCacheEnabled && !forceRefresh) {
      final cachedEntries = _cacheService.getData(cacheKey);
      if (cachedEntries != null) {
        print("[VotingService] Returning cached voting entries for $url.");
        final List<dynamic> decodedData = jsonDecode(cachedEntries);
        return decodedData
            .map((entry) => VotingEntry(
                  rank: entry['rank'],
                  title: entry['title'],
                  author: entry['author'],
                  imageUrl: entry['imageUrl'],
                ))
            .toList();
      }
    }

    print("[VotingService] Fetching voting data for URL: $url");

    final headers = await _getHeaders();

    try {
      final response = await http.get(Uri.parse(url), headers: headers);
      if (response.statusCode != 200) {
        throw Exception("Failed to load voting data. Status code: ${response.statusCode}");
      }

      final soup = BeautifulSoup(response.body);
      final entries = soup.findAll('div', class_: 'thumbnail image').map((entry) {
        final rankText = entry.find('span', class_: 'label')?.text?.replaceAll('#', '') ?? '0';
        final rank = int.parse(rankText);
        final title = entry.find('b')?.text ?? 'Unknown';
        final author = entry.find('p')?.text ?? 'Unknown';
        final imageUrl = entry.find('img')?.attributes['src'] ?? '';
        return VotingEntry(
          rank: rank,
          title: title,
          author: author,
          imageUrl: 'https://party.xenium.rocks$imageUrl',
        );
      }).whereType<VotingEntry>().toList();

      if (isCacheEnabled) {
        await _cacheService.setData(
          cacheKey,
          jsonEncode(entries.map((entry) => {
                'rank': entry.rank,
                'title': entry.title,
                'author': entry.author,
                'imageUrl': entry.imageUrl,
              }).toList()),
        );
      }

      return entries;
    } catch (e) {
      print("[VotingService] Error fetching voting data: $e");
      rethrow;
    }
  }
}

class Category {
  final String name;
  final String url;

  Category({required this.name, required this.url});
}

class VotingEntry {
  final int rank;
  final String title;
  final String author;
  final String imageUrl;

  VotingEntry({required this.rank, required this.title, required this.author, required this.imageUrl});
}
