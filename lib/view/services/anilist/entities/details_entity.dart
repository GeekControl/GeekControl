import 'package:geekcontrol/view/services/anilist/entities/recommendations_entity.dart';
import 'package:geekcontrol/view/services/anilist/entities/reviews_entity.dart';

class DetailsEntity {
  final int id;
  final String titleRomaji;
  final String titleEnglish;
  final String titleNative;
  final String description;
  final String coverImage;
  final String bannerImage;
  final DateTime? startDate;
  final DateTime? endDate;
  final String format;
  final String status;
  final int? episodes;
  final int? chapters;
  final int? volumes;
  final int? duration;
  final int meanScore;
  final int averageScore;
  final int popularity;
  final List<String> genres;
  final String source;
  final List<String> studios;
  final List<CharacterEntity> characters;
  final List<RecommendationsEntity> recommendations;
  final List<ReviewsEntity> reviews;

  const DetailsEntity({
    required this.id,
    required this.titleRomaji,
    required this.titleEnglish,
    required this.titleNative,
    required this.description,
    required this.coverImage,
    required this.bannerImage,
    required this.startDate,
    required this.endDate,
    required this.format,
    required this.status,
    required this.episodes,
    required this.chapters,
    required this.volumes,
    required this.duration,
    required this.meanScore,
    required this.averageScore,
    required this.popularity,
    required this.genres,
    required this.source,
    required this.studios,
    required this.characters,
    required this.recommendations,
    required this.reviews,
  });

  factory DetailsEntity.fromJson(Map<String, dynamic> json) {
    final media = json['data']['Media'];

    return DetailsEntity(
      id: media['id'],
      titleRomaji: media['title']['romaji'] ?? '',
      titleEnglish: media['title']['english'] ?? '',
      titleNative: media['title']['native'] ?? '',
      description: media['description'] ?? '',
      coverImage: media['coverImage']['large'] ?? '',
      bannerImage: media['bannerImage'] ?? '',
      startDate: _parseDate(media['startDate']),
      endDate: _parseDate(media['endDate']),
      format: media['format'] ?? '',
      status: media['status'] ?? '',
      episodes: media['episodes'],
      chapters: media['chapters'],
      volumes: media['volumes'],
      duration: media['duration'],
      meanScore: media['meanScore'] ?? 0,
      averageScore: media['averageScore'] ?? 0,
      popularity: media['popularity'] ?? 0,
      genres: List<String>.from(media['genres'] ?? []),
      source: media['source'] ?? '',
      reviews: (media['reviews']['nodes'] as List<dynamic>?)
              ?.map((e) => ReviewsEntity.fromMap(e))
              .toList() ??
          [],
      recommendations: (media['recommendations']['nodes'] as List<dynamic>?)
              ?.map((e) => RecommendationsEntity.fromMap(e))
              .toList() ??
          [],
      studios: List<String>.from(
        (media['studios']['nodes'] as List<dynamic>?)?.map((e) => e['name']) ??
            [],
      ),
      characters: (media['characters']['nodes'] as List<dynamic>?)
              ?.map((e) => CharacterEntity.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titleRomaji': titleRomaji,
      'titleEnglish': titleEnglish,
      'titleNative': titleNative,
      'description': description,
      'coverImage': coverImage,
      'bannerImage': bannerImage,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'format': format,
      'status': status,
      'episodes': episodes,
      'chapters': chapters,
      'volumes': volumes,
      'duration': duration,
      'meanScore': meanScore,
      'averageScore': averageScore,
      'popularity': popularity,
      'genres': genres,
      'source': source,
      'studios': studios,
      'characters': characters.map((c) => c.toJson()).toList(),
      'recommendations': recommendations.map((r) => r.toMap()).toList(),
      'reviews': reviews.map((r) => r.toMap()).toList(),
    };
  }

  static const empty = DetailsEntity(
      id: 0,
      titleRomaji: '',
      titleEnglish: '',
      titleNative: '',
      description: '',
      coverImage: '',
      bannerImage: '',
      startDate: null,
      endDate: null,
      format: '',
      status: '',
      episodes: null,
      chapters: null,
      volumes: null,
      duration: null,
      meanScore: 0,
      averageScore: 0,
      popularity: 0,
      genres: [],
      source: '',
      studios: [],
      characters: [],
      reviews: [],
      recommendations: []);

  static DateTime? _parseDate(Map<String, dynamic>? date) {
    if (date == null ||
        date['year'] == null ||
        date['month'] == null ||
        date['day'] == null) {
      return null;
    }
    return DateTime(date['year'], date['month'], date['day']);
  }
}

class CharacterEntity {
  final String name;
  final String image;

  const CharacterEntity({
    required this.name,
    required this.image,
  });

  factory CharacterEntity.fromJson(Map<String, dynamic> json) {
    return CharacterEntity(
      name: json['name']['full'] ?? '',
      image: json['image']['large'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'image': image,
    };
  }

  static const empty = CharacterEntity(
    name: '',
    image: '',
  );
}

extension DetailsEntityCopy on DetailsEntity {
  DetailsEntity copyWith({
    List<ReviewsEntity>? reviews,
    String? description,
  }) {
    return DetailsEntity(
      id: id,
      titleRomaji: titleRomaji,
      titleEnglish: titleEnglish,
      titleNative: titleNative,
      description: description ?? this.description,
      coverImage: coverImage,
      bannerImage: bannerImage,
      startDate: startDate,
      endDate: endDate,
      format: format,
      status: status,
      episodes: episodes,
      chapters: chapters,
      volumes: volumes,
      duration: duration,
      meanScore: meanScore,
      averageScore: averageScore,
      popularity: popularity,
      genres: genres,
      source: source,
      studios: studios,
      characters: characters,
      recommendations: recommendations,
      reviews: reviews ?? this.reviews,
    );
  }
}
