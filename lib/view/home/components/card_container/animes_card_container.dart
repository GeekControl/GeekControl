import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:geekcontrol/view/animes/season/season_releases.dart';
import 'package:geekcontrol/core/library/hitagi_cup/features/containter/hitagi_card_container.dart';
import 'package:geekcontrol/core/library/hitagi_cup/utils.dart';
import 'package:geekcontrol/core/utils/assets_enum.dart';
import 'package:geekcontrol/core/utils/global_variables.dart';
import 'package:geekcontrol/view/home/components/card_container/visual_config.dart';
import 'package:geekcontrol/view/services/anilist/controller/anilist_controller.dart';
import 'package:geekcontrol/view/services/anilist/entities/anilist_seasons_enum.dart';
import 'package:geekcontrol/view/services/anilist/entities/anilist_types_enum.dart';
import 'package:geekcontrol/view/services/sites/wallpapers/pages/wallpapers_page.dart';

class AnimesCardContainer extends StatefulWidget {
  const AnimesCardContainer({super.key});

  @override
  State<AnimesCardContainer> createState() => _AnimesCardContainerState();
}

class _AnimesCardContainerState extends State<AnimesCardContainer> {
  final ct = di<AnilistController>();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ct.getReleasesAnimes(
        type: AnilistTypes.anime,
      );
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading || ct.uniqueSeasons.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: ct.uniqueSeasons.length,
          itemBuilder: (context, index, realIndex) {
            final entry = ct.uniqueSeasons[index];
            final config = VisualConfig
                .animeVisuals[index % VisualConfig.animeVisuals.length];
            return HitagiCardContainer(
              title: '${Utils.formatSeason(entry.season)} ${entry.seasonYear}',
              subtitle: 'Novidades da Temporada',
              backgroundImageAsset: config.image,
              description:
                  'Descubra os lançamentos mais recentes de animes e mergulhe em novas histórias.',
              route: SeasonReleasesPage.route,
              gradient: config.gradient,
              season: AnilistSeasons.fromString(entry.season),
              year: entry.seasonYear.toString(),
            );
          },
          options: CarouselOptions(
            height: 220,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 10),
            autoPlayCurve: Curves.fastOutSlowIn,
            enableInfiniteScroll: false,
            viewportFraction: 1,
          ),
        ),
        const SizedBox(height: 6),
        HitagiCardContainer(
          title: 'Wallpapers de Animes',
          subtitle: 'Deixe sua tela incrível!',
          backgroundImageAsset: AssetsEnum.hitagi.path,
          description:
              'Explore e baixe wallpapers em alta qualidade dos seus animes favoritos.',
          route: WallpapersPage.route,
          gradient: [
            const Color.fromRGBO(104, 61, 106, 1),
            const Color.fromARGB(255, 170, 19, 100),
          ],
        ),
      ],
    );
  }
}
