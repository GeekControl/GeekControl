import 'package:geekcontrol/view/animes/spoilers/entities/spoiler_entity.dart';
import 'package:geekcontrol/core/utils/anime_sources.dart';
import 'package:scraper/scraper.dart';

class SpoilersScrap {
  final _scraper = Scraper();

  Future<List<SpoilersEntity>> getSpoilers() async {
    return await scrapeInitial();
  }

  Future<List<SpoilersEntity>> getDetails(
      {required SpoilersEntity entity}) async {
    return await scrapeDetails(entity);
  }

  Future<List<SpoilersEntity>> scrapeDetails(SpoilersEntity entity) async {
    final doc = await _scraper.getDocument(url: entity.url);

    final content = _scraper.querySelectorAll(
      doc: doc,
      query: '.entry-inner p',
    );
    final images = _scraper.querySelectAllAttr(
      doc: doc,
      query: '.entry-inner img',
      attr: 'src',
    );

    if (content == null) return [SpoilersEntity.empty()];
    final List<SpoilersEntity> updatedSpoilers = content.map((content) {
      return SpoilersEntity(
        title: entity.title,
        imageUrl: entity.imageUrl,
        date: entity.date,
        resume: entity.resume,
        category: entity.category,
        content: content,
        url: entity.url,
        sourceUrl: entity.sourceUrl,
        createdAt: entity.createdAt,
        updatedAt: entity.updatedAt,
        images: images ?? [],
      );
    }).toList();
    return updatedSpoilers;
  }

  Future<List<SpoilersEntity>> scrapeInitial() async {
    final List<SpoilersEntity> spoilersList = [];

    final doc = await _scraper.getDocument(url: AnimeSources.intoxiUriStr);
    final elements = doc.querySelectorAll('.post-inner');

    for (final e in elements) {
      final title = _scraper.elementSelect(
        element: e,
        selector: '.post-title.entry-title a',
      );
      final published = _scraper.elementSelect(
        element: e,
        selector: '.published.updated',
      );
      final resume = _scraper.elementSelect(
        element: e,
        selector: '.entry.excerpt.entry-summary p',
      );
      final url = _scraper.elementSelectAttr(
        element: e,
        selector: '.post-title.entry-title a',
        attr: 'href',
      );
      final category = _scraper.elementSelect(
        element: e,
        selector: '.post-category',
      );
      final image = _scraper.elementSelectAttr(
        element: e,
        selector: '.post-thumbnail img',
        attr: 'src',
      );

      final spoiler = SpoilersEntity(
        title: _validate(title),
        imageUrl: image,
        date: _validate(published?.toUpperCase()),
        resume: _validate(resume?.trim()),
        category: _validate(category?.toUpperCase()),
        content: '',
        url: _validate(url),
        sourceUrl: url,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        images: [],
      );
      spoilersList.add(spoiler);
    }
    return spoilersList;
  }

  String _validate(String? input) {
    return (input == null || input.isEmpty) ? '' : input;
  }
}
