import 'package:geekcontrol/view/services/cache/entity/cache_entity.dart';
import 'package:geekcontrol/view/services/cache/keys_enum.dart';
import 'package:geekcontrol/view/services/cache/local_cache.dart';

class CacheHandler<T> {
  final LocalCache _cache;
  final CacheKeys key;
  final String? site;
  final Duration maxAge;
  final List<T> Function(List<dynamic>) fromJson;
  final Future<List<T>> Function() fetchFromApi;
  final Map<String, dynamic> Function(T) toMap;

  CacheHandler({
    required LocalCache cache,
    required this.key,
    required this.maxAge,
    required this.fromJson,
    required this.fetchFromApi,
    required this.toMap,
    this.site,
  }) : _cache = cache;

  Future<List<T>> getData() async {
    final cached = await _cache.get(
      site: site,
      info: CacheEntity(data: null, key: key),
    );

    if (cached is Map<String, dynamic>) {
      final updatedAtStr = cached['updatedAt'];
      final updatedAt = DateTime.tryParse(updatedAtStr ?? '');

      final isExpired =
          updatedAt == null || DateTime.now().difference(updatedAt) > maxAge;

      if (!isExpired && cached['data'] is List) {
        return fromJson(cached['data']);
      }
    }

    final fresh = await fetchFromApi();
    final now = DateTime.now().toIso8601String();

    final toCache = {
      'updatedAt': now,
      'data': fresh.map((item) => toMap(item)).toList(),
    };

    await _cache.put(
      site: site,
      info: CacheEntity(data: toCache, key: key),
    );

    return fresh;
  }
}
