class ReviewsEntity {
  final int id;
  final int userId;
  final int mediaId;
  final String body;
  final String summary;
  final int rating;
  final int ratingAmount;
  final int userRating;
  final int score;
  final String siteUrl;
  final int createdAt;
  final int updatedAt;

  ReviewsEntity(
      {required this.id,
      required this.userId,
      required this.mediaId,
      required this.body,
      required this.summary,
      required this.rating,
      required this.ratingAmount,
      required this.userRating,
      required this.score,
      required this.siteUrl,
      required this.createdAt,
      required this.updatedAt});

  static List<ReviewsEntity> toEntityList(Map<String, dynamic> json) {
    final List<dynamic> mediaList =
        json['data']['Page']['media']['edges']['node'];

    List<ReviewsEntity> reviewsList = mediaList.map((node) {
      return ReviewsEntity(
        id: node['id'],
        userId: node['userId'],
        mediaId: node['mediaId'],
        body: node['body'],
        summary: node['summary'],
        rating: node['rating'],
        ratingAmount: node['ratingAmount'],
        userRating: node['userRating'],
        score: node['score'],
        siteUrl: node['siteUrl'],
        createdAt: node['createdAt'],
        updatedAt: node['updatedAt'],
      );
    }).toList();
    return reviewsList;
  }
}
