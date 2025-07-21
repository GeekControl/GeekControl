import 'package:logger/web.dart';
import 'package:scraper/scraper.dart';

class AlphacodersWebscrap {
  final String _url = 'https://alphacoders.com';
  final _scraper = Scraper();

  Future<List<String>> get({String? query, int page = 1}) async {
    final slug = _toSlug(query) ?? 'anime';
    final url = '$_url/$slug-phone-wallpapers?page=$page';
    Logger().i('Fetching images from $url');

    final List<String> images = [];
    final doc = await _scraper.getDocument(url: url);
    final element = doc.querySelectorAll('.item');

    for (final e in element) {
      final img =
          _scraper.elementSelectAttr(element: e, selector: 'img', attr: 'src');
      if (img != null && img.isNotEmpty) {
        images.add(img);
      }
    }

    return images;
  }

  String? _toSlug(String? text) {
    if (text == null || text.isEmpty) return null;
    return text.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '-');
  }
}
