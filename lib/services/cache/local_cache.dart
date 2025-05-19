import 'dart:async';
import 'package:geekcontrol/services/cache/keys_enum.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast_io.dart';

class LocalCache {
  Database? _db;

  Future<Database> _getDatabase() async {
    if (_db == null) {
      final appDocDir = await getApplicationDocumentsDirectory();
      await appDocDir.create(recursive: true);
      final path = '${appDocDir.path}/cache.db';
      _db = await databaseFactoryIo.openDatabase(path);
    }
    return _db!;
  }

  Future<void> putList<T>({
    required CacheKeys key,
    required List<T> items,
    required Map<String, dynamic> Function(T) toMap,
    String? site,
  }) async {
    final db = await _getDatabase();
    var store = StoreRef.main();
    final jsonList = items.map(toMap).toList();
    await store
        .record(site != null ? key.value + site : key.value)
        .put(db, jsonList);
  }

  Future<bool> shouldUpdateCache(CacheKeys key, Duration maxAge, {String? title}) async {
    final cache = await get(key, site: title);
    if (cache is List) {
      final timestamps = cache
          .map((e) => DateTime.tryParse(e['updatedAt'] ?? ''))
          .whereType<DateTime>()
          .toList();

      if (timestamps.isNotEmpty) {
        final lastUpdate = timestamps.reduce((a, b) => a.isAfter(b) ? a : b);
        if (DateTime.now().difference(lastUpdate) > maxAge) {
          Logger().i('Atualizando cache...');
          return true;
        }
      }
    }
    return false;
  }

  Future<void> put(CacheKeys key, dynamic value, {String? site}) async {
    final db = await _getDatabase();
    var store = StoreRef.main();
    final k = site != null ? key.value + site : key.value;
    Logger().i('Adicionando ao cache: $k');
    await store.record(k).put(db, value);
  }

  Future<dynamic> get(CacheKeys key, {String? site}) async {
    final db = await _getDatabase();
    var store = StoreRef.main();

    final k = site != null ? key.value + site : key.value;
    Logger().i('Buscando do cache: $k');

    return await store.record(k).get(db);
  }

  Future<void> delete(CacheKeys key) async {
    final db = await _getDatabase();
    var store = StoreRef.main();
    await store.record(key.value).delete(db);
    Logger().i('Cache deletado');
  }

  Future<void> clearCache() async {
    final db = await _getDatabase();
    var store = StoreRef.main();
    await store.delete(db);
    Logger().i('Todos os dados do cache foram apagados.');
  }

  Future<int> getCacheSize() async {
    final db = await _getDatabase();
    var store = StoreRef.main();
    final records = await store.find(db);
    int size = 0;
    for (var record in records) {
      size += record.value.toString().length;
    }
    Logger().i('Tamanho do cache: $size bytes');
    return size;
  }
}
