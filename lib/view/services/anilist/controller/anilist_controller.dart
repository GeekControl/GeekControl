import 'package:flutter/material.dart';
import 'package:geekcontrol/core/utils/global_variables.dart';
import 'package:geekcontrol/view/library/controllers/library_controller.dart';
import 'package:geekcontrol/view/library/model/library_entity.dart';
import 'package:geekcontrol/view/services/anilist/entities/anilist_seasons_enum.dart';
import 'package:geekcontrol/view/services/anilist/entities/anilist_types_enum.dart';
import 'package:geekcontrol/view/services/anilist/entities/details_entity.dart';
import 'package:geekcontrol/view/services/anilist/entities/rates_entity.dart';
import 'package:geekcontrol/view/services/anilist/entities/releases_anilist_entity.dart';
import 'package:geekcontrol/view/services/anilist/entities/reviews_entity.dart';
import 'package:geekcontrol/view/services/anilist/entities/search_result_entity.dart';
import 'package:geekcontrol/view/services/anilist/repository/anilist_repository.dart';
import 'package:geekcontrol/view/services/anilist/services/anilist_service.dart';
import 'package:geekcontrol/view/services/firebase/firebase.dart';
import 'package:logger/logger.dart';
import 'package:translator/translator.dart';

class AnilistController extends ChangeNotifier {
  final FirebaseService _firebase = di<FirebaseService>();
  final AnilistService _anilistService = di<AnilistService>();
  final AnilistRepository _repository = di<AnilistRepository>();
  final LibraryController _libraryController = di<LibraryController>();

  List<ReleasesAnilistEntity> releasesList = [];
  String? translatedDescription = '';

  String get libraryDefaultId => _libraryController.libraryDefaultId;

  Future<void> init(AnilistTypes type) async {
    releasesList = await _anilistService.getReleases(type: type);
    notifyListeners();
  }

  Future<List<ReleasesAnilistEntity>> getReleasesAnimes({
    required AnilistTypes type,
    AnilistSeasons? season,
    String? year,
  }) async {
    final result = await _anilistService.getReleases(
      type: type,
      season: season,
      year: year,
    );
    releasesList.addAll(result);
    notifyListeners();
    return result;
  }

  Future<List<AnilistRatesEntity>> getMostRateds({
    required AnilistTypes type,
  }) async {
    final rates = await _anilistService.getMostRated(type: type);
    notifyListeners();
    return rates;
  }

  Future<List<SearchResultEntity>> search(
    String query,
    AnilistTypes type,
  ) async {
    final results = await _repository.search(searchTerm: query, type: type);
    notifyListeners();
    return results;
  }

  Future<DetailsEntity> getDetails(int id) async {
    try {
      final details = await _repository.getDetails(id);
      final translated = await translateDescription(details.description);
      translatedDescription = translated;
      return details.copyWith(reviews: details.reviews);
    } catch (e) {
      Logger().e('Erro ao carregar detalhes: $e');
      return DetailsEntity.empty;
    }
  }

  Future<List<ReviewsEntity>> translateReviews(
      List<ReviewsEntity> reviews) async {
    try {
      final translated = await Future.wait(
        reviews.map((review) async {
          final translatedBody = await translateDescription(review.body);
          final translatedSummary = await translateDescription(review.summary);
          return review.copyWith(
              body: translatedBody, summary: translatedSummary);
        }),
      );
      return translated;
    } catch (e) {
      Logger().w('Erro ao traduzir reviews');
      return reviews;
    }
  }

  Future<String> translateDescription(String description) async {
    try {
      if (Globals.translateReviews) {
        final translator = GoogleTranslator();
        final plainText = description.replaceAll(RegExp(r'<[^>]*>'), '');
        final result =
            await translator.translate(plainText, from: 'en', to: 'pt');
        return result.text;
      }
      return description;
    } catch (e) {
      Logger().w('Erro na tradução, mantendo texto original');
      return description;
    }
  }

  List<ReleasesAnilistEntity> get uniqueSeasons {
    final map = <String, ReleasesAnilistEntity>{};
    for (final entry in releasesList) {
      final key = '${entry.season.toUpperCase()}-${entry.seasonYear}';
      if (!map.containsKey(key)) {
        map[key] = entry;
      }
    }

    final seasonOrder = AnilistSeasons.values.map((e) => e.value).toList();
    final list = map.values.where((e) => e.seasonYear == 2025).toList()
      ..sort((a, b) {
        final aKey =
            a.seasonYear * 10 + seasonOrder.indexOf(a.season.toUpperCase());
        final bKey =
            b.seasonYear * 10 + seasonOrder.indexOf(b.season.toUpperCase());
        return aKey.compareTo(bKey);
      });

    final now = DateTime.now();
    final currentSeason = () {
      if (now.month <= 3) return AnilistSeasons.winter.value;
      if (now.month <= 6) return AnilistSeasons.spring.value;
      if (now.month <= 9) return AnilistSeasons.summer.value;
      return AnilistSeasons.fall.value;
    }();

    final startIndex =
        list.indexWhere((e) => e.season.toUpperCase() == currentSeason);
    if (startIndex <= 0) return list;
    return [...list.sublist(startIndex), ...list.sublist(0, startIndex)];
  }

  Future<void> addToLibrary({
    required String id,
    required String title,
    required String coverImage,
    int? episodes,
    required String categoryId,
  }) async {
    try {
      await _libraryController.addInLibrary(
        LibraryEntity(
          id: id,
          title: title,
          coverImage: coverImage,
          episodes: episodes,
          categoryId: _libraryController.libraryDefaultId,
        ),
      );
    } catch (e) {
      Logger().e('Erro ao adicionar ao library: $e');
    }
  }

  Future<void> putMostRatedInFirebase(List<AnilistRatesEntity> rates) async {
    try {
      for (final r in rates) {
        await _firebase.add(
          collection: 'anilist-most-rated',
          data: r.toMap(),
          doc: r.id.toString(),
          subcollection: 'season-${r.format.toLowerCase()}',
          subdoc: r.title.toLowerCase(),
        );
      }
    } catch (e) {
      Logger().e('Erro ao adicionar ao library: $e');
    }
  }
}
