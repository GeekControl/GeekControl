class ReviewsEntity {
  final int id;
  final String body;
  final String summary;
  final int userRating;
  final String avatar;

  ReviewsEntity({
    required this.id,
    required this.body,
    required this.summary,
    required this.userRating,
    required this.avatar,
  });

  factory ReviewsEntity.fromMap(Map<String, dynamic> map) {
    return ReviewsEntity(
      id: map['id'] ?? 0,
      body: map['body'] ?? '',
      summary: map['summary'] ?? '',
      userRating: map['rating'] ?? 0,
      avatar: map['user']?['avatar']['large'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'body': body,
      'summary': summary,
      'userRating': userRating,
      'avatar': avatar,
    };
  }

  ReviewsEntity.empty()
      : id = 0,
        body = '',
        summary = '',
        userRating = 0,
        avatar = '';
}

extension ReviewsEntityCopy on ReviewsEntity {
  ReviewsEntity copyWith({
    int? id,
    String? body,
    String? summary,
    int? userRating,
    String? avatar,
  }) {
    return ReviewsEntity(
      id: id ?? this.id,
      body: body ?? this.body,
      summary: summary ?? this.summary,
      userRating: userRating ?? this.userRating,
      avatar: avatar ?? this.avatar,
    );
  }
}
