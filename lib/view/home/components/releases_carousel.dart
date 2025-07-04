import 'package:flutter/material.dart';
import 'package:geekcontrol/view/animes/ui/pages/latest_releases_page.dart';
import 'package:geekcontrol/core/library/hitagi_cup/features/carousel/hitagi_image_carousel.dart';
import 'package:geekcontrol/core/utils/global_variables.dart';
import 'package:geekcontrol/view/home/components/carousel_skeletonizer.dart';
import 'package:geekcontrol/view/home/components/itemcard.dart';
import 'package:geekcontrol/view/home/components/slide_animation.dart';
import 'package:geekcontrol/view/services/anilist/controller/anilist_controller.dart';
import 'package:geekcontrol/view/services/anilist/entities/anilist_types_enum.dart';
import 'package:geekcontrol/view/services/anilist/entities/releases_anilist_entity.dart';

class ReleasesCarousel extends StatelessWidget {
  final AnilistTypes type;
  const ReleasesCarousel({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ReleasesAnilistEntity>>(
      future: di<AnilistController>().getReleasesAnimes(type: type),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CarouselSkeletonizer();
        }

        final items = snapshot.data!
            .map((anime) => HitagiCarouselItem(
                  image: anime.coverImage,
                  title: anime.englishTitle,
                  badge: '${anime.actuallyEpisode}/${anime.episodes}',
                  badgeIcon: Icons.tv,
                  id: anime.id,
                  score: (anime.meanScore / 10).toStringAsFixed(1),
                  status: anime.status,
                ))
            .toList();

        return SlideAndScaleAnimation(
          child: Padding(
            padding: const EdgeInsets.only(left: 4.0, top: 10.0),
            child: ItemCard(
              items: items,
              title: 'Últimos lançamentos',
              route: LatestReleasesPage.route,
              type: type,
            ),
          ),
        );
      },
    );
  }
}
