import 'package:flutter/material.dart';
import 'package:geekcontrol/view/animes/articles/pages/articles_page.dart';
import 'package:geekcontrol/view/home/components/home_search_component.dart';
import 'package:geekcontrol/view/home/components/releases_carousel.dart';
import 'package:geekcontrol/view/home/components/top_rateds_carousel.dart';
import 'package:geekcontrol/core/library/hitagi_cup/features/text/hitagi_text.dart';
import 'package:geekcontrol/view/home/components/banner_carrousel.dart';
import 'package:geekcontrol/view/services/anilist/entities/anilist_types_enum.dart';
import 'package:go_router/go_router.dart';

class HomeDefaultWidget extends StatefulWidget {
  final List<Widget> cardContainters;
  final AnilistTypes type;

  const HomeDefaultWidget({
    super.key,
    required this.cardContainters,
    required this.type,
  });

  @override
  State<HomeDefaultWidget> createState() => _HomeDefaultWidgetState();
}

class _HomeDefaultWidgetState extends State<HomeDefaultWidget> {
  bool _isSearchVisible = false;

  void _toggleSearch() {
    setState(() {
      _isSearchVisible = !_isSearchVisible;
    });
  }

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
                  padding:
                      const EdgeInsets.only(top: 32, left: 8.0, right: 8.0),
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
                            onPressed: _toggleSearch,
                            icon: Icon(
                              _isSearchVisible ? Icons.close : Icons.search,
                            ),
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
                HomeSearchComponent(
                  isSearchVisible: _isSearchVisible,
                  type: widget.type,
                ),
                const SizedBox(height: 12),
                const SizedBox(height: 150, child: BannerCarousel()),
                Padding(
                  padding: const EdgeInsets.only(left: 6.0),
                  child: Column(
                    children: [
                      ReleasesCarousel(type: widget.type),
                      TopRatedsCarousel(type: widget.type),
                    ],
                  ),
                ),
                if (widget.cardContainters.isNotEmpty)
                  Column(children: widget.cardContainters),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
