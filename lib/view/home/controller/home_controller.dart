import 'package:flutter/material.dart';
import 'package:geekcontrol/core/library/page_builder/hitagi_page.dart';
import 'package:geekcontrol/core/utils/global_variables.dart';
import 'package:geekcontrol/view/services/anilist/controller/anilist_controller.dart';
import 'package:geekcontrol/view/services/anilist/entities/anilist_types_enum.dart';
import 'package:geekcontrol/view/services/anilist/entities/search_result_entity.dart';
import 'package:geekcontrol/view/services/cache/keys_enum.dart';

class HomeController extends HitagiController {
  final searchCt = TextEditingController();
  final List<SearchResultEntity> searchResults = [];
  final AnilistController _anilist = di<AnilistController>();

  @override
  Future<void> init({dynamic param}) async {
    handleTry(() async {
      final value =
          await cache.getUserPreference<bool>(CacheKeys.translateReviews.value);
      Globals.translateReviews = value ?? true;
      notifyListeners();
    });
  }

  Future<void> search(String query, AnilistTypes type) async {
    handleTry(() async {
      final results = await _anilist.search(query, type);
      searchResults
        ..clear()
        ..addAll(results);
      notifyListeners();
    });
  }

  void clearSearch() {
    handleTry(() async {
      searchCt.clear();
      searchResults.clear();
      notifyListeners();
    });
  }

  bool _isActive = false;
  void toggleSearch() {
    _isActive = !_isActive;
    notifyListeners();
  }

  bool get isSearching => searchResults.isNotEmpty;
  bool get isSearchVisible => _isActive;
}
