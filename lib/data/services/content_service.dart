import 'dart:io';

import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:demoparty_assistant/data/services/cache_service.dart';
import 'package:demoparty_assistant/utils/widgets/html_based/custom_list_widget.dart';
import 'package:demoparty_assistant/utils/widgets/html_based/image_grid_widget.dart';
import 'package:demoparty_assistant/utils/widgets/html_based/text_column_widget.dart';
import 'package:demoparty_assistant/utils/widgets/universal/errors/error_helper.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'settings_service.dart';

/// A service to fetch and process content from a URL with optional caching support.
class ContentService {
  final CacheService _cacheService = GetIt.I<CacheService>();
  final SettingsService _settingsService = GetIt.I<SettingsService>();

  /// Fetches content for a given URL.
  ///
  /// Supports optional caching. If caching is disabled or `forceRefresh` is true,
  /// the content is fetched directly from the network.
  ///
  /// [url]: The URL to fetch content from.
  /// [forceRefresh]: If true, bypasses cache and fetches fresh content from the network.
  Future<List<Widget>> fetchContent(String url, {bool forceRefresh = false}) async {
    final isCacheEnabled = await _settingsService.isCacheEnabled();
    print(
        "[ContentService] Fetching content for URL: $url | Force refresh: $forceRefresh | Cache enabled: $isCacheEnabled");

    try {
      // Attempt to load from cache if caching is enabled and not forcing refresh.
      if (isCacheEnabled && !forceRefresh) {
        final cachedHtml = _cacheService.getData(url);
        if (cachedHtml != null) {
          print("[ContentService] Returning cached HTML content for URL: $url");
          return _parseHtmlInOrder(BeautifulSoup(cachedHtml), isCacheEnabled: true);
        }
      }

      // Fetch data from the network if cache is disabled or not available.
      final response = await fetchHtmlContent(url);
      if (response != null) {
        final soup = BeautifulSoup(response);

        // Cache the data only if caching is enabled.
        if (isCacheEnabled) {
          await _cacheService.setData(url, response);
        }

        return _parseHtmlInOrder(soup, isCacheEnabled: isCacheEnabled);
      } else {
        throw Exception("No response from the server for $url");
      }
    } catch (e) {
      ErrorHelper.handleError(e);
      throw Exception(ErrorHelper.getErrorMessage(e));
    }
  }

  /// Fetches raw HTML content from the network for a given URL.
  ///
  /// [url]: The URL to fetch HTML content from.
  Future<String?> fetchHtmlContent(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      print("[ContentService] HTTP status for $url: ${response.statusCode}");

      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw HttpException(
            "HTTP ${response.statusCode}: Failed to fetch content from $url");
      }
    } on http.ClientException catch (e) {
      throw SocketException("Network error occurred: $e");
    } catch (e) {
      throw Exception("Unexpected error occurred while fetching $url: $e");
    }
  }

  /// Parses the HTML content and returns a list of widgets based on its structure.
  ///
  /// If caching is disabled, images are loaded directly from their URLs.
  ///
  /// [soup]: The parsed HTML content.
  /// [isCacheEnabled]: Indicates whether caching is enabled for images.
  List<Widget> _parseHtmlInOrder(BeautifulSoup soup, {required bool isCacheEnabled}) {
    try {
      List<Widget> widgets = [];
      final elements = soup.findAll('div');

      for (var element in elements) {
        final className = element.attributes['class'] ?? '';
        if (className.contains('wpb_text_column')) {
          widgets.add(TextColumnWidget(content: element));
        } else if (className.contains('row portfolio-items') || className.contains('flickity-viewport')) {
          final imageUrls = _extractImageUrls(element);
          widgets.add(ImageGridWidget(
            images: isCacheEnabled ? _fetchOrCacheImages(imageUrls) : imageUrls,
          ));
        } else if (element.find('ul') != null) {
          final ulElement = element.find('ul', class_: 'wpb_wrapper');
          if (ulElement != null) {
            widgets.add(CustomListWidget(content: ulElement));
          }
        }
      }

      if (widgets.isEmpty) {
        throw Exception("The content retrieved has no valid sections to display.");
      }

      return widgets;
    } catch (e) {
      ErrorHelper.handleError(e);
      throw Exception(ErrorHelper.getErrorMessage(e));
    }
  }

  /// Extracts image URLs from a given HTML element.
  List<String> _extractImageUrls(Bs4Element element) {
    try {
      return element
          .findAll('img')
          .map((img) => img.attributes['src'] ?? '')
          .where((src) => src.isNotEmpty)
          .toList();
    } catch (e) {
      throw Exception("Failed to extract image URLs: ${ErrorHelper.getErrorMessage(e)}");
    }
  }

  /// Fetches cached images or returns URLs if caching is disabled.
  List<dynamic> _fetchOrCacheImages(List<String> imageUrls) {
    try {
      return imageUrls.map((url) {
        final cachedImage = _cacheService.getImage(url);
        return cachedImage ?? url;
      }).toList();
    } catch (e) {
      throw Exception("Failed to retrieve cached images: ${ErrorHelper.getErrorMessage(e)}");
    }
  }
}
