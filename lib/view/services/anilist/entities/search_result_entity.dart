class SearchResultEntity {
  final int id;
  final String title;
  final String alternativeTitle;
  final String coverImage;
  final int episodes;
  final int meanScore;
  final int popularity;
  final String format;
  final String status;
  final String season;
  final int seasonYear;
  final String description;
  final DateTime createdAt;
  final DateTime updatedAt;

  SearchResultEntity({
    required this.id,
    required this.title,
    required this.alternativeTitle,
    required this.coverImage,
    required this.episodes,
    required this.meanScore,
    required this.popularity,
    required this.format,
    required this.status,
    required this.season,
    required this.seasonYear,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  static List<SearchResultEntity> toEntityList(Map<String, dynamic> json) {
    final List<dynamic> mediaList = json['data']['Page']['media'];
    return mediaList.map((media) {
      return SearchResultEntity(
        id: media['id'],
        title: media['title']['english'] ?? '',
        alternativeTitle: media['title']['romaji'] ?? '',
        coverImage: media['coverImage']['extraLarge'] ?? '',
        episodes: media['episodes'] ?? 0,
        meanScore: media['meanScore'] ?? 0,
        popularity: media['popularity'] ?? 0,
        format: media['format'] ?? '',
        status: media['status'] ?? '',
        season: media['season'] ?? '',
        seasonYear: media['seasonYear'] ?? 0,
        description: media['description'] ?? '',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    }).toList();
  }

  static SearchResultEntity fromMap(Map<String, dynamic> map) {
    DateTime parseDate(dynamic value) {
      if (value is String) return DateTime.tryParse(value) ?? DateTime.now();
      if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
      return DateTime.now();
    }

    return SearchResultEntity(
      id: map['id'] ?? 0,
      title: map['title'] ?? '',
      alternativeTitle: map['alternativeTitle'] ?? '',
      coverImage: map['coverImage'] ?? '',
      episodes: map['episodes'] ?? 0,
      meanScore: map['meanScore'] ?? 0,
      popularity: map['popularity'] ?? 0,
      format: map['format'] ?? '',
      status: map['status'] ?? '',
      season: map['season'] ?? '',
      seasonYear: map['seasonYear'] ?? 0,
      description: map['description'] ?? '',
      createdAt: parseDate(map['createdAt']),
      updatedAt: parseDate(map['updatedAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'alternativeTitle': alternativeTitle,
      'coverImage': coverImage,
      'episodes': episodes,
      'meanScore': meanScore,
      'popularity': popularity,
      'format': format,
      'status': status,
      'season': season,
      'seasonYear': seasonYear,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  SearchResultEntity.empty()
      : id = 0,
        title = '',
        alternativeTitle = '',
        coverImage = '',
        episodes = 0,
        meanScore = 0,
        popularity = 0,
        format = '',
        status = '',
        season = '',
        seasonYear = 0,
        description = '',
        createdAt = DateTime.now(),
        updatedAt = DateTime.now();
}
