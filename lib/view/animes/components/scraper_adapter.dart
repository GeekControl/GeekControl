import 'package:geekcontrol/view/animes/articles/entities/articles_entity.dart';
import 'package:geekcontrol/view/services/sites/intoxi_animes/webscraper/intoxi_articles_scraper.dart';
import 'package:geekcontrol/view/services/sites/mangas_news/webscraper/all_articles.dart';
import 'package:geekcontrol/view/services/sites/otakupt/otakupt_scraper.dart';

class ScraperAdapter {
  final MangaNews? _manga;
  final OtakuPT? _otaku;
  final IntoxiArticles? _intoxi;

  ScraperAdapter.fromMangaNews(this._manga)
      : _otaku = null,
        _intoxi = null;
  ScraperAdapter.fromOtakuPt(this._otaku)
      : _manga = null,
        _intoxi = null;
  ScraperAdapter.fromIntoxi(this._intoxi)
      : _manga = null,
        _otaku = null;

  Future<List<ArticlesEntity>> scrapeArticles([String? uri]) {
    if (_manga != null) return _manga!.scrapeArticles();
    if (_otaku != null) return _otaku!.scrapeArticles();
    if (_intoxi != null) return _intoxi!.scrapeArticles(uri!);
    return Future.value([]);
  }

  Future<List<ArticlesEntity>> searchArticles(String q) {
    if (_manga != null) return _manga!.searchArticle(q);
    if (_otaku != null) return _otaku!.searchArticles(q);
    if (_intoxi != null) return _intoxi!.searchArticles(article: q);
    return Future.value([]);
  }

  Future<ArticlesEntity> scrapeArticleDetails(String url, ArticlesEntity a) =>
      _manga?.scrapeArticleDetails(url, a) ??
      _otaku?.scrapeArticleDetails(url, a) ??
      _intoxi!.scrapeArticleDetails(url, a);
}