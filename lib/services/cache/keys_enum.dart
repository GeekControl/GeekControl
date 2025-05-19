enum CacheKeys {
  releases(value: 'releases'),
  favorites(value: 'favorites'),
  reads(value: 'reads'),
  anilist(value: 'anilist'),
  articles(value: 'articles'),
  rates(value: 'rates');

  final String value;

  const CacheKeys({required this.value});
}
