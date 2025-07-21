import 'package:geekcontrol/view/animes/articles/entities/articles_entity.dart';
import 'package:geekcontrol/view/animes/sites_enum.dart';
import 'package:geekcontrol/view/services/sites/intoxi_animes/webscraper/intoxi_articles_scraper.dart';
import 'package:geekcontrol/view/services/sites/mangas_news/webscraper/mangas_news_articles.dart';
import 'package:geekcontrol/view/services/sites/otakupt/otakupt_scraper.dart';

abstract interface class ArticlesImpl {
  Future<List<ArticlesEntity>> get(String url);
  Future<ArticlesEntity> getDetails(String url, ArticlesEntity entity);
  Future<List<ArticlesEntity>> search(String q);

  factory ArticlesImpl.fromType(SitesEnum type) {
    switch (type) {
      case SitesEnum.animesNew:
        return MangaNews();
      case SitesEnum.otakuPt:
        return OtakuPT();
      case SitesEnum.intoxi:
        return IntoxiArticles();
      case SitesEnum.animeUnited:
        throw UnimplementedError();
      case SitesEnum.voceSabiaAnime:
        throw UnimplementedError();
      case SitesEnum.defaultSite:
        throw UnimplementedError();
    }
  }
}
