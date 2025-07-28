enum CacheKeys {
  releases(value: 'releases'),
  favorites(value: 'favorites'),
  reads(value: 'reads'),
  anilist(value: 'anilist'),
  articles(value: 'articles'),
  anonymousMode(value: 'anonymousMode'),
  translateReviews(value: 'translateReviews'),
  itemsPerLine(value: 'itemsPerLine'),
  rates(value: 'rates');

  final String value;

  const CacheKeys({required this.value});
}
