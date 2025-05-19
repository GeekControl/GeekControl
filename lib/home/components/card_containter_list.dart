import 'package:flutter/material.dart';
import 'package:geekcontrol/animes/season/season_releases.dart';
import 'package:geekcontrol/core/library/hitagi_cup/features/containter/hitagi_card_container.dart';
import 'package:geekcontrol/core/utils/assets_enum.dart';
import 'package:geekcontrol/services/sites/wallpapers/pages/wallpapers_page.dart';

class HomeCardContainerList extends StatelessWidget {
  const HomeCardContainerList({super.key});

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
        // HitagiCardContainer(
        //   title: 'Mangás mais populares',
        //   subtitle: 'Os mais lidos do mês',
        //   backgroundImageAsset: AssetsEnum.berserker.path,
        //   description:
        //       'Descubra os mangás que estão fazendo sucesso entre os leitores.',
        //   route: WallpapersPage.route,
        //   gradient: [
        //     Color.fromRGBO(0, 0, 0, 1),
        //     const Color.fromARGB(255, 48, 45, 46),
        //   ],
        // )
      ],
    );
  }
}
