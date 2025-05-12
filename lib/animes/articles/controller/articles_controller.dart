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
  final _cache = LocalCache();
  final _logger = Logger();

  final _sitesScraper = {
    SitesEnum.animesNew: MangaNews(),
    SitesEnum.otakuPt: OtakuPT(),
    SitesEnum.intoxi: IntoxiArticles(),
  };

  Future<List<ArticlesEntity>> articles = Future.value([]);
  Future<List<ArticlesEntity>> articlesSearch = Future.value([]);
  int currenctIndex = 0;
  var currentSite = SitesEnum.animesNew;

  Future<void> changedSite(SitesEnum site) async {
    final cacheKey = 'site_cache_${site.key}';
    final result =
        await _fetchArticles(site, cacheKey, Duration(minutes: 30));

    articles = Future.value(result);
    currenctIndex = site.index;
    currentSite = site;
    notifyListeners();
  }

  Future<void> changedSearchSite(SitesEnum site,
      {required String article}) async {
    currenctIndex = site.index;
    final scraper = _sitesScraper[site];

    if (scraper is MangaNews) {
      articlesSearch = scraper.searchArticle(article);
    } else if (scraper is OtakuPT) {
      articlesSearch = scraper.searchArticles(article);
    } else if (scraper is IntoxiArticles) {
      articlesSearch = scraper.searchArticles(article: article);
    }

    notifyListeners();
  }

  bool loadMore(bool load) => load;

  Future<List<ArticlesEntity>> bannerNews() async {
    final cacheKey = CacheKeys.articles.key;
    final result = await _fetchArticles(
        null, cacheKey, Duration(hours: 1),
        isBanner: true);
    return result;
  }

  Future<ArticlesEntity> fetchArticleDetails(
      String url, ArticlesEntity article, String siteName) async {
    try {
      final site = SitesEnum.values.firstWhere((e) => e.name == siteName);
      final scraper = _sitesScraper[site];

      if (scraper is MangaNews) {
        return await scraper.scrapeArticleDetails(url, article);
      }
      if (scraper is OtakuPT) {
        return await scraper.scrapeArticleDetails(url, article);
      }
      if (scraper is IntoxiArticles) {
        return await scraper.scrapeArticleDetails(url, article);
      }

      return article;
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
    if (readArticles.remove(title)) {
      await _cache.put(CacheKeys.reads.key, readArticles);
      notifyListeners();
    }
  }

  Future<List<ArticlesEntity>> _fetchArticles(
    SitesEnum? site,
    String cacheKey,
    Duration maxAge, {
    bool isBanner = false,
  }) async {
    final cacheRaw = await _cache.get(cacheKey);

    if (cacheRaw is List) {
      final timestamps = cacheRaw
          .map((e) => DateTime.tryParse(e['updatedAt'] ?? ''))
          .whereType<DateTime>()
          .toList();

      final shouldUpdate = timestamps.isEmpty ||
          DateTime.now().difference(
                timestamps.reduce((a, b) => a.isAfter(b) ? a : b),
              ) >
              maxAge;

      if (!shouldUpdate) {
        _logger.i('Usando cache para $cacheKey');
        return cacheRaw.map((e) => ArticlesEntity.fromMap(e)).toList();
      }
    }

    _logger.i('Atualizando cache para $cacheKey');

    List<ArticlesEntity> result = [];

    if (isBanner) {
      final otakupt =
          await (_sitesScraper[SitesEnum.otakuPt] as OtakuPT).scrapeArticles();
      final intoxi = await (_sitesScraper[SitesEnum.intoxi] as IntoxiArticles)
          .scrapeArticles(IntoxiUtils.uriStr);
      result = [...otakupt.take(3), ...intoxi.take(3)];
    } else if (site != null) {
      final scraper = _sitesScraper[site];
      if (scraper is MangaNews) {
        result = await scraper.scrapeArticles();
      } else if (scraper is OtakuPT) {
        result = await scraper.scrapeArticles();
      } else if (scraper is IntoxiArticles) {
        result = await scraper.scrapeArticles(IntoxiUtils.uriStr);
      }
    }

    await _cache.putList<ArticlesEntity>(cacheKey, result, (a) => a.toMap());
    return result;
  }
}
