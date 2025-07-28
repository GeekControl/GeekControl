class ReviewsEntity {
  final int id;
  final String body;
  final String summary;
  final int userRating;
  final String avatar;
  final String banner;

  ReviewsEntity({
    required this.id,
    required this.body,
    required this.summary,
    required this.userRating,
    required this.avatar,
    required this.banner,
  });

  factory ReviewsEntity.fromMap(Map<String, dynamic> map) {
    return ReviewsEntity(
      id: map['id'] ?? 0,
      body: map['body'] ?? '',
      summary: map['summary'] ?? '',
      userRating: map['rating'] ?? 0,
      avatar: map['user']?['avatar']['large'] ?? '',
      banner: map['user']?['bannerImage'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'body': body,
      'summary': summary,
      'userRating': userRating,
      'avatar': avatar,
      'banner': banner,
    };
  }

  ReviewsEntity.empty()
      : id = 0,
        body = '',
        summary = '',
        userRating = 0,
        banner = '',
        avatar = '';
}

extension ReviewsEntityCopy on ReviewsEntity {
  ReviewsEntity copyWith({
    int? id,
    String? body,
    String? summary,
    int? userRating,
    String? avatar,
    String? banner,
  }) {
    return ReviewsEntity(
      id: id ?? this.id,
      body: body ?? this.body,
      summary: summary ?? this.summary,
      userRating: userRating ?? this.userRating,
      avatar: avatar ?? this.avatar,
      banner: banner ?? this.banner,
    );
  }
}
