import 'package:geekcontrol/view/animes/articles/entities/articles_entity.dart';
import 'package:geekcontrol/view/animes/sites_enum.dart';
import 'package:geekcontrol/core/utils/anime_sources.dart';
import 'package:scraper/scraper.dart';

class VoceSabiaAnime {
  final _scraper = Scraper();

  Future<List<ArticlesEntity>> fetchArticles() async {
    final List<ArticlesEntity> articlesList = [];

    final doc = await _scraper.getDocument(url: AnimeSources.voceSabiaAnimeUri);

    final element = doc.querySelectorAll('.ultp-block-content-wrap');

    for (final e in element) {
      final title =
          _scraper.elementSelect(element: e, selector: 'h2.ultp-block-title a');
      final images = _scraper.elementSelectAttr(
        element: e,
        selector: '.ultp-block-image.ultp-block-image-zoomIn img',
        attr: 'src',
      );
      final date = _scraper.elementSelect(
        element: e,
        selector: 'span.ultp-block-date.ultp-block-meta-element',
      );
      final url = _scraper.elementSelect(
        element: e,
        selector: 'h2.ultp-block-title href',
      );

      if (url == null || url.isEmpty) continue;

      final articles = ArticlesEntity(
        title: title ?? '',
        imageUrl: images,
        date: date ?? '',
        author: '',
        category: '',
        content: title ?? '',
        url: url,
        sourceUrl: '',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        resume: '',
        site: SitesEnum.voceSabiaAnime.key,
      );
      articlesList.add(articles);
    }
    return articlesList;
  }
}
