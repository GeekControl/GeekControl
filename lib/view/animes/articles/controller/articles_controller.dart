import 'package:flutter/widgets.dart';
import 'package:geekcontrol/core/library/page_builder/hitagi_page.dart';
import 'package:geekcontrol/core/routes/entities/article_details_route_entity.dart';
import 'package:geekcontrol/view/animes/articles/entities/articles_entity.dart';
import 'package:geekcontrol/view/animes/articles/pages/article_details_page.dart';
import 'package:geekcontrol/view/animes/components/scraper_adapter.dart';
import 'package:geekcontrol/view/animes/sites_enum.dart';
import 'package:geekcontrol/core/utils/anime_sources.dart';
import 'package:geekcontrol/view/services/cache/keys_enum.dart';
import 'package:go_router/go_router.dart';

class ArticlesController extends HitagiController {
  final cacheDuration = Duration(minutes: 30);
  final _memoryCache = <SitesEnum, List<ArticlesEntity>>{};
  SitesEnum currentSite = SitesEnum.animesNew;
  int currentIndex = SitesEnum.animesNew.index;
  Future<List<ArticlesEntity>> articles = Future.value([]);
  List<ArticlesEntity> _articlesSearch = [];
  String _lastSearchTerm = '';
  List<String> _memoryRead = [];
  List<ArticlesEntity> get articlesSearch => _articlesSearch;
  List<ArticlesEntity> get articlesList => _memoryCache[currentSite] ?? [];
  List<String> get readArticles => _memoryRead;

  @override
  Future<void> init({dynamic param}) async {
    await _loadReadArticles();
    await _loadSite(currentSite);
  }

  void openArticle(BuildContext context, ArticlesEntity article) {
    GoRouter.of(context).push(
      ArticleDetailsPage.route,
      extra: ArticleDetailsRouteEntity(news: article, current: currentSite.name),
    );
  }

  Future<void> changeSite(SitesEnum site) async {
    currentSite = site;
    currentIndex = site.index;
    if (_lastSearchTerm.isNotEmpty) {
      setState(ControllerState.loading);
      _articlesSearch = await ScraperAdapter(site).searchArticles(_lastSearchTerm);
      setState(ControllerState.success);
    } else {
      await _loadSite(site, isChangeSite: true);
    }
    notifyListeners();
  }

  Future<void> changeSearchSite(SitesEnum site, {required String article}) async {
    currentSite = site;
    currentIndex = site.index;
    _lastSearchTerm = article;
    _articlesSearch = await ScraperAdapter(site).searchArticles(article);
    notifyListeners();
  }

  Future<void> _loadSite(SitesEnum site, {bool isChangeSite = false}) async {
    notifyListeners();
    currentSite = site;
    currentIndex = site.index;
    final cached = isChangeSite ? null : await _getCachedArticles();
    final list = cached ?? await ScraperAdapter(site).scrapeArticles(_uriFor(site));
    _memoryCache[site] = list;
    articles = Future.value(list);
    if (cached == null) {
      await cache.putList<ArticlesEntity>(
        key: CacheKeys.articles,
        items: list,
        toMap: (a) => a.toMap(),
        site: site.name,
      );
    }
    notifyListeners();
  }

  Future<List<ArticlesEntity>> bannerNews() async {
    final sites = [SitesEnum.animesNew, SitesEnum.otakuPt, SitesEnum.intoxi];
    var cached = await cache.get(CacheKeys.articles, site: currentSite.name);
    final updateCache = await cache.shouldUpdateCache(
      CacheKeys.articles, title: currentSite.name, cacheDuration,
    );
    if (cached == null || updateCache) {
      for (final site in sites) {
        try {
          final articles = await ScraperAdapter(site).scrapeArticles();
          if (articles.isNotEmpty) {
            await cache.putList<ArticlesEntity>(
              key: CacheKeys.articles,
              items: articles,
              toMap: (a) => a.toMap(),
              site: site.name,
            );
            currentSite = site;
            notifyListeners();
            return articles.take(3).toList();
          }
        } catch (_) {}
      }
      for (final site in sites) {
        try {
          final articles = await ScraperAdapter(site).scrapeArticles();
          if (articles.isNotEmpty) return articles.take(3).toList();
        } catch (_) {}
      }
      return [];
    }
    notifyListeners();
    return cached
        ?.map((e) => ArticlesEntity.fromMap(e))
        .whereType<ArticlesEntity>()
        .toList()
        .take(3)
        .toList() ?? [];
  }

  Future<ArticlesEntity> fetchArticleDetails(String url, ArticlesEntity article, String siteName) {
    final adapt = ScraperAdapter(SitesEnum.values.firstWhere((e) => e.name == siteName))
        .scrapeArticleDetails(url, article);
    notifyListeners();
    return adapt;
  }

  bool isReadSync(String title) => _memoryRead.contains(title);
  Future<bool> isRead(String title) async => _memoryRead.contains(title);

  Future<void> markAsRead(String title) async {
    if (_memoryRead.contains(title)) return;
    _memoryRead.add(title);
    await cache.put(CacheKeys.reads, _memoryRead);
    notifyListeners();
  }

  Future<void> markAsUnread(String title) async {
    if (_memoryRead.remove(title)) {
      await cache.put(CacheKeys.reads, _memoryRead);
      notifyListeners();
    }
  }

  Future<void> _loadReadArticles() async {
    final raw = await cache.get(CacheKeys.reads);
    if (raw is List<String>) _memoryRead = raw;
    notifyListeners();
  }

  Future<List<ArticlesEntity>?> _getCachedArticles() async {
    final raw = await cache.get(CacheKeys.articles, site: currentSite.name);
    if (raw is List) {
      final list = raw.map((e) => ArticlesEntity.fromMap(e)).toList();
      final dates = list.map((e) => e.updatedAt).whereType<DateTime>().toList();
      if (dates.isNotEmpty &&
          DateTime.now().difference(dates.reduce((a, b) => a.isAfter(b) ? a : b)) <= cacheDuration) {
        return list;
      }
    }
    return null;
  }

  String? _uriFor(SitesEnum site) =>
      site == SitesEnum.intoxi ? AnimeSources.intoxiUriStr : null;
}