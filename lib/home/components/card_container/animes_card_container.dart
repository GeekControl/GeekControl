import 'package:flutter/material.dart';
import 'package:geekcontrol/animes/season/season_releases.dart';
import 'package:geekcontrol/core/library/hitagi_cup/features/containter/hitagi_card_container.dart';
import 'package:geekcontrol/core/utils/assets_enum.dart';
import 'package:geekcontrol/services/anilist/entities/anilist_types_enum.dart';
import 'package:geekcontrol/services/sites/wallpapers/pages/wallpapers_page.dart';

class AnimesCardContainer extends StatelessWidget {
  const AnimesCardContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        HitagiCardContainer(
          title: 'Primavera 2025',
          subtitle: 'Novos animes chegaram!',
          description:
              'Confira os destaques e estreias mais esperadas desta primavera',
          route: SeasonReleasesPage.route,
          backgroundImageAsset: AssetsEnum.luffy.path,
          type: AnilistTypes.anime,
        ),
        HitagiCardContainer(
          title: 'Wallpapers de Animes',
          subtitle: 'Deixe sua tela incrível!',
          backgroundImageAsset: AssetsEnum.hitagi.path,
          description:
              'Explore e baixe wallpapers em alta qualidade dos seus animes favoritos.',
          route: WallpapersPage.route,
          gradient: [
            Color.fromRGBO(104, 61, 106, 1),
            const Color.fromARGB(255, 170, 19, 100),
          ],
        ),
      ],
    );
  }
}
