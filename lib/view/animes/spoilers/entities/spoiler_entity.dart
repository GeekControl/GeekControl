class SpoilersEntity {
  final String title;
  final List<String?> images;
  final String? imageUrl;
  final String date;
  final String resume;
  final String category;
  final String content;
  final String url;
  final String? sourceUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  SpoilersEntity({
    required this.title,
    required this.imageUrl,
    required this.date,
    required this.resume,
    required this.category,
    required this.content,
    required this.url,
    required this.sourceUrl,
    required this.createdAt,
    required this.updatedAt,
    required this.images,
  });

  List<SpoilersEntity> toList() {
    return [this];
  }

  static SpoilersEntity fromMap(Map<String, dynamic> map) {
    return SpoilersEntity(
      title: map['title'],
      imageUrl: map['imageUrl'],
      date: map['date'],
      resume: map['author'],
      category: map['category'],
      content: map['content'],
      url: map['url'],
      sourceUrl: map['sourceUrl'],
      images: map['images'],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }

  SpoilersEntity.empty()
      : title = '',
        imageUrl = null,
        date = '',
        resume = '',
        category = '',
        content = '',
        url = '',
        sourceUrl = null,
        images = [],
        createdAt = DateTime.now(),
        updatedAt = DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'imageUrl': imageUrl,
      'date': date,
      'author': resume,
      'category': category,
      'content': content,
      'url': url,
      'sourceUrl': sourceUrl,
      'images': images,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
