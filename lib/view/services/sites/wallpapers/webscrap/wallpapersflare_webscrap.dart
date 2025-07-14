import 'package:geekcontrol/core/utils/anime_sources.dart';
import 'package:scraper/scraper.dart';

class WallpapersflareWebscrap {
  final _scraper = Scraper();

  Future<List<String>> get(String? search) async {
    final doc = await _scraper.getDocument(
      url: '${AnimeSources.wallpaperFlare}${search ?? 'anime'}&mobile=ok',
    );

    final img = _scraper.querySelectAllAttr(
      doc: doc,
      query: '.lazy',
      attr: 'data-src',
    );

    if (img == null || img.isEmpty) return [];

    if (!img.contains('N/A')) {
      return img.whereType<String>().toList();
    }
    return img.whereType<String>().toList();
  }
}
