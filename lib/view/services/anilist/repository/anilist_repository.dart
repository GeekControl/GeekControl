import 'dart:convert';
import 'package:geekcontrol/core/utils/api_utils.dart';
import 'package:geekcontrol/view/services/anilist/entities/anilist_types_enum.dart';
import 'package:geekcontrol/view/services/anilist/entities/details_entity.dart';
import 'package:geekcontrol/view/services/anilist/entities/releases_anilist_entity.dart';
import 'package:geekcontrol/view/services/anilist/entities/rates_entity.dart';
import 'package:geekcontrol/view/services/anilist/queries/anilist_query.dart';
import 'package:logger/logger.dart';

class AnilistRepository {
  Future<List<MangasRates>> getRateds({required AnilistTypes type}) async {
    try {
      final response =
          await AnilistUtils.basicResponse(query: Query.ratedsQuery(type));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final mangas = MangasRates.toEntityList(jsonResponse);
        return mangas;
      } else {
        Logger().e('Error: ${response.statusCode}');
        return [MangasRates.empty()];
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<ReleasesAnilistEntity>> getReleasesAnimes(
      {required AnilistTypes type, String? year}) async {
    try {
      final response = await AnilistUtils.basicResponse(
        query: Query.releasesQuery(type, year: year),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return ReleasesAnilistEntity.toEntityList(jsonResponse);
      }
      return [ReleasesAnilistEntity.empty()];
    } catch (e) {
      rethrow;
    }
  }

  Future<DetailsEntity> getDetails(int id) async {
    try {
      final response = await AnilistUtils.basicResponse(
        query: Query.detailsQuery(),
        variables: {'id': id},
      );
      Logger().i('Resposta: ${response.statusCode}');
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return DetailsEntity.fromJson(jsonResponse);
      }
      return DetailsEntity.empty;
    } catch (e) {
      rethrow;
    }
  }
}
