import 'package:flutter/material.dart';
import 'package:geekcontrol/core/utils/logger.dart';
import 'package:geekcontrol/view/services/anilist/entities/anilist_seasons_enum.dart';
import 'package:geekcontrol/view/services/anilist/entities/anilist_types_enum.dart';
import 'package:geekcontrol/view/services/anilist/entities/details_entity.dart';
import 'package:geekcontrol/view/services/anilist/entities/releases_anilist_entity.dart';
import 'package:geekcontrol/view/services/anilist/entities/rates_entity.dart';
import 'package:geekcontrol/view/services/anilist/repository/anilist_repository.dart';
import 'package:geekcontrol/view/services/cache/keys_enum.dart';
import 'package:geekcontrol/view/services/cache/local_cache.dart';
import 'package:logger/logger.dart';
import 'package:translator/translator.dart';

class AnilistController extends ChangeNotifier {
  final AnilistRepository _repository = AnilistRepository();
  final LocalCache _cache = LocalCache();

  List<ReleasesAnilistEntity> releasesList = [];

  String? translatedDescription = '';

  Future<void> init(AnilistTypes type) async {
    releasesList = await getReleasesAnimes(
      type: type,
    );
  }

  Future<List<ReleasesAnilistEntity>> getReleasesAnimes({
    required AnilistTypes type,
    AnilistSeasons? season,
  }) async {
    final String site = season != null ? season.value + type.value : type.value;
    try {
      final cached = await _cache.get(
        CacheKeys.releases,
        site: site,
      );

      if (cached is List) {
        final timestamps = cached
            .map((e) => DateTime.tryParse(e['updatedAt'] ?? ''))
            .whereType<DateTime>()
            .toList();

        final shouldUpdate = timestamps.isEmpty ||
            DateTime.now().difference(
                  timestamps.reduce((a, b) => a.isAfter(b) ? a : b),
                ) >
                const Duration(hours: 3);

        if (!shouldUpdate) {
          Loggers.cache(operation: '$site-${CacheKeys.releases.value}');
          final releases =
              cached.map((e) => ReleasesAnilistEntity.fromJson(e)).toList();
          releasesList.addAll(releases);
          return releases;
        }
      }
      Loggers.get(site);
      final releases =
          await _repository.getReleasesAnimes(type: type, season: season);
      await _cache.putList<ReleasesAnilistEntity>(
        key: CacheKeys.releases,
        items: releases,
        toMap: (r) => r.toMap(),
        site: season != null ? season.value + type.value : type.value,
      );

      for (var r in releases) {
        releasesList.add(r);
      }

      return releases;
    } catch (e) {
      Loggers.error('Failure to load releases: $e');
      return [ReleasesAnilistEntity.empty()];
    }
  }

  Future<List<MangasRates>> getRates({required AnilistTypes type}) async {
    try {
      final cached = await _cache.get(
        CacheKeys.rates,
        site: type.value,
      );

      if (cached is List) {
        final timestamps = cached
            .map((e) => DateTime.tryParse(e['updatedAt'] ?? ''))
            .whereType<DateTime>()
            .toList();

        final shouldUpdate = timestamps.isEmpty ||
            DateTime.now().difference(
                  timestamps.reduce((a, b) => a.isAfter(b) ? a : b),
                ) >
                const Duration(days: 1);

        if (!shouldUpdate) {
          Loggers.cache(operation: '${CacheKeys.rates.value} - ${type.value}');
          final rates = cached.map((e) => MangasRates.fromMap(e)).toList();
          rates.sort((a, b) => b.meanScore.compareTo(a.meanScore));
          return rates;
        }
      }

      Loggers.cache(operation: '${type.value}-${CacheKeys.releases.value}');
      final rates = await _repository.getRateds(type: type);
      rates.sort((a, b) => b.meanScore.compareTo(a.meanScore));

      final timestamp = DateTime.now().toIso8601String();
      final ratesWithTimestamps = rates.map((r) {
        final map = r.toMap();
        map['updatedAt'] = timestamp;
        return map;
      }).toList();

      await _cache.put(
        CacheKeys.rates,
        ratesWithTimestamps,
        site: type.value,
      );
      return rates;
    } catch (e) {
      Logger().e('Erro ao carregar rates: $e');
      return [MangasRates.empty()];
    }
  }

  Future<DetailsEntity> getDetails(int id) async {
    try {
      final details = await _repository.getDetails(id);
      translatedDescription = await _translateDescription(details.description);
      return details;
    } catch (e) {
      Logger().e('Erro ao carregar detalhes: $e');
      return DetailsEntity.empty;
    }
  }

  Future<String> _translateDescription(String description) async {
    try {
      final translator = GoogleTranslator();
      final plainText = description.replaceAll(RegExp(r'<[^>]*>'), '');
      final result =
          await translator.translate(plainText, from: 'en', to: 'pt');
      return result.text;
    } catch (e) {
      Logger().w('Erro na tradução, mantendo texto original');
      return description;
    }
  }

  List<ReleasesAnilistEntity> get uniqueSeasons {
    final map = <String, ReleasesAnilistEntity>{};
    for (final entry in releasesList) {
      final key = '${entry.season.toUpperCase()}-${entry.seasonYear}';
      if (!map.containsKey(key)) {
        map[key] = entry;
      }
    }
    final seasonOrder = AnilistSeasons.values.map((e) => e.value).toList();
    final list = map.values.where((e) => e.seasonYear == 2025).toList()
      ..sort((a, b) {
        final aKey =
            a.seasonYear * 10 + seasonOrder.indexOf(a.season.toUpperCase());
        final bKey =
            b.seasonYear * 10 + seasonOrder.indexOf(b.season.toUpperCase());
        return aKey.compareTo(bKey);
      });
    final now = DateTime.now();
    final currentSeason = () {
      if (now.month <= 3) return AnilistSeasons.winter.value;
      if (now.month <= 6) return AnilistSeasons.spring.value;
      if (now.month <= 9) return AnilistSeasons.summer.value;
      return AnilistSeasons.fall.value;
    }();
    final startIndex =
        list.indexWhere((e) => e.season.toUpperCase() == currentSeason);

    if (startIndex <= 0) return list;
    return [...list.sublist(startIndex), ...list.sublist(0, startIndex)];
  }
}
