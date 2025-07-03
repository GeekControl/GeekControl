import 'package:geekcontrol/view/services/anilist/entities/anilist_types_enum.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class Utils {
  static String maxCharacters(int maxCharacters, {required String text}) {
    if (text.length > maxCharacters) {
      return '${text.substring(0, maxCharacters)}...';
    }
    return text;
  }

  DateTime fromUnixTimestamp(int timestamp) {
    return DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
  }

  static String breakLines(String text, int maxLines, int length) {
    if (text.length <= length) {
      return text;
    }
    return text.split('\n').sublist(0, maxLines).join('\n');
  }

  static String timeFromMSeconds(int dateTimestamp) {
    initializeDateFormatting('pt_BR', null);
    DateTime dateTime =
        DateTime.fromMillisecondsSinceEpoch(dateTimestamp * 1000);
    return DateFormat.yMMMMd('pt_BR').format(dateTime);
  }

  static String formatSource(String source) {
    switch (source.toUpperCase()) {
      case 'ORIGINAL':
        return 'Original';
      case 'MANGA':
        return 'Mangá';
      case 'LIGHT_NOVEL':
        return 'Light Novel';
      case 'VISUAL_NOVEL':
        return 'Visual Novel';
      case 'VIDEO_GAME':
        return 'Video Game';
      case 'OTHER':
        return 'Outro';
      case 'NOVEL':
        return 'Novel';
      case 'DOUJINSHI':
        return 'Doujinshi';
      case 'ANIME':
        return 'Anime';
      case 'WEB_NOVEL':
        return 'Web Novel';
      case 'LIVE_ACTION':
        return 'Live Action';
      case 'GAME':
        return 'Jogo';
      case 'COMIC':
        return 'Comic';
      case 'MULTIMEDIA_PROJECT':
        return 'Projeto Multimídia';
      case 'PICTURE_BOOK':
        return 'Livro Ilustrado';
      default:
        return source;
    }
  }

  static String formatStatus(String status) {
    switch (status.toUpperCase()) {
      case 'FINISHED':
        return 'Finalizado';
      case 'RELEASING':
        return 'Lançando';
      case 'NOT_YET_RELEASED':
        return 'Ainda não lançado';
      case 'CANCELLED':
        return 'Cancelado';
      case 'HIATUS':
        return 'Em hiato';
      default:
        return status;
    }
  }

  static String formatSeason(String season) {
    switch (season.toUpperCase()) {
      case 'WINTER':
        return 'Inverno';
      case 'SPRING':
        return 'Primavera';
      case 'SUMMER':
        return 'Verão';
      case 'FALL':
        return 'Outono';
      default:
        return 'Desconhecida';
    }
  }

  static String formatMediaType(String type) {
    switch (type.toUpperCase()) {
      case 'TV':
        return 'TV (Anime)';
      case 'TV_SHORT':
        return 'TV Curta';
      case 'MOVIE':
        return 'Filme';
      case 'SPECIAL':
        return 'Especial';
      case 'OVA':
        return 'OVA';
      case 'ONA':
        return 'ONA';
      case 'MUSIC':
        return 'Música';
      case 'MANGA':
        return 'Mangá';
      case 'NOVEL':
        return 'Novel';
      case 'ONE_SHOT':
        return 'One-shot';
      default:
        return type;
    }
  }

  static String formatType(AnilistTypes type) {
    switch (type) {
      case AnilistTypes.anime:
        return 'Anime';
      case AnilistTypes.manga:
        return 'Mangá';
    }
  }
}
