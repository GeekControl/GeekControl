import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:geekcontrol/animes/ui/pages/details_page.dart';
import 'package:geekcontrol/core/library/hitagi_cup/features/images/hitagi_images.dart';
import 'package:geekcontrol/core/library/hitagi_cup/features/text/hitagi_text.dart';
import 'package:go_router/go_router.dart';

class HitagiCarouselItem {
  final String image;
  final String title;
  final String? badge;
  final IconData? badgeIcon;
  final String? score;
  final int? id;
  final String status;

  HitagiCarouselItem({
    required this.image,
    required this.title,
    this.badge,
    this.badgeIcon,
    this.id,
    this.score,
    this.status = '',
  });
}

class HitagiCarousel extends StatelessWidget {
  final String title;
  final List<HitagiCarouselItem> items;

  const HitagiCarousel({
    super.key,
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth = constraints.maxWidth * 0.45;

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  HitagiText(
                    text: title,
                    typography: HitagiTypography.button,
                  ),
                ],
              ),
              const SizedBox(height: 4),
              CarouselSlider.builder(
                options: CarouselOptions(
                  height: 260,
                  enlargeCenterPage: true,
                  enlargeFactor: 0.2,
                  autoPlayCurve: Curves.easeInOutBack,
                  viewportFraction: 0.45,
                ),
                itemCount: items.length,
                itemBuilder: (context, index, realIndex) {
                  final item = items[index];
                  return GestureDetector(
                    onTap: () => GoRouter.of(context)
                        .push(DetailsPage.route, extra: item.id),
                    child: SizedBox(
                      height: 260,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: HitagiImages(
                                  image: item.image,
                                  height: 200,
                                  width: itemWidth,
                                ),
                              ),
                              if (item.badge != null)
                                Positioned(
                                  top: 8,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 2,
                                      vertical: 1,
                                    ),
                                    child: Row(
                                      children: [
                                        if (item.badgeIcon != null)
                                          Icon(
                                            item.badgeIcon,
                                            size: 14,
                                            color: Colors.white,
                                          ),
                                        if (item.badgeIcon != null)
                                          const SizedBox(width: 4),
                                        HitagiText(
                                          text: item.badge!,
                                          color: Colors.white,
                                          typography: HitagiTypography.button,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: itemWidth,
                            child: HitagiText(
                              typography: HitagiTypography.button,
                              text: item.title,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
