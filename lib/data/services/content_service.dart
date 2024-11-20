import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:demoparty_assistant/data/services/cache_service.dart';
import 'package:demoparty_assistant/utils/widgets/html_based/custom_list_widget.dart';
import 'package:demoparty_assistant/utils/widgets/html_based/portfolio_grid_widget.dart';
import 'package:demoparty_assistant/utils/widgets/html_based/text_column_widget.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

class ContentService {
  final CacheService _cacheService = GetIt.I<CacheService>();

  /// Fetches content with optional force refresh.
  Future<List<Widget>> fetchContent(String url, {bool forceRefresh = false}) async {
    const cacheTTL = 30; // Cache TTL in seconds
    print("[ContentService] Fetching content for URL: $url, forceRefresh: $forceRefresh");

    // Attempt to retrieve cached HTML
    if (!forceRefresh) {
      final cachedHtml = _cacheService.get(url);
      if (cachedHtml != null) {
        print("[ContentService] Returning cached HTML content for URL: $url");
        return _parseHtmlInOrder(BeautifulSoup(cachedHtml));
      }
    }

    print("[ContentService] Fetching HTML content for $url from network.");
    final response = await _fetchHtmlContent(url);

    if (response != null) {
      // Cache the raw HTML response
      await _cacheService.set(url, response, cacheTTL);

      // Parse the HTML and return widgets
      return _parseHtmlInOrder(BeautifulSoup(response));
    } else {
      throw Exception("Failed to fetch content from $url");
    }
  }

  /// Fetches raw HTML content from the given URL.
  Future<String?> _fetchHtmlContent(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      print("[ContentService] HTTP status for $url: ${response.statusCode}");

      if (response.statusCode == 200) {
        return response.body;
      } else {
        print("[ContentService] Error: HTTP ${response.statusCode} for $url");
      }
    } catch (e) {
      print("[ContentService] Error fetching $url: $e");
    }

    return null;
  }

  /// Parses HTML into a list of widgets.
  List<Widget> _parseHtmlInOrder(BeautifulSoup soup) {
    List<Widget> widgets = [];
    final elements = soup.findAll('div');

    print("[ContentService] Parsing HTML. Found ${elements.length} <div> elements.");

    for (var element in elements) {
      if (element.attributes['class']?.contains('wpb_text_column') == true) {
        widgets.add(TextColumnWidget(content: element));
      } else if (element.attributes['class']?.contains('row portfolio-items') == true) {
        widgets.add(PortfolioGridWidget(content: element));
      } else if (element.find('ul') != null) {
        final ulElement = element.find('ul');
        if (ulElement != null) {
          widgets.add(CustomListWidget(content: ulElement));
        }
      }
    }

    if (widgets.isEmpty) {
      print("[ContentService] No valid widgets found in parsed HTML.");
      throw Exception("No valid content found to display.");
    }

    print("[ContentService] Successfully parsed HTML into ${widgets.length} widgets.");
    return widgets;
  }
}
