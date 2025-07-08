import 'package:flutter/material.dart';
import 'package:geekcontrol/core/library/hitagi_cup/features/search/hitagi_search_component.dart';
import 'package:geekcontrol/core/library/hitagi_cup/utils.dart';
import 'package:geekcontrol/core/library/page_builder/hitagi_page.dart';
import 'package:geekcontrol/core/utils/global_variables.dart';
import 'package:geekcontrol/view/animes/ui/pages/details_page.dart';
import 'package:geekcontrol/view/home/controller/home_controller.dart';
import 'package:geekcontrol/view/services/anilist/entities/anilist_types_enum.dart';
import 'package:go_router/go_router.dart';

class SearchAnilist extends HitagiPage<HomeController> {
  static const route = '/search/anilist';
  final AnilistTypes type;

  const SearchAnilist({super.key, required this.type});

  @override
  HomeController createController() => di<HomeController>();

  @override
  Widget build(BuildContext context, HomeController controller) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: HitagiSearchComponent<_SearchAdapter>(
        controller: _SearchAdapter(controller, context: context),
        onSearch: (query) => controller.search(query, type),
        hintText: 'Pesquise por ${Utils.formatType(type).toLowerCase()}s...',
        contentText: 'Encontre ${Utils.formatType(type)}s incríveis! ',
      ),
    );
  }
}

class _SearchAdapter extends ChangeNotifier implements HitagiSearchInterface {
  final BuildContext context;
  final HomeController _home;

  _SearchAdapter(this._home, {required this.context});

  @override
  List<SearchEntity> get searchResult => _home.searchResults
      .map(
        (e) => SearchEntity(
          title: e.title,
          subtitle: Utils.formatDescription(e.description),
          imageUrl: e.coverImage,
          onTap: () =>
              GoRouter.of(context).push(DetailsPage.route, extra: e.id),
        ),
      )
      .toList();
}
