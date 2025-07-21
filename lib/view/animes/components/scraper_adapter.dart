import 'package:geekcontrol/view/animes/articles/entities/articles_entity.dart';
import 'package:geekcontrol/view/animes/articles/articles_impl.dart';
import 'package:geekcontrol/view/animes/sites_enum.dart';

class ScraperAdapter {
  final SitesEnum siteType;

  ScraperAdapter(this.siteType);

  Future<List<ArticlesEntity>> scrapeArticles([String? uri]) {
    return ArticlesImpl.fromType(siteType).get(uri ?? '');
  }

  Future<List<ArticlesEntity>> searchArticles(String q) {
    return ArticlesImpl.fromType(siteType).search(q);
  }

  Future<ArticlesEntity> scrapeArticleDetails(String url, ArticlesEntity a) {
    return ArticlesImpl.fromType(siteType).getDetails(url, a);
  }
}
