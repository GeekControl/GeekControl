import 'package:geekcontrol/view/animes/articles/entities/articles_entity.dart';
import 'package:geekcontrol/view/animes/sites_enum.dart';
import 'package:geekcontrol/core/utils/anime_sources.dart';
import 'package:html/dom.dart';
import 'package:scraper/scraper.dart';

class MangaNews {
  final _scraper = Scraper();

  Future<List<ArticlesEntity>> scrapeArticles() async {
    final List<ArticlesEntity> scrapeList = [];

    final Document doc =
        await _scraper.getDocument(url: AnimeSources.animesNewUriStr);
    final element = doc.querySelectorAll('.list-holder');

    for (final e in element) {
      if (!e.classes.contains('sidebar-wrap')) {
        final title = _scraper.elementSelect(
              element: e,
              selector: '.entry-title a',
            ) ??
            '';
        final description = _scraper.elementSelect(
              element: e,
              selector: '.entry-summary',
            ) ??
            '';
        final image = _scraper.elementSelectAttr(
              element: e,
              selector: '.block-inner img',
              attr: 'src',
            ) ??
            '';
        final sourceUrl = _scraper.elementSelectAttr(
          element: e,
          selector: '.entry-title a',
          attr: 'href',
        );

        if (sourceUrl == null || sourceUrl.isEmpty) continue;

        if (!scrapeList.any((article) => article.title == title)) {
          final article = ArticlesEntity(
            title: title,
            imageUrl: image,
            date: '',
            author: '',
            resume: description,
            category: '',
            content: '',
            url: sourceUrl,
            sourceUrl: sourceUrl,
            site: SitesEnum.animesNew.name,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );
          scrapeList.add(article);
        }
      }
    }
    return scrapeList;
  }

  Future<ArticlesEntity> scrapeArticleDetails(
    String url,
    ArticlesEntity entity,
  ) async {
    final Document doc = await _scraper.getDocument(url: url);

    final images = _scraper.extractImages(
      doc: doc,
      query: '.s-feat img',
      tagSelector: ['data-lazy-src', 'src'],
      attr: 'src',
    );

    final List<String>? content = _scraper.extractText(
      doc: doc,
      query: ['.s-ct'],
      tagToSelector: ['p', 'em', 'h1', 'li'],
    );

    final String date =
        _scraper.querySelector(doc: doc, query: 'time.date.published') ?? '';

    _scraper.removeHtmlElement(
      content: content ?? [],
      elements: ['<img', '<iframe'],
    );

    final author = _scraper.querySelector(
      doc: doc,
      query: '.meta-el a',
    );

    return ArticlesEntity(
      title: entity.title,
      imageUrl: entity.imageUrl,
      date: date,
      author: author ?? 'N/A',
      category: entity.category,
      content: content?.join('\n') ?? '',
      url: url,
      resume: '',
      sourceUrl: entity.sourceUrl ?? url,
      createdAt: entity.createdAt,
      updatedAt: DateTime.now(),
      imagesPage: images,
      site: SitesEnum.animesNew.name,
    );
  }

  Future<List<ArticlesEntity>> searchArticle(String article) async {
    final List<ArticlesEntity> articlesList = [];
    final doc = await _scraper.getDocument(
        url: '${AnimeSources.animesNewUriStr}?s=$article');

    final element = doc.querySelectorAll('.p-wrap.p-grid.p-grid-1');

    for (final e in element) {
      final images = _scraper.elementSelectAttr(
          element: e, selector: '.p-featured img', attr: 'src');
      final title =
          _scraper.elementSelect(element: e, selector: '.entry-title a');
      final author = _scraper.elementSelect(
          element: e, selector: '.meta-el.meta-author a');
      final url = _scraper.elementSelectAttr(
          element: e, selector: '.entry-title a', attr: 'href');

      articlesList.add(
        ArticlesEntity(
          title: title ?? '',
          imageUrl: images ?? '',
          date: '',
          author: author ?? '',
          category: '',
          content: '',
          url: url ?? '',
          sourceUrl: '',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          resume: '',
          site: SitesEnum.animesNew.name,
          imagesPage: [],
        ),
      );
    }
    if (articlesList.isEmpty) {
      throw Exception('No articles found for the search term: $article');
    }
    return articlesList;
  }
}
