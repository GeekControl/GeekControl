import 'package:flutter/material.dart';
import 'package:geekcontrol/view/animes/ui/pages/details_page.dart';
import 'package:geekcontrol/core/library/hitagi_cup/features/images/hitagi_images.dart';
import 'package:geekcontrol/core/library/hitagi_cup/features/text/hitagi_text.dart';
import 'package:geekcontrol/core/library/hitagi_cup/utils.dart';
import 'package:geekcontrol/core/utils/global_variables.dart';
import 'package:geekcontrol/view/services/anilist/controller/anilist_controller.dart';
import 'package:geekcontrol/view/services/anilist/entities/anilist_seasons_enum.dart';
import 'package:geekcontrol/view/services/anilist/entities/anilist_types_enum.dart';
import 'package:geekcontrol/view/services/anilist/entities/releases_anilist_entity.dart';
import 'package:go_router/go_router.dart';

class SeasonReleasesPage extends StatelessWidget {
  static const route = '/season-releases';
  final String title;
  final AnilistTypes type;
  final AnilistSeasons? season;
  final String? year;

  const SeasonReleasesPage({
    super.key,
    required this.title,
    required this.type,
    required this.season,
    this.year,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: HitagiText(
        text: title,
        typography: HitagiTypography.title,
      )),
      body: FutureBuilder<List<ReleasesAnilistEntity>>(
        future: di<AnilistController>().getReleasesAnimes(
          type: type,
          season: season,
          year: year,
        ),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final animes = snapshot.data!;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _FeaturedAnime(anime: animes.first),
              const SizedBox(height: 24),
              ...animes
                  .skip(1)
                  .map((anime) => _AnimeListItem(release: anime, type: type)),
            ],
          );
        },
      ),
    );
  }
}

class _FeaturedAnime extends StatelessWidget {
  final ReleasesAnilistEntity anime;

  const _FeaturedAnime({required this.anime});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () =>
              GoRouter.of(context).push(DetailsPage.route, extra: anime.id),
          child: Stack(
            alignment: Alignment.bottomLeft,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: HitagiImages(
                  image: anime.bannerImage,
                  width: double.infinity,
                  height: 180,
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const HitagiText(
                  text: 'Último lançamento',
                  typography: HitagiTypography.button,
                ),
              )
            ],
          ),
        ),
        const SizedBox(height: 8),
        HitagiText(
          text: anime.englishTitle,
          typography: HitagiTypography.title,
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Icon(Icons.star, size: 16, color: Colors.orange),
            SizedBox(width: 4),
            HitagiText(
              text: (anime.averageScore / 10).toString(),
              typography: HitagiTypography.button,
            )
          ],
        ),
      ],
    );
  }
}

class _AnimeListItem extends StatelessWidget {
  final AnilistTypes type;
  final ReleasesAnilistEntity release;

  const _AnimeListItem({
    required this.release,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: GestureDetector(
        onTap: () =>
            GoRouter.of(context).push(DetailsPage.route, extra: release.id),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: HitagiImages(
                image: release.coverImage,
                width: 90,
                height: 120,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HitagiText(
                    text: release.englishTitle,
                    typography: HitagiTypography.button,
                  ),
                  const SizedBox(height: 4),
                  HitagiText(
                    text:
                        '${Utils.formatSeason(release.season)} ${release.seasonYear}',
                    typography: HitagiTypography.button,
                  ),
                  const SizedBox(height: 8),
                  HitagiText(
                    typography: HitagiTypography.button,
                    text: type == AnilistTypes.manga
                        ? 'Capítulos: ${release.chapters ?? 0}'
                        : 'Episódios: ${release.actuallyEpisode ?? 0}/${release.episodes}',
                  ),
                  const SizedBox(height: 8),
                  (release.volumes! > 0)
                      ? HitagiText(
                          typography: HitagiTypography.button,
                          text: 'Volumes: ${release.volumes}',
                        )
                      : const SizedBox.shrink(),
                  HitagiText(
                    text:
                        'Nota Média: ${(release.meanScore / 10).toStringAsFixed(1)}',
                    typography: HitagiTypography.button,
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(
                        const Color.fromARGB(
                          113,
                          233,
                          233,
                          233,
                        ),
                      ),
                    ),
                    onPressed: () => {},
                    child: const HitagiText(
                      text: 'Aonde assistir',
                      typography: HitagiTypography.button,
                      color: Colors.deepPurple,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
