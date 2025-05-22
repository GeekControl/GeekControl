import 'package:flutter/material.dart';
import 'package:geekcontrol/view/animes/articles/pages/articles_page.dart';
import 'package:geekcontrol/view/home/components/releases_carousel.dart';
import 'package:geekcontrol/view/home/components/top_rateds_carousel.dart';
import 'package:geekcontrol/core/library/hitagi_cup/features/text/hitagi_text.dart';
import 'package:geekcontrol/view/home/components/banner_carrousel.dart';
import 'package:geekcontrol/view/services/anilist/entities/anilist_types_enum.dart';
import 'package:go_router/go_router.dart';

class HomeDefaultWidget extends StatelessWidget {
  final List<Widget> cardContainters;
  final AnilistTypes type;

  const HomeDefaultWidget({
    super.key,
    required this.cardContainters,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: const HitagiText(
                          text: 'Últimas notícias',
                          typography: HitagiTypography.button,
                        ),
                      ),
                      IconButton(
                        onPressed: () =>
                            GoRouter.of(context).push(ArticlesPage.route),
                        icon: const Icon(Icons.arrow_forward),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 150,
                  child: BannerCarousel(),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 6.0),
                  child: Column(
                    children: [
                      ReleasesCarousel(type: type),
                      TopRatedsCarousel(type: type),
                    ],
                  ),
                ),
                cardContainters.isNotEmpty
                    ? Column(children: cardContainters)
                    : const SizedBox.shrink(),
                    SizedBox(
                      height: 50,
                    ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
