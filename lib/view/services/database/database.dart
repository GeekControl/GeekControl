import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../../core/utils/logger.dart';
import 'package:logger/logger.dart';
import 'package:mongo_dart/mongo_dart.dart';

class Database {
  final Uri _dbUri = Uri.parse(dotenv.env['MONGO_URI']!);
  final String _collection = 'cache-test';
  late Db _db;

  Future<Db> _connect() async {
    _db = await Db.create(_dbUri.toString());
    Loggers.fluxControl(_connect, null);
    try {
      await _db.open();
    } catch (e) {
      throw Exception(e);
    }
    Loggers.fluxControl(_connect, 'Fechando');
    return _db;
  }

  Future<void> _close() async {
    Loggers.fluxControl(_close, null);
    if (_db.isConnected) {
      try {
        await _db.close();
      } catch (e) {
        throw Exception(e);
      }
    }
    Loggers.fluxControl(_close, 'Fechando');
  }

  Future<void> insert(Map<String, dynamic> data) async {
    await _connect();
    Loggers.fluxControl(insert, null);
    await _db.collection(_collection).insert(data);

    Loggers.fluxControl(insert, 'Fechando');
    await _close();
  }

  Future<List<Map<String, dynamic>>> get(int quantity) async {
    Loggers.fluxControl(get, null);
    try {
      await _connect();
      final collection = _db.collection(_collection);

      final response = await collection
          .find(where.sortBy('date', descending: true).limit(quantity))
          .toList();
      return response;
    } catch (e) {
      throw Exception('Error fetching data from MongoDB: $e');
    } finally {
      Loggers.fluxControl(get, 'Fechando');
      await _close();
    }
  }

  Future<DateTime> getLastUpdate() async {
    await _connect();

    Loggers.fluxControl(getLastUpdate, null);
    final collection = _db.collection(_collection);

    final response = await collection.findOne(
      where.sortBy('date', descending: true).limit(1),
    );
    await _close();
    return DateTime.parse(response?['createdAt'] ?? '0000-00-00');
  }

  Future<List<Map<String, dynamic>>> getAll() async {
    try {
      await _connect();
      Loggers.fluxControl(getAll, null);
      final collection = _db.collection(_collection);

      final response = await collection
          .find(where.sortBy('date', descending: true))
          .toList();
      return response;
    } catch (e) {
      throw Exception('Error fetching all data from MongoDB: $e');
    } finally {
      Loggers.fluxControl(getAll, 'Fechando');
      await _close();
    }
  }

  Future<List> checkExistingTitles(List<String> titles) async {
    await _connect();

    try {
      var collection = _db.collection(_collection);

      var query = {
        'title': {'\$in': titles}
      };

      final List<Map<String, dynamic>> existingTitles =
          await collection.find(query).toList();

      Loggers().log(Logger.level, 'Existentes: $existingTitles');
      return existingTitles;
    } catch (e) {
      throw Exception('Error fetching data from MongoDB: $e');
    } finally {
      await _close();
    }
  }
}
