import 'package:geekcontrol/core/utils/convert_state.dart';
import 'package:geekcontrol/core/utils/entity_mappers.dart';

class ReleasesAnilistEntity {
  final int id;
  final int episodeId;
  final String englishTitle;
  final String bannerImage;
  final String coverImage;
  final int episodes;
  final int? actuallyEpisode;
  final int animeUpdatedAt;
  final String status;
  final String season;
  final int seasonYear;
  final String author;
  final String artist;
  final int? nextEpisode;
  final int airingAt;
  final int meanScore;
  final int averageScore;
  final Map<String, dynamic> startDate;
  final Map<String, dynamic>? endDate;
  final String createdAt;
  final String updatedAt;

  ReleasesAnilistEntity({
    required this.id,
    required this.episodeId,
    required this.englishTitle,
    required this.bannerImage,
    required this.coverImage,
    required this.episodes,
    required this.animeUpdatedAt,
    required this.status,
    required this.season,
    required this.seasonYear,
    required this.startDate,
    required this.endDate,
    required this.author,
    required this.artist,
    required this.nextEpisode,
    required this.airingAt,
    required this.actuallyEpisode,
    required this.meanScore,
    required this.averageScore,
    required this.createdAt,
    required this.updatedAt,
  });

  static List<ReleasesAnilistEntity> toEntityList(Map<String, dynamic> json) {
    final List<dynamic> mediaList = json['data']['Page']['media'];
    List<ReleasesAnilistEntity> entities = mediaList.map((media) {
      return ReleasesAnilistEntity(
        id: media['id'],
        meanScore: media['meanScore'] ?? 0,
        averageScore: media['averageScore'] ?? 0,
        episodeId: media['id'],
        englishTitle: media['title']?['english'] ?? media['title']?['romaji'],
        episodes: media['episodes'] ?? 0,
        animeUpdatedAt: media['updatedAt'] ?? 0,
        status: MangaStates.toPortuguese(media['status'] ?? ''),
        season: media['season'] ?? '',
        seasonYear: media['seasonYear'] ?? 0,
        startDate: media['startDate'] ?? {},
        endDate: media['endDate'] ?? {},
        bannerImage: media['bannerImage'] ?? media['coverImage']['extraLarge'],
        coverImage: media['coverImage']['extraLarge'] ?? '',
        author:
            EntityMappers.roleEntity(media)?['node']?['name']?['full'] ?? 'N/A',
        artist: '',
        nextEpisode: media['nextAiringEpisode']?['episode'] ?? 0,
        airingAt: media['nextAiringEpisode']?['airingAt'] ?? 0,
        actuallyEpisode: EntityMappers.episodes(media),
        createdAt: DateTime.now().toIso8601String(),
        updatedAt: DateTime.now().toIso8601String(),
      );
    }).toList();
    return entities;
  }

  factory ReleasesAnilistEntity.fromJson(Map<String, dynamic> media) {
    final updatedAtRaw = media['updatedAt'];
    final animeUpdatedAt = updatedAtRaw is int
        ? updatedAtRaw
        : DateTime.tryParse(updatedAtRaw ?? '')?.millisecondsSinceEpoch ?? 0;

    return ReleasesAnilistEntity(
      id: media['id'],
      meanScore: media['meanScore'] ?? 0,
      averageScore: media['averageScore'] ?? 0,
      episodeId: media['episodeId'] ?? media['id'],
      englishTitle: media['englishTitle'] ?? '',
      episodes: media['episodes'] ?? 0,
      animeUpdatedAt: animeUpdatedAt,
      status: media['status'] ?? '',
      season: media['season'] ?? '',
      seasonYear: media['seasonYear'] ?? 0,
      startDate: media['startDate'] ?? {},
      endDate: media['endDate'] ?? {},
      bannerImage: media['bannerImage'] ?? '',
      coverImage: media['coverImage'] ?? '',
      author: media['author'] ?? 'N/A',
      artist: media['artist'] ?? '',
      nextEpisode: media['nextEpisode'] ?? 0,
      airingAt: media['airingAt'] ?? 0,
      actuallyEpisode: media['actuallyEpisode'] ?? 0,
      createdAt: media['createdAt'] ?? DateTime.now().toIso8601String(),
      updatedAt: media['updatedAt'] ?? DateTime.now().toIso8601String(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'meanScore': meanScore,
      'averageScore': averageScore,
      'episodeId': episodeId,
      'englishTitle': englishTitle,
      'episodes': episodes,
      'animeUpdatedAt': animeUpdatedAt,
      'status': status,
      'season': season,
      'seasonYear': seasonYear,
      'startDate': startDate,
      'endDate': endDate,
      'bannerImage': bannerImage,
      'coverImage': coverImage,
      'author': author,
      'artist': artist,
      'nextEpisode': nextEpisode,
      'airingAt': airingAt,
      'actuallyEpisode': actuallyEpisode,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  ReleasesAnilistEntity.empty()
      : id = 0,
        meanScore = 0,
        averageScore = 0,
        nextEpisode = 0,
        airingAt = 0,
        episodeId = 0,
        englishTitle = '',
        bannerImage = '',
        coverImage = '',
        episodes = 0,
        animeUpdatedAt = 0,
        status = '',
        season = '',
        seasonYear = 0,
        startDate = {},
        author = '',
        artist = '',
        actuallyEpisode = 0,
        endDate = {},
        createdAt = DateTime.now().toIso8601String(),
        updatedAt = DateTime.now().toIso8601String();
}
