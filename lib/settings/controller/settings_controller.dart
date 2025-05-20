import 'package:flutter/material.dart';
import 'package:geekcontrol/services/cache/local_cache.dart';

class SettingsController extends ChangeNotifier {
  final _localCache = LocalCache();
  double cacheSize = 0;

  Future<void> init() async {
    cacheSize = await getCacheSize();
    notifyListeners();
  }

  Future<double> getCacheSize() async {
    final size = await _localCache.getCacheSize();
    final sizeMB = (size) / (1024 * 1024);
    return sizeMB;
  }

  Future<void> clearCache() async {
    await _localCache.clearCache();
    cacheSize = await getCacheSize();
    notifyListeners();
  }
}
