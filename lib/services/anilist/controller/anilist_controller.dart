import 'package:geekcontrol/services/anilist/entities/details_entity.dart';
import 'package:geekcontrol/services/anilist/entities/releases_anilist_entity.dart';
import 'package:geekcontrol/services/anilist/entities/rates_entity.dart';
import 'package:geekcontrol/services/anilist/repository/anilist_repository.dart';
import 'package:geekcontrol/services/cache/keys_enum.dart';
import 'package:geekcontrol/services/cache/local_cache.dart';
import 'package:logger/logger.dart';
import 'package:translator/translator.dart';

class AnilistController {
  final AnilistRepository _repository = AnilistRepository();
  final LocalCache _cache = LocalCache();
  final _logger = Logger();

  String? translatedDescription = '';

  Future<List<ReleasesAnilistEntity>> getReleasesAnimes() async {
    const cacheKey = CacheKeys.releases;
    try {
      final cached = await _cache.get(cacheKey.key);

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
          _logger.i('Usando cache para releases');
          return cached.map((e) => ReleasesAnilistEntity.fromJson(e)).toList();
        }
      }

      _logger.i('Buscando releases da web');
      final releases = await _repository.getReleasesAnimes();
      await _cache.putList<ReleasesAnilistEntity>(
        cacheKey.key,
        releases,
        (r) => r.toMap(),
      );
      return releases;
    } catch (e) {
      _logger.e('Erro ao carregar releases: $e');
      return [ReleasesAnilistEntity.empty()];
    }
  }

  Future<List<MangasRates>> getRates() async {
    const cacheKey = CacheKeys.rates;

    try {
      final cached = await _cache.get(cacheKey.key);

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
          _logger.i('Usando cache para rates');
          final rates = cached.map((e) => MangasRates.fromMap(e)).toList();
          rates.sort((a, b) => b.meanScore.compareTo(a.meanScore));
          return rates;
        }
      }

      _logger.i('Buscando rates da web');
      final rates = await _repository.getRateds();
      rates.sort((a, b) => b.meanScore.compareTo(a.meanScore));

      final timestamp = DateTime.now().toIso8601String();
      final ratesWithTimestamps = rates.map((r) {
        final map = r.toMap();
        map['updatedAt'] = timestamp;
        return map;
      }).toList();

      await _cache.put(cacheKey.key, ratesWithTimestamps);
      return rates;
    } catch (e) {
      _logger.e('Erro ao carregar rates: $e');
      return [MangasRates.empty()];
    }
  }

  Future<DetailsEntity> getDetails(int id) async {
    try {
      final details = await _repository.getDetails(id);
      translatedDescription = await _translateDescription(details.description);
      return details;
    } catch (e) {
      _logger.e('Erro ao carregar detalhes: $e');
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
      _logger.w('Erro na tradução, mantendo texto original');
      return description;
    }
  }
}
