class MangasRates {
  int id;
  String title;
  String format;
  String alternativeTitle;
  int meanScore;
  int averageScore;
  String coverImage;
  String status;
  int episodes;
  String source;
  final DateTime createdAt;
  final DateTime updatedAt;

  MangasRates({
    required this.id,
    required this.title,
    required this.format,
    required this.alternativeTitle,
    required this.meanScore,
    required this.averageScore,
    required this.status,
    required this.coverImage,
    required this.episodes,
    required this.source,
    required this.createdAt,
    required this.updatedAt,
  });

  static List<MangasRates> toEntityList(Map<String, dynamic> json) {
    final List<dynamic> mediaList = json['data']['Page']['media'];
    List<MangasRates> entities = mediaList.map((media) {
      return MangasRates(
        id: media?['id'],
        format: media?['format'] ?? '',
        alternativeTitle: media?['title']['romaji'] ?? '',
        title: media?['title']['english'] ?? '',
        source: media?['source'] ?? '',
        episodes: media?['episodes'] ?? 0,
        coverImage:
            media?['coverImage']['large'] ?? media?['coverImage']['extraLarge'],
        meanScore: media?['meanScore'] ?? 0,
        averageScore: media?['averageScore'] ?? 0,
        status: media?['status'] ?? '',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    }).toList();
    return entities;
  }

  static MangasRates fromMap(Map<String, dynamic> map) {
    DateTime parseDate(dynamic value) {
      if (value is String) {
        return DateTime.tryParse(value) ?? DateTime.now();
      }
      if (value is int) {
        return DateTime.fromMillisecondsSinceEpoch(value);
      }
      return DateTime.now();
    }

    return MangasRates(
      id: map['id'] ?? 0,
      format: map['format'] ?? '',
      alternativeTitle: map['alternativeTitle'] ?? '',
      source: map['source'] ?? '',
      title: map['title'] ?? '',
      episodes: map['episodes'] ?? 0,
      coverImage: map['coverImage'] ?? '',
      meanScore: map['meanScore'] ?? 0,
      averageScore: map['averageScore'] ?? 0,
      status: map['status'] ?? '',
      createdAt: parseDate(map['createdAt']),
      updatedAt: parseDate(map['updatedAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'alternativeTitle': alternativeTitle,
      'source': source,
      'format': format,
      'meanScore': meanScore,
      'averageScore': averageScore,
      'coverImage': coverImage,
      'status': status,
      'episodes': episodes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  MangasRates.empty()
      : title = '',
        id = 0,
        format = '',
        alternativeTitle = '',
        source = '',
        episodes = 0,
        meanScore = 0,
        averageScore = 0,
        status = '',
        createdAt = DateTime.now(),
        updatedAt = DateTime.now(),
        coverImage = '';
}
