import 'package:geekcontrol/view/animes/articles/entities/articles_entity.dart';

class ArticleDetailsRouteEntity {
  final ArticlesEntity news;
  final String current;

  ArticleDetailsRouteEntity({
    required this.news,
    required this.current,
  });

  factory ArticleDetailsRouteEntity.fromMap(Map map) {
    return ArticleDetailsRouteEntity(
      news: map['news'],
      current: map['current'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'news': news,
      'current': current,
    };
  }
}
