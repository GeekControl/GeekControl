import 'package:geekcontrol/services/cache/local_cache.dart';

class SettingsController {
  final _cache = LocalCache();
  Future<double> getCacheSize() async {
    final size = await  _cache.getCacheSize();
    final sizeMB = (size) / (1024 * 1024);
    return sizeMB;
  }
}
