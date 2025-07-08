import 'package:flutter/material.dart';
import 'package:geekcontrol/core/library/hitagi_cup/features/search/hitagi_search_component.dart';
import 'package:geekcontrol/core/library/page_builder/hitagi_page.dart';
import 'package:geekcontrol/core/routes/entities/article_details_route_entity.dart';
import 'package:geekcontrol/core/utils/global_variables.dart';
import 'package:geekcontrol/core/utils/skeletonizer/cards_skeletonizer.dart';
import 'package:geekcontrol/view/animes/articles/pages/article_details_page.dart';
import 'package:geekcontrol/view/animes/components/floating_button.dart';
import 'package:geekcontrol/view/animes/articles/controller/articles_controller.dart';
import 'package:go_router/go_router.dart';

class SearchArticlePage extends HitagiPage<ArticlesController> {
  static const route = '/search/articles';
  const SearchArticlePage({super.key});

  @override
  ArticlesController createController() => di<ArticlesController>();

  @override
  Widget buildLoading(BuildContext context, ArticlesController controller) {
    return const SafeArea(
      child: Scaffold(body: CardsSkeletonizer(itemCount: 5)),
    );
  }

  @override
  Widget build(BuildContext context, ArticlesController ct) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey.shade50,
        floatingActionButton: HitagiFloattingButton(ct: ct),
        body: HitagiSearchComponent<_SearchAdapter>(
          controller: _SearchAdapter(ct, context: context),
          onSearch: (query) =>
              ct.changeSearchSite(ct.currentSite, article: query),
          hintText: 'Pesquise por uma notícia...',
          contentText: 'Descubra as últimas notícias',
        ),
      ),
    );
  }
}

class _SearchAdapter extends ChangeNotifier implements HitagiSearchInterface {
  final BuildContext context;
  final ArticlesController _ct;

  _SearchAdapter(this._ct, {required this.context});

  @override
  List<SearchEntity> get searchResult => _ct.articlesSearch
      .map(
        (e) => SearchEntity(
          title: e.title,
          subtitle: e.resume,
          imageUrl: e.imageUrl ?? '',
          onTap: () => GoRouter.of(context).push(
            ArticleDetailsPage.route,
            extra: ArticleDetailsRouteEntity(
              news: e,
              current: _ct.currentSite.name,
            ).toMap(),
          ),
        ),
      )
      .toList();
}
