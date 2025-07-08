import 'package:flutter/material.dart';
import 'package:geekcontrol/core/library/hitagi_cup/features/dialogs/hitagi_search_dialog.dart';
import 'package:geekcontrol/core/library/hitagi_cup/features/images/hitagi_images.dart';
import 'package:geekcontrol/core/library/hitagi_cup/features/text/hitagi_text.dart';

abstract class HitagiSearchInterface with ChangeNotifier {
  List<SearchEntity> get searchResult;
}

class SearchEntity {
  final String title;
  final String? subtitle;
  final String imageUrl;
  final String? site;
  final void Function()? onTap;

  SearchEntity({
    required this.title,
    required this.imageUrl,
    this.subtitle,
    this.site,
    this.onTap,
  });
}

class HitagiSearchComponent<T extends HitagiSearchInterface>
    extends StatelessWidget {

  final String hintText;
  final T controller;
  final void Function(String query) onSearch;
  final String contentText;

  const HitagiSearchComponent({
    super.key,
    required this.controller,
    required this.onSearch,
    required this.hintText,
    required this.contentText,
  });

  @override
  Widget build(BuildContext context) {
    final textEditCt = TextEditingController();
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(13),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              HitagiSearchDialog(
                controller: textEditCt,
                hintText: hintText,
                onSubmitted: onSearch,
              ),
              if (controller.searchResult.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.blue.shade200),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.article_outlined,
                            size: 16, color: Colors.blue.shade600),
                        const SizedBox(width: 8),
                        HitagiText(
                          text:
                              '${controller.searchResult.length} resultados encontrados',
                          color: Colors.blue.shade700,
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
        Expanded(
          child: controller.searchResult.isEmpty
              ? _buildEmptyState(contentText)
              : _buildSearchResults(),
        ),
      ],
    );
  }

  Widget _buildEmptyState(String contentText) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade50, Colors.blue.shade100],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withAlpha(25),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Icon(Icons.search_outlined,
                size: 80, color: Colors.blue.shade400),
          ),
          const SizedBox(height: 32),
          HitagiText(
            text: contentText,
            typography: HitagiTypography.title,
            color: Colors.grey.shade700,
          ),
          const SizedBox(height: 12),
          HitagiText(
            text:
                'Digite palavras-chave para encontrar\nas notícias mais recentes sobre seus\nanimes favoritos.',
            color: Colors.grey.shade500,
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(13),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.lightbulb_outline,
                    size: 18, color: Colors.amber.shade600),
                const SizedBox(width: 12),
                HitagiText(
                  text: 'Exemplo: "Overlord", "One Piece"',
                  color: Colors.grey.shade600,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: controller.searchResult.length,
      itemBuilder: (_, index) {
        final item = controller.searchResult[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(13),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: item.onTap,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Hero(
                      tag: 'article_${item.title}',
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: HitagiImages(
                          image: item.imageUrl,
                          width: 90,
                          height: 120,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          HitagiText(
                            text: item.title,
                            maxLines: 2,
                            typography: HitagiTypography.body,
                            color: Colors.grey.shade800,
                          ),
                          if (item.subtitle != null) ...[
                            const SizedBox(height: 8),
                            HitagiText(
                              text: item.subtitle!,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              color: Colors.grey.shade600,
                            ),
                          ],
                          if (item.site != null) ...[
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Icon(Icons.access_time,
                                    size: 16, color: Colors.grey.shade400),
                                const SizedBox(width: 4),
                                HitagiText(
                                  text: item.site!,
                                  color: Colors.blue.shade600,
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
