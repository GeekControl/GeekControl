import 'package:geekcontrol/view/animes/articles/entities/articles_entity.dart';
import 'package:geekcontrol/view/animes/sites_enum.dart';
import 'package:geekcontrol/core/utils/anime_sources.dart';
import 'package:scraper/scraper.dart';

class IntoxiArticles {
  final _scraper = Scraper();
  Future<List<ArticlesEntity>> scrapeArticles(String uri) async {
    final doc = await _scraper.getDocument(url: uri);

    final List<ArticlesEntity> scrapeList = [];
    final element = doc.querySelectorAll('article');

    for (final e in element) {
      final title = _scraper.elementSelect(
        element: e,
        selector: '.post-title.entry-title a',
      );
      final date = _scraper.elementSelectAttr(
        element: e,
        selector: 'time.published',
        attr: 'datetime',
      );
      final author = _scraper.elementSelect(
        element: e,
        selector: '.post-byline .fn a',
      );
      final href = _scraper.elementSelectAttr(
        element: e,
        selector: '.post-title.entry-title a',
        attr: 'href',
      );
      final category = _scraper.elementSelect(
        element: e,
        selector: '.post-category a',
      );
      final imageUrl = _scraper.elementSelectAttr(
        element: e,
        selector: '.post-thumbnail img',
        attr: 'src',
      );
      final resume = _scraper.elementSelect(
        element: e,
        selector: '.entry.excerpt.entry-summary',
      );

      if (href == null || href.isEmpty) continue;

      if (!scrapeList.any((article) => article.title == title)) {
        final articles = ArticlesEntity(
          title: title ?? '',
          imageUrl: imageUrl,
          date: date ?? '',
          author: author ?? 'N/A',
          category: category ?? '',
          content: '',
          url: href,
          sourceUrl: href,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          resume: resume ?? '',
          site: SitesEnum.intoxi.name,
        );
        scrapeList.add(articles);
      }
    }
    return scrapeList;
  }

  Future<List<ArticlesEntity>> searchArticles({required String article}) async {
    return await scrapeArticles('${AnimeSources.intoxiUriStr}?s=$article');
  }

  Future<ArticlesEntity> scrapeArticleDetails(
      String articleUrl, ArticlesEntity articles) async {
    final doc = await _scraper.getDocument(url: articleUrl);

    final title = _scraper.querySelector(
      doc: doc,
      query: 'h1.post-title.entry-title',
    );
    final author = _scraper.querySelector(
      doc: doc,
      query: '.post-byline .fn a',
    );
    final date = _scraper.querySelectAttr(
      doc: doc,
      query: 'time.published',
      attr: 'datetime',
    );
    final content = _scraper.querySelectorAll(
      doc: doc,
      query: '.entry p',
    );
    var imageUrl = _scraper.querySelectAttr(
      doc: doc,
      query: '.entry-inner img',
      attr: 'src',
    );

    if (content != null && content.isNotEmpty) {
      _scraper.removeHtmlElement(content: content, elements: [
        'twitter',
        '@',
        'Relacionado',
        'Staff',
        'Visual liberado junto do trailer'
      ]);
    }

    return ArticlesEntity(
      title: title ?? '',
      author: author ?? '',
      date: date ?? '',
      content:
          (content != null && content.isNotEmpty) ? content.join('\n') : '',
      imageUrl: imageUrl != 'NA' ? imageUrl : articles.imageUrl,
      resume: '',
      sourceUrl: articles.url,
      category: articles.category,
      url: articles.url,
      createdAt: articles.createdAt,
      updatedAt: DateTime.now(),
      site: SitesEnum.intoxi.name,
    );
  }
}
