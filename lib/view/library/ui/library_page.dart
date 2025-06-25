import 'package:flutter/material.dart';
import 'package:geekcontrol/core/library/hitagi_cup/features/dialogs/hitagi_dialog.dart';
import 'package:geekcontrol/core/library/hitagi_cup/features/images/hitagi_images.dart';
import 'package:geekcontrol/core/library/hitagi_cup/features/text/hitagi_text.dart';
import 'package:geekcontrol/core/utils/global_variables.dart';
import 'package:geekcontrol/view/animes/ui/pages/details_page.dart';
import 'package:geekcontrol/view/library/controllers/library_controller.dart';
import 'package:geekcontrol/view/library/ui/components/select_category.dart';
import 'package:geekcontrol/view/library/ui/components/library_badges.dart';
import 'package:geekcontrol/view/library/ui/components/library_category.dart';
import 'package:go_router/go_router.dart';

class LibraryPage extends StatefulWidget {
  static const route = '/library';
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  final ct = di<LibraryController>();
  String? selectedCategoryId;

  @override
  void initState() {
    super.initState();
    ct.init();
    load();
  }

  void load() async {
    await ct.getLibrary();
    await ct.getCategories();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final filteredContent = ct.filterByCategory(selectedCategoryId);

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: HitagiText(
              text: 'Minha Biblioteca',
              typography: HitagiTypography.title,
            ),
          ),
          const SizedBox(height: 16),
          LibraryCategory(
            categories: ct.categories,
            onCreate: (cat) async {
              await ct.createCategory(cat);
              setState(() {});
            },
            onSelected: (cat) {
              selectedCategoryId = cat?.id;
              setState(() {});
            },
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Globals.isLoggedIn && filteredContent.isNotEmpty
                  ? GridView.builder(
                      itemCount: filteredContent.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.65,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 20,
                      ),
                      itemBuilder: (context, index) {
                        final item = filteredContent[index];
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.4),
                                blurRadius: 16,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: GestureDetector(
                            onTap: () => GoRouter.of(context).push(
                              DetailsPage.route,
                              extra: int.parse(item.id),
                            ),
                            onLongPress: () async {
                              await showModalBottomSheet(
                                context: context,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(20)),
                                ),
                                builder: (_) {
                                  return SelectCategory(
                                    categories: ct.categories,
                                    onSelected: (selectedId) async {
                                      final updated =
                                          item.copyWith(categoryId: selectedId);
                                      await ct.addInLibrary(updated);
                                      await ct.getLibrary();
                                      setState(() {});
                                    },
                                  );
                                },
                              );
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Stack(
                                children: [
                                  Positioned.fill(
                                      child:
                                          HitagiImages(image: item.coverImage)),
                                  Positioned.fill(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            Colors.transparent,
                                            Colors.black.withValues(alpha: 0.8),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 5,
                                    right: 10,
                                    child: IconButton(
                                      onPressed: () {
                                        HitagiDialog(
                                            title: 'Excluir?',
                                            description:
                                                'Você tem certeza que deseja excluir este item?',
                                            onPressedButtonAccept: () async {
                                              await di<LibraryController>()
                                                  .delete(
                                                item.id,
                                                context,
                                              );
                                              setState(() {
                                                load();
                                              });
                                            }).show(context);
                                      },
                                      icon: Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 16,
                                    left: 12,
                                    right: 12,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.title,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            if (item.episodes != null)
                                              LibraryBadges(
                                                text: '${item.episodes}',
                                                icon: Icons.play_arrow,
                                                color: const Color(0xFF00B894),
                                              ),
                                            if (item.chapters != null)
                                              LibraryBadges(
                                                text: '${item.chapters}',
                                                icon: Icons.menu_book,
                                                color: const Color(0xFF6C5CE7),
                                              ),
                                            if (item.volumes != null)
                                              LibraryBadges(
                                                text: '${item.volumes}',
                                                icon: Icons.library_books,
                                                color: const Color(0xFFE17055),
                                              ),
                                            if (item.avaregeScore != null)
                                              LibraryBadges(
                                                text: item.avaregeScore!,
                                                icon: Icons.star,
                                                color: const Color(0xFFFC4B4B),
                                              ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  : Center(
                      child: HitagiText(
                        text: Globals.isLoggedIn
                            ? 'Nenhum item na biblioteca.'
                            : 'Faça login para visualizar.',
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
