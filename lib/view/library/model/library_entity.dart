class LibraryEntity {
  final String id;
  final String title;
  final String? description;
  final String coverImage;
  final String bannerImage;
  final int? actuallyEpisodes;
  final int? episodes;
  final int? chapters;
  final int? volumes;
  final bool? isFavourite;
  final String? avaregeScore;
  final String categoryId;

  const LibraryEntity({
    required this.id,
    required this.title,
    this.description,
    required this.coverImage,
    required this.bannerImage,
    required this.categoryId,
    this.actuallyEpisodes,
    this.episodes,
    this.chapters,
    this.volumes,
    this.isFavourite,
    this.avaregeScore,
  });

  factory LibraryEntity.fromJson(Map<String, dynamic> json) {
    return LibraryEntity(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      coverImage: json['coverImage'] as String,
      bannerImage: json['bannerImage'] as String,
      episodes: json['episodes'] as int?,
      chapters: json['chapters'] as int?,
      volumes: json['volumes'] as int?,
      isFavourite: json['isFavourite'] as bool?,
      actuallyEpisodes: json['actuallyEpisodes'] as int?,
      avaregeScore: json['avaregeScore'] as String?,
      categoryId: json['categoryId'] ?? 'Geral',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'coverImage': coverImage,
      'bannerImage': bannerImage,
      'episodes': episodes,
      'chapters': chapters,
      'volumes': volumes,
      'isFavourite': isFavourite,
      'actuallyEpisodes': actuallyEpisodes,
      'avaregeScore': avaregeScore,
      'categoryId': categoryId,
    };
  }

  LibraryEntity copyWith({
    String? categoryId,
  }) {
    return LibraryEntity(
      id: id,
      title: title,
      coverImage: coverImage,
      bannerImage: bannerImage,
      categoryId: categoryId ?? this.categoryId,
      description: description,
      actuallyEpisodes: actuallyEpisodes,
      episodes: episodes,
      chapters: chapters,
      volumes: volumes,
      isFavourite: isFavourite,
      avaregeScore: avaregeScore,
    );
  }
}
