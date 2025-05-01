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
  final LocalCache _localCache = LocalCache();

  String? translatedDescription = '';

  Future<List<ReleasesAnilistEntity>> getReleasesAnimes() async {
    try {
      return await _repository.getReleasesAnimes();
    } catch (e) {
      Logger().e('Error loading releases: $e');
      return [ReleasesAnilistEntity.empty()];
    }
  }

  Future<List<MangasRates>> getRates() async {
    try {
      final rates = await _repository.getRateds();
      rates.sort((a, b) => b.meanScore.compareTo(a.meanScore));
      return rates;
    } catch (e) {
      Logger().e('Error loading rates: $e');
      return [MangasRates.empty()];
    }
  }

  Future<List<MangasRates>> ratesCache() async {
    try {
      final cache = await _localCache.get(CacheKeys.rates.key);
      final updateCache =
          await _localCache.updateCache(CacheKeys.rates.key, 30);

      if (cache != null && updateCache) {
        List<dynamic> content = cache as List<dynamic>;
        return content.map((e) => MangasRates.fromMap(e)).toList();
      } else {
        final rates = await getRates();
        List<Map<String, dynamic>> ratesMap =
            rates.map((rate) => rate.toMap()).toList();
        await _localCache.put(CacheKeys.rates.key, ratesMap);
        return rates;
      }
    } catch (e) {
      Logger().e('Error loading rates cache: $e');
      return [MangasRates.empty()];
    }
  }

  Future<DetailsEntity> getDetails(int id) async {
    try {
      final details = await _repository.getDetails(id);
      translatedDescription = await _translateDescription(details.description);
      return details;
    } catch (e) {
      Logger().e('Error loading details: $e');
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
      return description;
    }
  }
}
