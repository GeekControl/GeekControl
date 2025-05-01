import 'dart:async';
import 'package:geekcontrol/animes/articles/entities/articles_entity.dart';
import 'package:geekcontrol/services/anilist/entities/releases_anilist_entity.dart';
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

  Future<void> putArticles(String key, dynamic articles) async {
    final db = await _getDatabase();
    var store = StoreRef.main();

    final jsonList =
        articles.map((article) => (article as ArticlesEntity).toMap()).toList();

    await store.record(key).put(db, jsonList);
  }

  Future<void> putAnilistNews(String key, dynamic articles) async {
    final db = await _getDatabase();
    var store = StoreRef.main();

    final jsonList = articles
        .map((article) => (article as ReleasesAnilistEntity).toMap())
        .toList();
    await store.record(key).put(db, jsonList);
  }

  Future<bool> updateCache(String key, int cacheDays) async {
    final cache = await get(key);

    if (cache != null) {
      List<dynamic> content = cache as List<dynamic>;

      final DateTime lastUpdate = DateTime.parse(content[0]['updatedAt']);
      final currentTime = DateTime.now();
      final difference = currentTime.difference(lastUpdate).inDays;

      if (difference > cacheDays) {
        Logger().i('Atualizando cache...');
        return true;
      }
    }
    return false;
  }

  Future<bool> updateArticles(String key) async {
    final db = await _getDatabase();
    var store = StoreRef.main();
    final newsCache = await store.record(key).get(db);

    if (newsCache != null) {
      List<dynamic> jsonList = newsCache as List<dynamic>;

      final List<DateTime> lastUpdate =
          jsonList.map((json) => DateTime.parse(json['updatedAt'])).toList();

      DateTime lastUpdated = lastUpdate.reduce((a, b) => a.isAfter(b) ? a : b);
      final currentTime = DateTime.now();
      final difference = currentTime.difference(lastUpdated).inMinutes;

      if (difference > 30) {
        Logger().i('Atualizando cache...');
        return true;
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
    final value = await store.record(key).get(db);
    return value;
  }

  Future<void> delete(String key) async {
    final db = await _getDatabase();
    var store = StoreRef.main();
    await store.record(key).delete(db);
    Logger().i('Cache deletado');
  }
}
