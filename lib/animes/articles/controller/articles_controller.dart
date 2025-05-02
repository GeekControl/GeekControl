import 'package:flutter/material.dart';
import 'package:geekcontrol/animes/articles/entities/articles_entity.dart';
import 'package:geekcontrol/animes/sites_enum.dart';
import 'package:geekcontrol/core/utils/api_utils.dart';
import 'package:geekcontrol/services/cache/keys_enum.dart';
import 'package:geekcontrol/services/cache/local_cache.dart';
import 'package:geekcontrol/services/sites/otakupt/otakupt_scraper.dart';
import 'package:geekcontrol/services/sites/intoxi_animes/webscraper/intoxi_articles_scraper.dart';
import 'package:geekcontrol/services/sites/mangas_news/webscraper/all_articles.dart';
import 'package:logger/logger.dart';

class ArticlesController extends ChangeNotifier {
  final IntoxiArticles _intoxi = IntoxiArticles();
  final OtakuPT _otakuPt = OtakuPT();
  final MangaNews _animewsNews = MangaNews();
  final _cache = LocalCache();
  final _logger = Logger();

  Future<List<ArticlesEntity>> articles = Future.value([]);
  Future<List<ArticlesEntity>> articlesSearch = Future.value([]);
  int currenctIndex = 0;
  var currentSite = SitesEnum.animesNew;

  Future<void> changedSite(SitesEnum site) async {
    final key = site.key;
    final cacheKey = 'site_cache_$key';
    final cacheRaw = await _cache.get(cacheKey);

    List<ArticlesEntity> result;

    if (cacheRaw is List) {
      final timestamps = cacheRaw
          .map((e) => DateTime.tryParse(e['updatedAt'] ?? ''))
          .whereType<DateTime>()
          .toList();

      final shouldUpdate = timestamps.isEmpty ||
          DateTime.now().difference(
                timestamps.reduce((a, b) => a.isAfter(b) ? a : b),
              ) >
              const Duration(minutes: 30);

      if (!shouldUpdate) {
        _logger.i('Usando cache para $key');
        result = cacheRaw.map((e) => ArticlesEntity.fromMap(e)).toList();
      } else {
        result = await _fetchAndCacheSiteArticles(site, cacheKey);
      }
    } else {
      result = await _fetchAndCacheSiteArticles(site, cacheKey);
    }

    articles = Future.value(result);
    currenctIndex = site.index;
    currentSite = site;
    notifyListeners();
  }

  Future<void> changedSearchSite(SitesEnum site,
      {required String article}) async {
    currenctIndex = site.index;

    if (site == SitesEnum.animesNew) {
      articlesSearch = _animewsNews.searchArticle(article);
    } else if (site == SitesEnum.otakuPt) {
      articlesSearch = _otakuPt.searchArticles(article);
    } else if (site == SitesEnum.intoxi) {
      articlesSearch = _intoxi.searchArticles(article: article);
    }

    notifyListeners();
  }

  bool loadMore(bool load) {
    return load;
  }

  Future<List<ArticlesEntity>> bannerNews() async {
    final cacheKey = CacheKeys.articles.key;
    final newsCacheRaw = await _cache.get(cacheKey);

    if (newsCacheRaw is List) {
      final timestamps = newsCacheRaw
          .map((e) => DateTime.tryParse(e['updatedAt'] ?? ''))
          .whereType<DateTime>()
          .toList();

      final shouldUpdate = timestamps.isEmpty ||
          DateTime.now().difference(
                timestamps.reduce((a, b) => a.isAfter(b) ? a : b),
              ) >
              const Duration(hours: 1);

      if (!shouldUpdate) {
        _logger.i('Usando cache do bannerNews');
        return newsCacheRaw
            .map((json) => ArticlesEntity.fromMap(json))
            .toList();
      }
    }

    _logger.i('Buscando bannerNews da web');
    final otakupt = await _otakuPt.scrapeArticles();
    final intoxi = await _intoxi.scrapeArticles(IntoxiUtils.uriStr);
    final news = [...otakupt.take(3), ...intoxi.take(3)];

    await _cache.putList<ArticlesEntity>(
      cacheKey,
      news,
      (a) => a.toMap(),
    );
    return news;
  }

  Future<ArticlesEntity> fetchArticleDetails(
      String url, ArticlesEntity articles, String current) async {
    try {
      if (current == SitesEnum.animesNew.name) {
        return await _animewsNews.scrapeArticleDetails(url, articles);
      }
      if (current == SitesEnum.otakuPt.name) {
        return await _otakuPt.scrapeArticleDetails(url, articles);
      }
      if (current == SitesEnum.intoxi.name) {
        return await _intoxi.scrapeArticleDetails(url, articles);
      }
      notifyListeners();
      return articles;
    } catch (e) {
      throw Exception('Erro ao buscar detalhes do artigo: $e');
    }
  }

  Future<void> loadReadArticles() async {
    await _cache.get(CacheKeys.reads.key);
    notifyListeners();
  }

  Future<void> markAsRead(String title, List<String> readArticles) async {
    if (!readArticles.contains(title)) {
      readArticles.add(title);
      await _cache.put(CacheKeys.reads.key, readArticles);
      notifyListeners();
    }
  }

  Future<bool> isRead(String title, List<String> readArticles) async {
    final reads = await _cache.get(CacheKeys.reads.key);
    return reads is List && reads.contains(title);
  }

  Future<void> markAsUnread(String title, List<String> readArticles) async {
    if (readArticles.contains(title)) {
      readArticles.remove(title);
      await _cache.put(CacheKeys.reads.key, readArticles);
      notifyListeners();
    }
  }

  Future<List<ArticlesEntity>> _fetchAndCacheSiteArticles(
      SitesEnum site, String cacheKey) async {
    List<ArticlesEntity> result = [];

    if (site == SitesEnum.animesNew) {
      result = await _animewsNews.scrapeArticles();
    } else if (site == SitesEnum.otakuPt) {
      result = await _otakuPt.scrapeArticles();
    } else if (site == SitesEnum.intoxi) {
      result = await _intoxi.scrapeArticles(IntoxiUtils.uriStr);
    }

    _logger.i('Cache atualizado para $cacheKey');
    await _cache.putList<ArticlesEntity>(
      cacheKey,
      result,
      (a) => a.toMap(),
    );
    return result;
  }
}
