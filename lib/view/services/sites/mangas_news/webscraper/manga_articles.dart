import 'package:geekcontrol/view/animes/articles/entities/articles_entity.dart';
import 'package:geekcontrol/view/animes/sites_enum.dart';
import 'package:geekcontrol/core/utils/anime_sources.dart';
import 'package:html/dom.dart';
import 'package:scraper/scraper.dart';

class AnimesnewMangasArticles {
  final _scraper = Scraper();
  Future<List<ArticlesEntity>> getMangasScrap() async {
    final List<ArticlesEntity> scrapeList = [];

    final url = AnimeSources.animesNewUriStr;
    final Document doc = await _scraper.getDocument(url: url);
    final element = doc.querySelectorAll('.p-wrap.p-grid.p-grid-2');

    for (final e in element) {
      final title = _scraper.elementSelect(
            element: e,
            selector: '.entry-title a',
          ) ??
          '';
      final resume = _scraper.elementSelect(
            element: e,
            selector: '.entry-summary',
          ) ??
          '';
      final img = _scraper.elementSelectAttr(
            element: e,
            selector: '.feat-holder img',
            attr: 'src',
          ) ??
          '';
      final author = _scraper.elementSelect(
            element: e,
            selector: '.meta-inner.is-meta a',
          ) ??
          'N/A';
      final date = _scraper.elementSelect(
            element: e,
            selector: '.meta-inner.is-meta time',
          ) ??
          '';

      if (title.isNotEmpty &&
          resume.isNotEmpty &&
          img.isNotEmpty &&
          author.isNotEmpty &&
          date.isNotEmpty) {
        if (!scrapeList.any((article) => article.title == title)) {
          final article = ArticlesEntity(
            title: title,
            imageUrl: img,
            date: date,
            author: author,
            resume: resume,
            site: SitesEnum.animesNew.name,
            category: '',
            content: '',
            url: '',
            sourceUrl: '',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );

          scrapeList.add(article);
        }
      }
    }
    return scrapeList;
  }

  Future getMangasDetails(ArticlesEntity entity, String url) async {
    final doc = await _scraper.getDocument(url: url);
    final images = _scraper.querySelectAttr(
          doc: doc,
          query: '.s-ct img',
          attr: 'src',
        ) ??
        '';
    final imagesElements = doc.querySelectorAll('.s-ct img');
    final List<String> listImages = [];

    for (var e in imagesElements) {
      if (e.attributes['data-lazy-src'] != null) {
        listImages.add(e.attributes['data-lazy-src']!);
      }
      if (images != 'NA') {
        listImages.add(images);
      }
    }

    final contentList = _scraper
        .extractText(doc: doc, query: ['.s-ct'], tagToSelector: ['p', 'li']);

    return ArticlesEntity(
      title: entity.title,
      imageUrl: entity.imageUrl,
      date: entity.date,
      site: SitesEnum.animesNew.name,
      author: entity.author,
      category: entity.category,
      content: contentList.toString(),
      url: url,
      sourceUrl: entity.sourceUrl,
      createdAt: entity.createdAt,
      updatedAt: DateTime.now(),
      resume: entity.resume,
      imagesPage: listImages,
    );
  }
}
