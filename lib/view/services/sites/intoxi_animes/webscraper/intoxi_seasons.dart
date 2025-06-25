import 'package:flutter/material.dart';
import 'package:geekcontrol/core/utils/anime_sources.dart';
import 'package:geekcontrol/view/services/sites/intoxi_animes/entities/intoxi_seasons_entity.dart';
import 'package:scraper/scraper.dart';

class IntoxiSeasons extends ChangeNotifier {
  final _scraper = Scraper();
  final List<IntoxiSeasonsEntity> seasonList = <IntoxiSeasonsEntity>[];

  Future<void> init() async {
    await _seasons();
  }

  Future<void> _seasons() async {
    final doc = await _scraper.getDocument(
        url: '${AnimeSources.intoxiUriStr}category/guia-da-temporada/');

    final element = doc.querySelectorAll('.post-row');

    for (final e in element) {
      final title = _scraper.elementSelect(
        element: e,
        selector: 'h2.post-title.entry-title',
      );

      final image = _scraper.elementSelectAttr(
        element: e,
        selector: '.post-thumbnail img',
        attr: 'src',
      );

      final date = _scraper.elementSelect(
        element: e,
        selector: '.post-date',
      );

      final description = _scraper.elementSelect(
        element: e,
        selector: '.entry.excerpt.entry-summary',
      );

      final href = _scraper.elementSelectAttr(
        element: e,
        selector: 'h2.post-title.entry-title a',
        attr: 'href',
      );

      if (href == null) {
        continue;
      }
      seasonList.add(
        IntoxiSeasonsEntity(
          title: title ?? '',
          image: image ?? '',
          date: date ?? '',
          description: description ?? '',
          href: href,
        ),
      );
      notifyListeners();
    }
  }
}
