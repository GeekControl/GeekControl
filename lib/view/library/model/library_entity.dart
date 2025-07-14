class LibraryEntity {
  final String id;
  final String title;
  final String coverImage;
  final int? actuallyEpisodes;
  final int? episodes;
  final bool? isFavourite;
  final String categoryId;

  const LibraryEntity({
    required this.id,
    required this.title,
    required this.coverImage,
    required this.categoryId,
    this.actuallyEpisodes,
    this.episodes,
    this.isFavourite,
  });

  factory LibraryEntity.fromJson(Map<String, dynamic> json) {
    return LibraryEntity(
      id: json['id'] as String,
      title: json['title'] as String,
      coverImage: json['coverImage'] as String,
      episodes: json['episodes'] as int?,
      isFavourite: json['isFavourite'] as bool?,
      actuallyEpisodes: json['actuallyEpisodes'] as int?,
      categoryId: json['categoryId'] ?? 'Geral',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'coverImage': coverImage,
      'episodes': episodes,
      'isFavourite': isFavourite,
      'actuallyEpisodes': actuallyEpisodes,
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
      categoryId: categoryId ?? this.categoryId,
      actuallyEpisodes: actuallyEpisodes,
      episodes: episodes,
      isFavourite: isFavourite,
    );
  }
}
