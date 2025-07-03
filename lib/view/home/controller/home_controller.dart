import 'package:flutter/material.dart';
import 'package:geekcontrol/core/utils/global_variables.dart';
import 'package:geekcontrol/view/services/cache/local_cache.dart';

class HomeController extends ChangeNotifier {
  final LocalCache _cache = di<LocalCache>();

  Future<void> init(BuildContext context) async {
    await _cache.getUserPreference<bool>('translateReviews').then((value) {
      Globals.translateReviews = value ?? true;
    });
    notifyListeners();
  }
}
