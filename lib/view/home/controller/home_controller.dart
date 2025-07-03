import 'package:flutter/material.dart';
import 'package:geekcontrol/core/utils/global_variables.dart';
import 'package:geekcontrol/view/services/anilist/controller/anilist_controller.dart';
import 'package:geekcontrol/view/services/anilist/entities/anilist_types_enum.dart';
import 'package:geekcontrol/view/services/anilist/entities/search_result_entity.dart';
import 'package:geekcontrol/view/services/cache/local_cache.dart';

class HomeController extends ChangeNotifier {
  final searchCt = TextEditingController();
  final List<SearchResultEntity> searchResults = [];
  final LocalCache _cache = di<LocalCache>();
  final AnilistController _anilist = di<AnilistController>();

  Future<void> init(BuildContext context) async {
    final value = await _cache.getUserPreference<bool>('translateReviews');
    Globals.translateReviews = value ?? true;
    notifyListeners();
  }

  Future<void> search(String query, AnilistTypes type) async {
    final results = await _anilist.search(query, type);
    searchResults
      ..clear()
      ..addAll(results);
    notifyListeners();
  }

  void clearSearch() {
    searchCt.clear();
    searchResults.clear();
    notifyListeners();
  }

  bool get isSearching => searchResults.isNotEmpty;
}
