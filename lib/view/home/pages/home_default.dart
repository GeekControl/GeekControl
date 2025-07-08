import 'package:flutter/material.dart';
import 'package:geekcontrol/core/library/page_builder/hitagi_page.dart';
import 'package:geekcontrol/core/utils/global_variables.dart';
import 'package:geekcontrol/view/home/controller/home_controller.dart';
import 'package:geekcontrol/view/home/pages/search_anilist.dart';
import 'package:go_router/go_router.dart';
import 'package:geekcontrol/view/animes/articles/pages/articles_page.dart';
import 'package:geekcontrol/view/home/components/releases_carousel.dart';
import 'package:geekcontrol/view/home/components/top_rateds_carousel.dart';
import 'package:geekcontrol/core/library/hitagi_cup/features/text/hitagi_text.dart';
import 'package:geekcontrol/view/home/components/banner_carrousel.dart';
import 'package:geekcontrol/view/services/anilist/entities/anilist_types_enum.dart';

class HomeDefaultWidget extends HitagiPage<HomeController> {
  final List<Widget> cardContainters;
  final AnilistTypes type;

  const HomeDefaultWidget({
    super.key,
    required this.cardContainters,
    required this.type,
  });

  @override
  HomeController createController() => di<HomeController>();

  @override
  Widget build(BuildContext context, HomeController ct) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 32,
                    left: 8.0,
                    right: 8.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const HitagiText(
                        text: 'Últimas notícias',
                        typography: HitagiTypography.button,
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () => GoRouter.of(context)
                                .push(SearchAnilist.route, extra: type),
                            icon: const Icon(Icons.search),
                          ),
                          IconButton(
                            onPressed: () =>
                                GoRouter.of(context).push(ArticlesPage.route),
                            icon: const Icon(Icons.arrow_forward),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                const SizedBox(height: 210, child: BannerCarousel()),
                Padding(
                  padding: const EdgeInsets.only(left: 6.0),
                  child: Column(
                    children: [
                      ReleasesCarousel(type: type),
                      TopRatedsCarousel(type: type),
                    ],
                  ),
                ),
                if (cardContainters.isNotEmpty)
                  Column(children: cardContainters),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
