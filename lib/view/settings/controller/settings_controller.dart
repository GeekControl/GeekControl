import 'package:flutter/material.dart';
import 'package:geekcontrol/core/utils/global_variables.dart';
import 'package:geekcontrol/view/services/cache/local_cache.dart';
import 'package:geekcontrol/view/services/firebase/firebase_auth.dart';

class SettingsController extends ChangeNotifier {
  final _localCache = LocalCache();
  double cacheSize = 0;

  Future<void> init() async {
    cacheSize = await getCacheSize();
    final value = await _localCache.getUserPreference<bool>('translateReviews');
    if (value == null) {
      Globals.translateReviews = true;
      await _localCache.setUserPreference('translateReviews', true);
    }
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

  Future<void> logout(BuildContext context) async {
    await di<FirebaseAuthService>().signOut(context);
    notifyListeners();
  }

  Future<void> setTranslatePrefs(bool value) async {
    await _localCache.setUserPreference('translateReviews', value);
    Globals.translateReviews = value;
    notifyListeners();
  }
}
