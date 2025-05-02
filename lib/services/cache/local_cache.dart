import 'dart:async';
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

  Future<void> putList<T>(
      String key, List<T> items, Map<String, dynamic> Function(T) toMap) async {
    final db = await _getDatabase();
    var store = StoreRef.main();
    final jsonList = items.map(toMap).toList();
    await store.record(key).put(db, jsonList);
  }

  Future<bool> shouldUpdateCache(String key, Duration maxAge) async {
    final cache = await get(key);

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

  Future<void> put(String key, dynamic value) async {
    final db = await _getDatabase();
    var store = StoreRef.main();
    await store.record(key).put(db, value);
  }

  Future<dynamic> get(String key) async {
    final db = await _getDatabase();
    var store = StoreRef.main();
    return await store.record(key).get(db);
  }

  Future<void> delete(String key) async {
    final db = await _getDatabase();
    var store = StoreRef.main();
    await store.record(key).delete(db);
    Logger().i('Cache deletado');
  }
}
