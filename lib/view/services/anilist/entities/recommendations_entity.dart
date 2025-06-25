class RecommendationsEntity {
  final String title;
  final String description;
  final String coverImage;
  final String bannerImage;
  final String? color;
  final int id;

  RecommendationsEntity({
    required this.title,
    required this.description,
    required this.coverImage,
    required this.bannerImage,
    required this.id,
    this.color,
  });

  factory RecommendationsEntity.fromMap(Map<String, dynamic> map) {
    final media = map['mediaRecommendation'] ?? {};

    return RecommendationsEntity(
      title: media['title']?['english'] ?? '',
      id: media['id'] ?? 0,
      description: (media['description'] ?? ''),
      coverImage: media['coverImage']?['extraLarge'] ?? '',
      bannerImage: media['bannerImage'] ?? '',
      color: media['coverImage']?['color'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'coverImage': coverImage,
      'bannerImage': bannerImage,
      'color': color,
      'id': id,
    };
  }

  RecommendationsEntity.empty()
      : title = '',
        description = '',
        coverImage = '',
        bannerImage = '',
        id = 0,
        color = '';
}
