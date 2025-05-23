import 'package:flutter/material.dart';
import 'package:geekcontrol/view/animes/season/season_releases.dart';
import 'package:geekcontrol/core/library/hitagi_cup/features/containter/hitagi_card_container.dart';
import 'package:geekcontrol/core/utils/assets_enum.dart';
import 'package:geekcontrol/view/services/anilist/entities/anilist_types_enum.dart';

class MangasCardContainer extends StatelessWidget {
  const MangasCardContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        HitagiCardContainer(
          title: 'Mangás em alta',
          subtitle: 'Os mais populares do momento',
          description:
              'Confira os mangás que estão bombando e ganhando destaque na comunidade.',
          route: SeasonReleasesPage.route,
          backgroundImageAsset: BannerAssetsEnum.berserker,
          gradient: [
            Color.fromRGBO(74, 73, 73, 1),
            const Color.fromARGB(255, 0, 0, 0),
          ],
          type: AnilistTypes.manga,
        ),
      ],
    );
  }
}
