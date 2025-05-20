import 'package:geekcontrol/animes/articles/entities/articles_entity.dart';
import 'package:geekcontrol/animes/sites_enum.dart';
import 'package:scraper/scraper.dart';

class OtakuPT {
  final _scraper = Scraper();

  Future<List<ArticlesEntity>> scrapeArticles() async {
    const String uri = 'https://www.otakupt.com/category/anime';

    final doc = await _scraper.getDocument(url: uri);

    final List<ArticlesEntity> articlesList = [];
    final element = doc.querySelectorAll(
        '.tdb_module_loop.td_module_wrap.td-animation-stack.td-cpt-post');

    for (final e in element) {
      final title = _scraper.elementSelect(
            element: e,
            selector: '.entry-title.td-module-title a',
          ) ??
          '';
      final imageElement = _scraper.elementSelectAttr(
            element: e,
            selector: '.entry-thumb.td-thumb-css',
            attr: 'style',
          ) ??
          '';
      final image = _formatImage(imageElement);
      final author = _scraper.elementSelect(
            element: e,
            selector: '.td-post-author-name a',
          ) ??
          'N/A';
      final date = _scraper.elementSelect(
            element: e,
            selector: '.td-post-date',
          ) ??
          '';
      final url = _scraper.elementSelectAttr(
            element: e,
            selector: '.entry-title.td-module-title a',
            attr: 'href',
          ) ??
          '';

      if (url.isEmpty) continue;

      final articles = ArticlesEntity(
        title: title,
        imageUrl: image,
        date: date,
        author: author,
        category: '',
        content: '',
        url: url,
        sourceUrl: url,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        resume: '',
        site: SitesEnum.otakuPt.name,
      );
      articlesList.add(articles);
    }
    final manga = await _mangasArticles();
    return [...articlesList, ...manga];
  }

  Future<List<ArticlesEntity>> searchArticles(String article) async {
    final List<ArticlesEntity> articlesList = [];
    final doc =
        await _scraper.getDocument(url: 'https://www.otakupt.com/?s=$article');

    final elements = doc.querySelectorAll(
        '.tdb_module_loop.td_module_wrap.td-animation-stack.td-cpt-post');

    for (final e in elements) {
      final title = _scraper.elementSelect(
            element: e,
            selector: '.entry-title.td-module-title a',
          ) ??
          '';
      final url = _scraper.elementSelectAttr(
            element: e,
            selector: '.entry-title.td-module-title a',
            attr: 'href',
          ) ??
          '';
      final author = _scraper.elementSelect(
            element: e,
            selector: '.td-post-author-name a',
          ) ??
          '';
      final date = _scraper.elementSelect(
            element: e,
            selector: '.td-post-date',
          ) ??
          '';
      final imageElement = _scraper.elementSelectAttr(
            element: e,
            selector: '.entry-thumb.td-thumb-css',
            attr: 'style',
          ) ??
          '';
      final image = _formatImage(imageElement);

      final articles = ArticlesEntity(
        title: title,
        imageUrl: image,
        date: date,
        author: author,
        category: '',
        content: '',
        url: url,
        sourceUrl: url,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        resume: '',
        site: SitesEnum.otakuPt.name,
      );
      articlesList.add(articles);
    }
    return articlesList;
  }

  Future<ArticlesEntity> scrapeArticleDetails(
      String url, ArticlesEntity entity) async {
    final doc = await _scraper.getDocument(url: url);

    final List<String> contentElements = _scraper.extractText(
          doc: doc,
          query: ['.tdb-block-inner.td-fix-index'],
          tagToSelector: ['p'],
        ) ??
        [];

    var content = contentElements
        .where((element) => element.trim().isNotEmpty)
        .join('\n');

    _scraper.removeHtmlElement(content: contentElements, elements: [
      '<span style',
      'Δdocument',
      'Tags',
      'Diário Otaku',
      'IberAnime'
    ]);

    content = contentElements.join('\n');

    return ArticlesEntity(
      title: entity.title,
      imageUrl: entity.imageUrl,
      date: entity.date,
      author: entity.author,
      category: entity.category,
      content: content,
      url: url,
      resume: '',
      sourceUrl: entity.sourceUrl ?? url,
      createdAt: entity.createdAt,
      updatedAt: DateTime.now(),
      imagesPage: null,
      site: SitesEnum.animesNew.name,
    );
  }

  Future<List<ArticlesEntity>> _mangasArticles() async {
    const String uri = 'https://www.otakupt.com/category/manga/';
    final doc = await _scraper.getDocument(url: uri);

    final List<ArticlesEntity> articlesList = [];
    final element = doc.querySelectorAll(
        '.tdb_module_loop.td_module_wrap.td-animation-stack.td-cpt-post');

    for (final e in element) {
      final title = _scraper.elementSelect(
            element: e,
            selector: '.entry-title.td-module-title a',
          ) ??
          '';
      final imageElement = _scraper.elementSelectAttr(
            element: e,
            selector: '.entry-thumb.td-thumb-css',
            attr: 'style',
          ) ??
          '';
      final image = _formatImage(imageElement);
      final author = _scraper.elementSelect(
            element: e,
            selector: '.td-post-author-name a',
          ) ??
          '';
      final date = _scraper.elementSelect(
            element: e,
            selector: '.td-post-date',
          ) ??
          '';
      final href = _scraper.elementSelectAttr(
            element: e,
            selector: '.entry-title.td-module-title a',
            attr: 'href',
          ) ??
          '';

      if (href.isEmpty) continue;

      final articles = ArticlesEntity(
        title: title,
        imageUrl: image,
        date: date,
        author: author,
        category: '',
        content: '',
        url: href,
        sourceUrl: href,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        resume: '',
        site: SitesEnum.otakuPt.name,
      );
      articlesList.add(articles);
    }
    return articlesList;
  }

  String _formatImage(String image) {
    return '${image.replaceAll("'", '').replaceAll('background-image: url(', '').replaceAll(');', '').split('.jpg')[0]}.jpg';
  }
}
