import 'package:flutter/material.dart';
import 'package:geekcontrol/animes/ui/pages/latest_releases_page.dart';
import 'package:geekcontrol/core/library/hitagi_cup/features/carousel/hitagi_image_carousel.dart';
import 'package:geekcontrol/home/components/carousel_skeletonizer.dart';
import 'package:geekcontrol/home/components/itemcard.dart';
import 'package:geekcontrol/home/components/slide_animation.dart';
import 'package:geekcontrol/services/anilist/controller/anilist_controller.dart';
import 'package:geekcontrol/services/anilist/entities/releases_anilist_entity.dart';

class ReleasesCarousel extends StatelessWidget {
  const ReleasesCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ReleasesAnilistEntity>>(
      future: AnilistController().getReleasesAnimes(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CarouselSkeletonizer();
        }

        final items = snapshot.data!
            .map((anime) => HitagiCarouselItem(
                  image: anime.coverImage,
                  title: anime.englishTitle,
                  route: LatestReleasesPage.route,
                  badge: '${anime.actuallyEpisode}/${anime.episodes}',
                  badgeIcon: Icons.tv,
                  id: anime.id,
                  score: anime.meanScore.toString(),
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
            ),
          ),
        );
      },
    );
  }
}
