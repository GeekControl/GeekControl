enum CacheKeys {
  releases(value: 'releases'),
  favorites(value: 'favorites'),
  reads(value: 'reads'),
  anilist(value: 'anilist'),
  articles(value: 'articles'),
  anonymousMode(value: 'anonymousMode'),
  rates(value: 'rates');

  final String value;

  const CacheKeys({required this.value});
}
