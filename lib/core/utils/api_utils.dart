import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class AnilistUtils {
  static final Map<String, String> headers = {
    'Content-Type': 'application/json'
  };

  static final uri = Uri.parse(dotenv.env['ANILIST_URL'].toString());

  static Future<http.Response> basicResponse({
    String? title,
    required String query,
    Map<String, dynamic>? variables,
  }) async {
    try {
      final queryBody = {
        'query': query,
        if (variables != null) 'variables': variables,
      };
      final response = await http.post(
        AnilistUtils.uri,
        headers: headers,
        body: jsonEncode(queryBody),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}

class IntoxiUtils {
  static final uri = Uri.parse(dotenv.env['INTOXI_URL'].toString());
  static final uriStr = dotenv.env['INTOXI_URL'].toString();
  static final spoilers = Uri.parse(dotenv.env['SPOILERS_URL'].toString());
  static final spoilersStr = dotenv.env['SPOILERS_URL'].toString();
}

class AnimesNewUtils {
  static final uri = Uri.parse(dotenv.env['ANIMESNEW_URL'].toString());
  static final uriStr = dotenv.env['ANIMESNEW_URL'].toString();
}

class OtakuPtUtils {
  static final uri = Uri.parse(dotenv.env['OTAKU_PT_URL'].toString());
  static final uriStr = dotenv.env['OTAKU_PT_URL'].toString();
}

class VoceSabiaAnimeUtils {
  static final String uri = 'https://vocesabianime.com/';
}

class AnimeUnitedUtils {
  static final String uri = 'https://www.animeunited.com.br/';
}

class WallpapersUtils {
  static final String uri =
      'https://www.uhdpaper.com/search?q=Anime&by-date=true';
  static final String wallpaperFlare = 'https://www.wallpaperflare.com/search?wallpaper=';
}
