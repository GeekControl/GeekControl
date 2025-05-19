import 'package:flutter/material.dart';
import 'package:geekcontrol/animes/articles/pages/articles_page.dart';
import 'package:geekcontrol/home/components/card_containter_list.dart';
import 'package:geekcontrol/home/components/releases_carousel.dart';
import 'package:geekcontrol/home/components/top_rateds_carousel.dart';
import 'package:geekcontrol/core/library/hitagi_cup/features/text/hitagi_text.dart';
import 'package:geekcontrol/home/components/banner_carrousel.dart';
import 'package:geekcontrol/home/components/top_bar_widget.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  static const route = '/';
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: TopBarWidget(),
      ),
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
                      const HitagiText(
                        text: 'Últimas notícias',
                        typography: HitagiTypography.button,
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
                      const ReleasesCarousel(),
                      const TopRatedsCarousel(),
                    ],
                  ),
                ),
                HomeCardContainerList(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
