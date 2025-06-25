import 'package:flutter/material.dart';
import 'package:geekcontrol/view/animes/articles/entities/articles_entity.dart';
import 'package:geekcontrol/view/animes/components/scraper_adapter.dart';
import 'package:geekcontrol/view/animes/sites_enum.dart';
import 'package:geekcontrol/core/utils/anime_sources.dart';
import 'package:geekcontrol/core/utils/global_variables.dart';
import 'package:geekcontrol/view/services/cache/keys_enum.dart';
import 'package:geekcontrol/view/services/cache/local_cache.dart';
import 'package:geekcontrol/view/services/sites/otakupt/otakupt_scraper.dart';
import 'package:geekcontrol/view/services/sites/intoxi_animes/webscraper/intoxi_articles_scraper.dart';
import 'package:geekcontrol/view/services/sites/mangas_news/webscraper/mangas_news_articles.dart';

class ArticlesController extends ChangeNotifier {
  final LocalCache _cache = di<LocalCache>();
  final Map<SitesEnum, ScraperAdapter> _adapters;
  final Duration _cacheDuration = Duration(minutes: 30);
  final Map<SitesEnum, List<ArticlesEntity>> _memoryCache = {};

  SitesEnum currentSite = SitesEnum.animesNew;
  int currentIndex = SitesEnum.animesNew.index;
  Future<List<ArticlesEntity>> articles = Future.value([]);
  Future<List<ArticlesEntity>> articlesSearch = Future.value([]);
  List<ArticlesEntity> get articlesList => _memoryCache[currentSite] ?? [];

  bool _isLoading = true;
  bool changedSite = false;
  bool get isLoading => _isLoading;
  String _lastSearchTerm = '';

  ArticlesController()
      : _adapters = {
          SitesEnum.animesNew: ScraperAdapter.fromMangaNews(MangaNews()),
          SitesEnum.otakuPt: ScraperAdapter.fromOtakuPt(OtakuPT()),
          SitesEnum.intoxi: ScraperAdapter.fromIntoxi(IntoxiArticles()),
        };

  Future<void> init() async {
    await _loadReadArticles();
    await _loadSite(currentSite);
  }

  List<String> get readArticles => _memoryRead;
  bool isReadSync(String title) => _memoryRead.contains(title);

  Future<void> changeSite(SitesEnum site) async {
    currentSite = site;
    currentIndex = site.index;

    if (_lastSearchTerm.isNotEmpty) {
      changedSite = true;
      articlesSearch = _adapters[site]!.searchArticles(_lastSearchTerm);
    } else {
      await _loadSite(site, isChangeSite: true);
    }

    notifyListeners();
  }

  Future<void> _loadSite(SitesEnum site, {bool isChangeSite = false}) async {
    notifyListeners();
    currentSite = site;
    currentIndex = site.index;

    final cached = isChangeSite ? null : await _getCachedArticles();

    final articleList =
        cached ?? await _adapters[site]!.scrapeArticles(_uriFor(site));

    _memoryCache[site] = articleList;
    articles = Future.value(articleList);

    if (cached == null) {
      await _cache.putList<ArticlesEntity>(
        key: CacheKeys.articles,
        items: articleList,
        toMap: (a) => a.toMap(),
        site: site.name,
      );
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> changeSearchSite(
    SitesEnum site, {
    required String article,
  }) async {
    currentSite = site;
    currentIndex = site.index;
    _lastSearchTerm = article;
    articlesSearch = _adapters[site]!.searchArticles(article);
    notifyListeners();
  }

  Future<List<ArticlesEntity>> bannerNews() async {
    final cached = await _cache.get(CacheKeys.articles, site: currentSite.name);

    final updateCache = await _cache.shouldUpdateCache(
      CacheKeys.articles,
      title: currentSite.name,
      _cacheDuration,
    );

    if (cached == null || updateCache) {
      final sites = _adapters.keys.toList();

      for (final site in sites) {
        try {
          final articles = await _adapters[site]!.scrapeArticles();

          await _cache.putList<ArticlesEntity>(
            key: CacheKeys.articles,
            items: articles,
            toMap: (a) => a.toMap(),
            site: site.name,
          );
          currentSite = site;
          notifyListeners();
          return articles.take(3).toList();
        } catch (_) {
          continue;
        }
      }
    }

    notifyListeners();
    return cached
        .map((e) => ArticlesEntity.fromMap(e))
        .whereType<ArticlesEntity>()
        .toList()
        .take(3)
        .toList();
  }

  Future<ArticlesEntity> fetchArticleDetails(
    String url,
    ArticlesEntity article,
    String siteName,
  ) {
    final adapt =
        _adapters[SitesEnum.values.firstWhere((e) => e.name == siteName)]!
            .scrapeArticleDetails(url, article);
    notifyListeners();
    return adapt;
  }

  Future<void> _loadReadArticles() async {
    final raw = await _cache.get(CacheKeys.reads);
    if (raw is List<String>) _memoryRead = raw;
    notifyListeners();
  }

  List<String> _memoryRead = [];
  Future<void> markAsRead(String title) async {
    if (!_memoryRead.contains(title)) {
      _memoryRead.add(title);
      await _cache.put(CacheKeys.reads, _memoryRead);
      notifyListeners();
    }
  }

  Future<bool> isRead(String title) async => _memoryRead.contains(title);

  Future<void> markAsUnread(String title) async {
    if (_memoryRead.remove(title)) {
      await _cache.put(CacheKeys.reads, _memoryRead);
      notifyListeners();
    }
  }

  Future<List<ArticlesEntity>?> _getCachedArticles() async {
    final raw = await _cache.get(CacheKeys.articles, site: currentSite.name);
    if (raw is List) {
      final list = raw.map((e) => ArticlesEntity.fromMap(e)).toList();
      final dates = list.map((e) => e.updatedAt).whereType<DateTime>().toList();
      if (dates.isNotEmpty &&
          DateTime.now().difference(
                dates.reduce((a, b) => a.isAfter(b) ? a : b),
              ) <=
              _cacheDuration) {
        return list;
      }
    }
    return null;
  }

  String? _uriFor(SitesEnum site) =>
      site == SitesEnum.intoxi ? AnimeSources.intoxiUriStr : null;
}
