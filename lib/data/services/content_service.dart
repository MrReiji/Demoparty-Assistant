import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:demoparty_assistant/utils/widgets/custom_image_widget.dart';
import 'package:demoparty_assistant/utils/widgets/heading_widget.dart';
import 'package:demoparty_assistant/utils/widgets/news/bullet_list_widget.dart';
import 'package:demoparty_assistant/utils/widgets/news/links_section_widget.dart';
import 'package:demoparty_assistant/utils/widgets/news/paragraph_widget.dart';
import 'package:demoparty_assistant/utils/widgets/news/yt_video_widget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ContentService {
  /// Pobiera i przetwarza treść HTML z podanego URL.
  Future<List<Widget>> fetchContent(String url) async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      BeautifulSoup soup = BeautifulSoup(response.body);

      // Znajduje pierwszy element z klasą 'wpb_wrapper'
      Bs4Element? contentElement = soup.find('div', class_: 'wpb_wrapper');

      print('Przetwarzanie pierwszego elementu z klasą "wpb_wrapper"');

      if (contentElement != null) {
        List<Widget> contentWidgets = [];
        List<Map<String, String>> collectedLinks = [];

        // Przetwarzamy znaleziony element 'wpb_wrapper'
        _parseContent(contentElement, contentWidgets, collectedLinks);

        // Dodaje sekcję z linkami, jeśli zebrano jakiekolwiek linki
        if (collectedLinks.isNotEmpty) {
          print('Dodawanie LinksSectionWidget z ${collectedLinks.length} linkami');
          contentWidgets.add(LinksSectionWidget(collectedLinks: collectedLinks));
        }

        return contentWidgets;
      } else {
        throw Exception("Nie znaleziono elementu z klasą 'wpb_wrapper'");
      }
    } else {
      throw Exception("Błąd podczas pobierania treści");
    }
  }

  /// Parsuje treść HTML, zbierając paragrafy, listy, obrazy i inne elementy.
  void _parseContent(Bs4Element element, List<Widget> contentWidgets,
      List<Map<String, String>> collectedLinks,
      {int depth = 0}) {
    String indent = '  ' * depth;
    print(
        '${indent}Przetwarzanie elementu: ${element.name}, klasy: ${element.className}');
    for (var child in element.children) {
      print(
          '${indent}  Przetwarzanie child: ${child.name}, klasy: ${child.className}');
      if (child.name == 'p') {
        // Przetwarza paragraf
        String processedText = child.text.trim();
        if (processedText.isNotEmpty && !processedText.contains('<!--')) {
          print(
              '${indent}    Dodawanie ParagraphWidget z tekstem: "$processedText"');
          contentWidgets.add(ParagraphWidget(text: processedText));
        }
        // Zbiera linki
        _collectLinks(child, collectedLinks);
      } else if (child.name == 'ul' || child.name == 'ol') {
        // Przetwarza listy
        print('${indent}    Dodawanie BulletListWidget');
        contentWidgets.add(BulletListWidget(ulElement: child));
        // Zbiera linki
        _collectLinks(child, collectedLinks);
      } else if (child.name == 'img') {
        // Przetwarza obraz
        String? imgSrc = child.attributes['src'];
        if (imgSrc != null && imgSrc.isNotEmpty) {
          print('${indent}    Dodawanie CustomImageWidget z src: $imgSrc');
          contentWidgets.add(CustomImageWidget(imageUrl: imgSrc));
        }
      } else if (child.name == 'iframe') {
        // Przetwarza wideo YouTube
        String? videoUrl = child.attributes['src'];
        if (videoUrl != null) {
          final videoId = YoutubePlayer.convertUrlToId(videoUrl);
          if (videoId != null) {
            print('${indent}    Dodawanie YoutubeVideoWidget z videoId: $videoId');
            contentWidgets.add(YoutubeVideoWidget(videoId: videoId));
          }
        }
      } else if (child.name == 'h1' ||
          child.name == 'h2' ||
          child.name == 'h3' ||
          child.name == 'h4' ||
          child.name == 'h5' ||
          child.name == 'h6') {
        // Przetwarza nagłówki
        String headingText = child.text.trim();
        if (headingText.isNotEmpty) {
          int level = int.parse(child.name!.substring(1));
          print(
              '${indent}    Dodawanie HeadingWidget poziom $level z tekstem: "$headingText"');
          contentWidgets.add(HeadingWidget(text: headingText, level: level));
        }
      } else if (child.name == 'div' ||
          child.name == 'section' ||
          child.name == 'article' ||
          child.name == 'span') {
        // Rekurencyjnie przetwarza elementy potomne
        print('${indent}    Rekurencyjne przetwarzanie elementu ${child.name}');
        _parseContent(child, contentWidgets, collectedLinks, depth: depth + 1);
      } else {
        // Ignoruje inne elementy lub przetwarza je rekurencyjnie, jeśli mają dzieci
        if (child.children.isNotEmpty) {
          print(
              '${indent}    Element ${child.name} ma dzieci, rekurencyjne przetwarzanie');
          _parseContent(child, contentWidgets, collectedLinks, depth: depth + 1);
        } else {
          print('${indent}    Ignorowanie elementu ${child.name}');
        }
      }
    }
  }

  /// Zbiera hiperłącza z elementu.
  void _collectLinks(
      Bs4Element element, List<Map<String, String>> collectedLinks) {
    var links = element.findAll('a');
    for (var link in links) {
      String linkText = link.text.trim();
      String? linkHref = link.attributes['href'];
      if (linkHref != null &&
          linkText.isNotEmpty &&
          !linkHref.contains("email-protection")) {
        print('      Zbieranie linku: tekst="$linkText", url="$linkHref"');
        collectedLinks.add({'text': linkText, 'url': linkHref});
      }
    }
  }
}
