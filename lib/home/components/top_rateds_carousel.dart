import 'package:flutter/material.dart';
import 'package:geekcontrol/animes/ui/pages/top_rateds_page.dart';
import 'package:geekcontrol/core/library/hitagi_cup/features/carousel/hitagi_image_carousel.dart';
import 'package:geekcontrol/home/components/carousel_skeletonizer.dart';
import 'package:geekcontrol/home/components/itemcard.dart';
import 'package:geekcontrol/home/components/slide_animation.dart';
import 'package:geekcontrol/services/anilist/controller/anilist_controller.dart';
import 'package:geekcontrol/services/anilist/entities/anilist_types_enum.dart';
import 'package:geekcontrol/services/anilist/entities/rates_entity.dart';

class TopRatedsCarousel extends StatelessWidget {
  final AnilistTypes type;

  const TopRatedsCarousel({
    super.key,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<MangasRates>>(
      future: AnilistController().getRates(type: type),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CarouselSkeletonizer();
        }

        final items = snapshot.data!
            .map((anime) => HitagiCarouselItem(
                  image: anime.coverImage,
                  title: anime.title,
                  badge: anime.meanScore.toString(),
                  badgeIcon: Icons.star,
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
              title: 'Favoritos da galera',
              route: TopRatedsPage.route,
              type: type,
            ),
          ),
        );
      },
    );
  }
}
