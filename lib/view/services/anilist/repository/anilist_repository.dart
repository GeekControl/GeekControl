import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geekcontrol/view/services/anilist/entities/anilist_seasons_enum.dart';
import 'package:geekcontrol/view/services/anilist/entities/anilist_types_enum.dart';
import 'package:geekcontrol/view/services/anilist/entities/details_entity.dart';
import 'package:geekcontrol/view/services/anilist/entities/releases_anilist_entity.dart';
import 'package:geekcontrol/view/services/anilist/entities/rates_entity.dart';
import 'package:geekcontrol/view/services/anilist/entities/search_result_entity.dart';
import 'package:geekcontrol/view/services/anilist/queries/anilist_query.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class AnilistRepository {
  static Future<http.Response> _get({
    required String query,
    Map<String, dynamic>? variables,
  }) async {
    try {
      final queryBody = {
        'query': query,
        if (variables != null) 'variables': variables,
      };
      final response = await http.post(
        Uri.parse(dotenv.env['ANILIST_URL'].toString()),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(queryBody),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<AnilistRatesEntity>> getRateds(
      {required AnilistTypes type}) async {
    try {
      final response = await _get(query: Query.ratedsQuery(type));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final mangas = AnilistRatesEntity.toEntityList(jsonResponse);
        return mangas;
      } else {
        Logger().e('Error: ${response.statusCode}');
        return [AnilistRatesEntity.empty()];
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<ReleasesAnilistEntity>> getReleasesAnimes({
    required AnilistTypes type,
    String? year,
    AnilistSeasons? season,
  }) async {
    try {
      final response = await _get(
        query: Query.releasesQuery(type, year: year, season: season),
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
      final response = await _get(
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

  Future<List<SearchResultEntity>> search({
    required String searchTerm,
    required AnilistTypes type,
  }) async {
    try {
      final response = await _get(
        query: Query.searchQuery(searchTerm, type),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return SearchResultEntity.toEntityList(jsonResponse);
      }

      Logger().e('Erro na busca: ${response.statusCode}');
      return [SearchResultEntity.empty()];
    } catch (e) {
      Logger().e('Exceção na busca: $e');
      return [SearchResultEntity.empty()];
    }
  }
}
