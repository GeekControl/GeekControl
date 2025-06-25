import 'package:geekcontrol/view/services/anilist/entities/anilist_seasons_enum.dart';
import 'package:geekcontrol/view/services/anilist/entities/anilist_types_enum.dart';

class SeasonsRouteEntity {
  final String title;
  final AnilistTypes type;
  final AnilistSeasons? season;
  final String? year;

  SeasonsRouteEntity({
    required this.title,
    required this.type,
    required this.season,
    required this.year,
  });

  factory SeasonsRouteEntity.fromMap(Map map) {
    return SeasonsRouteEntity(
      title: map['title'],
      type: map['type'],
      season: map['season'],
      year: map['year'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'type': type,
      'season': season,
      'year': year,
    };
  }
}
