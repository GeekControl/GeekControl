import 'package:html/dom.dart';
import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class ScraperV2 {
  Future<Document> document({
    required String url,
    bool? showPageBody,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        if (showPageBody ?? false) {
          Logger().i(response.body);
        }

        return parser.parse(response.body);
      } else {
        throw Exception(
          'Failed to load document. \n StatusCode: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error fetching document: $e');
    }
  }

  Future<Document> postDocument(
    String url,
    Map<String, String>? headers,
  ) async {
    final response = await http.post(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      return parser.parse(response.body);
    } else {
      throw Exception(
        'Failed to post document. \n StatusCode: ${response.statusCode}',
      );
    }
  }

  String? elementToString({required List<String> elements}) {
    try {
      return elements.join('\n');
    } catch (e) {
      Exception('Error in elementToString: $e');
      return null;
    }
  }

  String? elementSelec({required Element element, required String selector}) {
    try {
      return element.querySelector(selector)?.text.trim();
    } catch (e) {
      Exception('Error in elementSelec: $e');
      return null;
    }
  }

  String? elementSelecAttr({
    required Element element,
    required String selector,
    required String attr,
  }) {
    try {
      return element.querySelector(selector)?.attributes[attr];
    } catch (e) {
      Exception('Error in elementSelecAttr: $e');
      return null;
    }
  }

  String? docSelec(Document doc, String query) {
    try {
      return doc.querySelector(query)?.text.trim();
    } catch (e) {
      Exception('Error in docSelec: $e');
      return null;
    }
  }

  List<String>? docSelecAll({required Document doc, required String query}) {
    try {
      return doc.querySelectorAll(query).map((e) => e.text).toList();
    } catch (e) {
      Exception('Error in docSelecAll: $e');
      return null;
    }
  }

  List<String>? docSelecAllMultiple({
    required Document doc,
    required List<String> queries,
  }) {
    try {
      final List<String> results = [];

      for (String query in queries) {
        final elements =
            doc.querySelectorAll(query).map((e) => e.text).toList();
        results.addAll(elements);
      }

      return results.isNotEmpty ? results : null;
    } catch (e) {
      Exception('Error in docSelecAllMultiple: $e');
      return null;
    }
  }

  List<String?>? docSelecAllAttr({
    required Document doc,
    required String query,
    required String attr,
  }) {
    try {
      return doc
          .querySelectorAll(query)
          .map((e) => e.attributes[attr])
          .toList();
    } catch (e) {
      Exception('Error in elementSelectAllAttr: $e');
      return null;
    }
  }

  List<String?>? docSelecAllAttrMultiple({
    required Document doc,
    required List<String> queries,
    required String attr,
  }) {
    try {
      final List<String?> results = [];
      for (String query in queries) {
        final elements =
            doc.querySelectorAll(query).map((e) => e.attributes[attr]).toList();
        results.addAll(elements);
      }
      return results.isNotEmpty ? results : null;
    } catch (e) {
      Exception('Error in docSelecAllAttrMultiple: $e');
      return null;
    }
  }

  List<String?>? elementSelectAllAttr(
    Element element,
    String query,
    String attr,
  ) {
    try {
      return element
          .querySelectorAll(query)
          .map((e) => e.attributes[attr])
          .toList();
    } catch (e) {
      Exception('Error in elementSelectAllAttr: $e');
      return null;
    }
  }

  List<String?>? removeHtmlElementsList(
    List<String?> content,
    List<String> elements,
  ) {
    try {
      final updatedContent =
          content.where((c) => !elements.any((e) => c!.contains(e))).toList();
      content.clear();
      content.addAll(updatedContent);
      return content;
    } catch (e) {
      Exception('Error in removeHtmlElementsList: $e');
      return null;
    }
  }

  String? docSelecAttr({
    required Document doc,
    required String query,
    required String attr,
  }) {
    try {
      return doc.querySelector(query)?.attributes[attr];
    } catch (e) {
      Exception('Error in docSelecAttr: $e');
      return null;
    }
  }

  List<String?>? removeHtmlElements(List<String?> content, String element) {
    try {
      final updatedContent =
          content.where((c) => !c!.contains(element)).toList();
      content.clear();
      content.addAll(updatedContent);
      return content;
    } catch (e) {
      Exception('Error in removeHtmlElements: $e');
      return null;
    }
  }

  List<String>? extractImage({
    required Document doc,
    required String query,
    required List<String> tagSelector,
    required String attr,
  }) {
    try {
      final images = docSelecAttr(doc: doc, query: query, attr: attr);
      final imagesElements = doc.querySelectorAll(query);
      final Set<String> uniqueImages = {};

      for (var selector in tagSelector) {
        for (var element in imagesElements) {
          final attrValue = element.attributes[selector];
          if (attrValue != null) {
            uniqueImages.add(attrValue);
          }
        }
      }
      if (images != null) {
        uniqueImages.add(images);
      }
      return uniqueImages.toList();
    } catch (e) {
      Exception('Error in extractImage: $e');
      return null;
    }
  }

  List<String>? extractImagesAttr({
    required Document doc,
    required String query,
    required List<String> tagSelector,
    required String attr,
  }) {
    try {
      final Set<String> uniqueImages = {};
      final imagesElements = doc.querySelectorAll(query);

      for (var selector in tagSelector) {
        for (var element in imagesElements) {
          final attrValue = element.attributes[selector];
          if (attrValue != null) {
            uniqueImages.add(attrValue);
          }
        }
      }
      return uniqueImages.toList();
    } catch (e) {
      Exception('Error in Error in extractText: $e: $e');
      return null;
    }
  }

  List<String>? extractText({
    required Document doc,
    required List<String> query,
    required List<String> tagToSelector,
  }) {
    try {
      final List<String> result = [];
      for (var query in query) {
        for (var selector in tagToSelector) {
          final elements = doc.querySelectorAll('$query $selector');
          if (elements.isNotEmpty) {
            result.addAll(
              elements.map((e) => e.text).where((text) => text.isNotEmpty),
            );
            return result;
          }
        }
      }
      return result.isNotEmpty ? result : null;
    } catch (e) {
      Exception('Error in extractText: $e');
      return null;
    }
  }

  List<String?> selecHref({
    required Document doc,
    required String query,
    String? attr,
    bool reverse = true,
  }) {
    final Set<String> seenHrefs = {};
    List<String?> href = (docSelecAllAttr(
              doc: doc,
              query: query,
              attr: attr ?? 'href',
            ) ??
            [])
        .map((href) => href?.trim())
        .where((href) => href!.isNotEmpty && seenHrefs.add(href))
        .toList();

    if (reverse) {
      return href = href.reversed.toList();
    }
    return href;
  }

  List<String> selecChapters({
    required Document doc,
    required String query,
    bool reverse = true,
  }) {
    final Set<String> seenChapters = {};

    final List<String> chapters = (docSelecAll(doc: doc, query: query) ?? [])
        .map((chapter) => chapter.trim())
        .where((chapter) => chapter.isNotEmpty && seenChapters.add(chapter))
        .toList();

    return reverse ? chapters.reversed.toList() : chapters;
  }

  Map<String, String> parseMangaDetails(
    dynamic details,
    List<String> keysToExtract,
  ) {
    final Map<String, String> map = {};
    final List<String> lines =
        (details is String ? details.split('\n') : details as List<String>)
            .map((line) => line.trim())
            .where((line) => line.isNotEmpty)
            .toList();

    String? currentKey;

    for (var line in lines) {
      if (keysToExtract.contains(line)) {
        currentKey = line;
      } else if (currentKey != null && line.isNotEmpty) {
        map[currentKey] = line;
        currentKey = null;
      } else {
        final separatorIndex = line.indexOf(RegExp(r':\s| '));
        if (separatorIndex != -1) {
          final key = line.substring(0, separatorIndex).trim();
          final value = line.substring(separatorIndex + 1).trim();

          if (keysToExtract.contains(key) && value.isNotEmpty) {
            map[key] = value;
          }
        }
      }
    }

    return map;
  }
}
