import '../../../../animes/articles/entities/articles_entity.dart';
import '../webscraper/all_articles.dart';
import '../webscraper/manga_articles.dart';

class MangaNewsController {
  Future<List<ArticlesEntity>> getMangasNews() async {
    return await AnimesnewMangasArticles().getMangasScrap();
  }

  Future<ArticlesEntity> getNewsDetails(
      ArticlesEntity entity, String url) async {
    return await MangaNews().scrapeArticleDetails(url, entity);
  }

  Future<List<ArticlesEntity>> getAllNews() async {
    return await MangaNews().scrapeArticles();
  }
}
