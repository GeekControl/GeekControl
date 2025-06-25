import '../../animes/articles/entities/articles_entity.dart';
import '../../../core/utils/logger.dart';
import '../database/database.dart';

class ArticlesCacheDB {
  Future<List<ArticlesEntity>> getArticlesCache(
      {required quantity, required Database db}) async {
    Loggers.fluxControl(this, null);

    try {
      final List<Map<String, dynamic>> articlesCache = await db.get(quantity);
      List<ArticlesEntity> articles = articlesCache
          .map((articleMap) => ArticlesEntity.fromMap(articleMap))
          .toList();

      return articles;
    } catch (e) {
      throw Exception('Error getting news from cache: $e');
    }
  }

  Future<List<ArticlesEntity>> getAllArticles({required Database db}) async {
    Loggers.fluxControl(this, null);
    try {
      final List<Map<String, dynamic>> articlesCache = await db.getAll();
      List<ArticlesEntity> articles = articlesCache
          .map((articleMap) => ArticlesEntity.fromMap(articleMap))
          .toList();
      return articles;
    } catch (e) {
      throw Exception('Error getting news from cache: $e');
    }
  }
}
