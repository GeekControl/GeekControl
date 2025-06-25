enum AnilistSeasons {
  winter('WINTER'),
  spring('SPRING'),
  summer('SUMMER'),
  fall('FALL');

  final String value;
  const AnilistSeasons(this.value);

  static AnilistSeasons fromString(String season) {
    return AnilistSeasons.values.firstWhere(
      (e) => e.value == season.toUpperCase(),
      orElse: () => AnilistSeasons.winter,
    );
  }
}
