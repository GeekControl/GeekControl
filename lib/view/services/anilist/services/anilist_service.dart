import 'package:geekcontrol/view/services/anilist/entities/anilist_seasons_enum.dart';
import 'package:geekcontrol/view/services/anilist/entities/anilist_types_enum.dart';
import 'package:geekcontrol/view/services/anilist/entities/rates_entity.dart';
import 'package:geekcontrol/view/services/anilist/entities/releases_anilist_entity.dart';
import 'package:geekcontrol/view/services/anilist/repository/anilist_repository.dart';
import 'package:geekcontrol/view/services/cache/cache_handler.dart';
import 'package:geekcontrol/view/services/cache/keys_enum.dart';
import 'package:geekcontrol/view/services/cache/local_cache.dart';

class AnilistService {
  final AnilistRepository _repository;
  final LocalCache _cache;

  AnilistService(this._repository, this._cache);

  Future<List<ReleasesAnilistEntity>> getReleases({
    required AnilistTypes type,
    AnilistSeasons? season,
    String? year,
  }) {
    final site = season != null ? season.value + type.value : type.value;

    return CacheHandler<ReleasesAnilistEntity>(
      cache: _cache,
      key: CacheKeys.releases,
      site: site,
      maxAge: const Duration(hours: 3),
      fetchFromApi: () => _repository.getReleasesAnimes(
        type: type,
        season: season,
        year: year,
      ),
      fromJson: (list) =>
          list.map((e) => ReleasesAnilistEntity.fromJson(e)).toList(),
      toMap: (r) => r.toMap(),
    ).getData();
  }

  Future<List<AnilistRatesEntity>> getMostRated({
    required AnilistTypes type,
  }) {
    return CacheHandler<AnilistRatesEntity>(
      cache: _cache,
      key: CacheKeys.rates,
      site: type.value,
      maxAge: const Duration(days: 7),
      fetchFromApi: () async {
        final rates = await _repository.getRateds(type: type);
        rates.sort((a, b) => b.meanScore.compareTo(a.meanScore));
        return rates;
      },
      fromJson: (list) =>
          list.map((e) => AnilistRatesEntity.fromMap(e)).toList(),
      toMap: (r) => r.toMap(),
    ).getData();
  }
}
