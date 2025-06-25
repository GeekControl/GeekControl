import 'package:geekcontrol/view/animes/articles/entities/articles_entity.dart';
import 'package:geekcontrol/view/animes/sites_enum.dart';
import 'package:geekcontrol/core/utils/anime_sources.dart';
import 'package:logger/logger.dart';
import 'package:scraper/scraper.dart';

class AnimeUnited {
  final _scraper = Scraper();
  Future<List<ArticlesEntity>> fetchArticles() async {
    final List<ArticlesEntity> articlesList = [];

    final doc = await _scraper.getDocument(url: AnimeSources.animeUnitedUri);
    final element = doc.querySelectorAll('.col-12.col-4-tablet.post-column');

    for (var e in element) {
      final title = _scraper.elementSelect(
        element: e,
        selector: '.entry-content p',
      );
      final images = _scraper.elementSelectAttr(
        element: e,
        selector: '.col-12.col-4-tablet.post-column img',
        attr: 'data-lazy-src',
      );
      final href = _scraper.elementSelectAttr(
        element: e,
        selector: '.col-12.col-4-tablet.post-column a',
        attr: 'href',
      );
      final date = _scraper.elementSelect(
        element: e,
        selector: '.entry-date.published.updated',
      );

      if (href == null || href.isEmpty) continue;

      final articles = ArticlesEntity(
        title: title ?? '',
        imageUrl: images,
        date: date ?? '',
        author: 'N/A',
        category: '',
        content: '',
        url: href,
        sourceUrl: href,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        resume: '',
        site: SitesEnum.animeUnited.key,
      );
      articlesList.add(articles);
      Logger().i(articles.url);
    }
    return articlesList;
  }

  Future<ArticlesEntity> scrapeArticleDetails(
      String articleUrl, ArticlesEntity articles) async {
    final doc = await _scraper.getDocument(url: articles.url);
    final content = _scraper.querySelectorAll(
      doc: doc,
      query: '.container-full p',
    );

    if (content == null || content.isEmpty) return ArticlesEntity.empty();

    Logger().i(content);
    return ArticlesEntity(
      title: articles.title,
      author: articles.author,
      date: articles.date,
      content: content.join('\n'),
      imageUrl: articles.imageUrl,
      resume: '',
      sourceUrl: articles.url,
      category: articles.category,
      url: articles.url,
      createdAt: articles.createdAt,
      updatedAt: DateTime.now(),
      site: SitesEnum.animeUnited.name,
    );
  }
}
