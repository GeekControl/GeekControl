import 'package:flutter_dotenv/flutter_dotenv.dart';

class AnimeSources {
  // Intoxi
  static final Uri intoxiUri = Uri.parse(dotenv.env['INTOXI_URL'].toString());
  static final String intoxiUriStr = dotenv.env['INTOXI_URL'].toString();
  static final Uri spoilersUri =
      Uri.parse(dotenv.env['SPOILERS_URL'].toString());
  static final String spoilersUriStr = dotenv.env['SPOILERS_URL'].toString();

  // Animes New
  static final Uri animesNewUri =
      Uri.parse(dotenv.env['ANIMESNEW_URL'].toString());
  static final String animesNewUriStr = dotenv.env['ANIMESNEW_URL'].toString();

  // Otaku PT
  static final Uri otakuPtUri =
      Uri.parse(dotenv.env['OTAKU_PT_URL'].toString());
  static final String otakuPtUriStr = dotenv.env['OTAKU_PT_URL'].toString();

  // Voce Sabia Anime
  static const String voceSabiaAnimeUri = 'https://vocesabianime.com/';

  // Anime United
  static const String animeUnitedUri = 'https://www.animeunited.com.br/';

  // Wallpapers
  static const String wallpapersUri =
      'https://www.uhdpaper.com/search?q=Anime&by-date=true';
  static const String wallpaperFlare =
      'https://www.wallpaperflare.com/search?wallpaper=';
}
