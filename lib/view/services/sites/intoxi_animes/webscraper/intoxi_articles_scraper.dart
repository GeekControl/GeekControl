import 'package:geekcontrol/view/animes/articles/articles_impl.dart';
import 'package:geekcontrol/view/animes/articles/entities/articles_entity.dart';
import 'package:geekcontrol/view/animes/sites_enum.dart';
import 'package:geekcontrol/core/utils/anime_sources.dart';
import 'package:scraper/scraper.dart';

class IntoxiArticles implements ArticlesImpl {
  final _scraper = Scraper();

  @override
  Future<List<ArticlesEntity>> get(String url) async {
    final doc = await _scraper.getDocument(url: url);

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

  @override
  Future<ArticlesEntity> getDetails(String url, ArticlesEntity entity) async {
    final doc = await _scraper.getDocument(url: url);

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
      imageUrl: imageUrl != 'NA' ? imageUrl : entity.imageUrl,
      resume: '',
      sourceUrl: entity.url,
      category: entity.category,
      url: entity.url,
      createdAt: entity.createdAt,
      updatedAt: DateTime.now(),
      site: SitesEnum.intoxi.name,
    );
  }

  @override
  Future<List<ArticlesEntity>> search(String q) async {
    return await get('${AnimeSources.intoxiUriStr}?s=$q');
  }
}
