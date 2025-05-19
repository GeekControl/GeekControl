import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:geekcontrol/animes/ui/pages/details_page.dart';
import 'package:geekcontrol/core/library/hitagi_cup/features/carousel/hitagi_image_carousel.dart';
import 'package:geekcontrol/core/library/hitagi_cup/features/text/hitagi_text.dart';
import 'package:geekcontrol/core/library/hitagi_cup/utils.dart';
import 'package:geekcontrol/core/library/hitagi_cup/features/skeletonizer/hitagi_shimmer_efect.dart';
import 'package:geekcontrol/services/anilist/entities/anilist_types_enum.dart';
import 'package:go_router/go_router.dart';

class ItemCard extends StatelessWidget {
  final List<HitagiCarouselItem> items;
  final String title;
  final String route;
  final String? badge;
  final AnilistTypes type;
  final IconData? badgeIcon;

  const ItemCard({
    super.key,
    required this.items,
    required this.title,
    required this.route,
    required this.type,
    this.badge,
    this.badgeIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            HitagiText(
              text: title,
              typography: HitagiTypography.button,
            ),
            IconButton(
              onPressed: () => GoRouter.of(context).push(route, extra: type),
              icon: const Icon(Icons.arrow_forward),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 190,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () => GoRouter.of(context)
                          .push(DetailsPage.route, extra: item.id),
                      child: Stack(
                        children: [
                          Container(
                            height: 150,
                            width: 103,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.grey[900],
                            ),
                            child: Hero(
                              tag: 'release-${item.id}',
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: CachedNetworkImage(
                                  imageUrl: item.image,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) =>
                                      HitagiShimmerEffect(
                                          height: 150, width: 103),
                                  errorWidget: (context, url, error) =>
                                      const Center(child: Icon(Icons.error)),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 6,
                            left: 6,
                            child: Container(
                              height: 10,
                              width: 10,
                              decoration: BoxDecoration(
                                color: item.status == 'Em Lançamento'
                                    ? Colors.green
                                    : Colors.red,
                                border: Border.all(
                                  width: 1.5,
                                  color: Colors.black,
                                ),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 6,
                            right: 5,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.black.withAlpha(180),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  HitagiText(
                                    text: item.score ?? '0.0',
                                    color: Colors.white,
                                    typography: HitagiTypography.small,
                                  ),
                                  const SizedBox(width: 2),
                                  const Icon(
                                    Icons.star,
                                    size: 12,
                                    color: Colors.amber,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
                    SizedBox(
                      width: 105,
                      child: HitagiText(
                        textAlign: TextAlign.center,
                        text: Utils.maxCharacters(20, text: item.title),
                        maxLines: 1,
                        typography: HitagiTypography.alternative,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
