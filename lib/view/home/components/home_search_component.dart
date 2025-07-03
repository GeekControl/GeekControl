import 'package:flutter/material.dart';
import 'package:geekcontrol/core/library/hitagi_cup/features/images/hitagi_images.dart';
import 'package:geekcontrol/core/library/hitagi_cup/utils.dart';
import 'package:geekcontrol/core/utils/global_variables.dart';
import 'package:geekcontrol/core/library/hitagi_cup/features/text/hitagi_text.dart';
import 'package:geekcontrol/view/animes/ui/pages/details_page.dart';
import 'package:geekcontrol/view/services/anilist/entities/anilist_types_enum.dart';
import 'package:geekcontrol/view/services/anilist/entities/search_result_entity.dart';
import 'package:geekcontrol/view/services/anilist/controller/anilist_controller.dart';
import 'package:go_router/go_router.dart';

class HomeSearchComponent extends StatefulWidget {
  final bool isSearchVisible;
  final AnilistTypes type;

  const HomeSearchComponent({
    super.key,
    required this.isSearchVisible,
    required this.type,
  });

  @override
  State<HomeSearchComponent> createState() => _HomeSearchComponentState();
}

class _HomeSearchComponentState extends State<HomeSearchComponent> {
  final _controller = di<AnilistController>();
  final _searchCt = TextEditingController();

  List<SearchResultEntity> _results = [];
  bool _isSearching = false;

  @override
  void dispose() {
    _searchCt.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant HomeSearchComponent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.isSearchVisible && _results.isNotEmpty) {
      _clearSearch();
    }
  }

  void _onSearchChanged(String query) async {
    if (query.isEmpty) {
      _clearSearch();
      return;
    }

    setState(() => _isSearching = true);

    final response = await _controller.search(query, widget.type);
    setState(() {
      _results = response;
      _isSearching = false;
    });
  }

  void _clearSearch() {
    setState(() {
      _searchCt.clear();
      _results = [];
      _isSearching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      child: Column(
        children: [
          AnimatedOpacity(
            duration: const Duration(milliseconds: 300),
            opacity: widget.isSearchVisible ? 1.0 : 0.0,
            child: widget.isSearchVisible
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextField(
                      controller: _searchCt,
                      onSubmitted: _onSearchChanged,
                      decoration: InputDecoration(
                        hintText:
                            'Pesquisar ${Utils.formatType(widget.type)}...',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.surface,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
          const SizedBox(height: 12),
          if (_isSearching)
            const CircularProgressIndicator()
          else if (_results.isNotEmpty)
            Column(
              children: _results.map((anime) {
                return ListTile(
                  leading: HitagiImages(
                    image: anime.coverImage,
                    shimmerWidth: 70,
                    width: 70,
                  ),
                  title: HitagiText(text: anime.title),
                  subtitle: Text(
                    'Nota: ${(anime.meanScore / 10).toStringAsFixed(1)}',
                  ),
                  onTap: () => GoRouter.of(context)
                      .push(DetailsPage.route, extra: anime.id),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
}
