import 'package:flutter/material.dart';
import 'package:geekcontrol/core/library/hitagi_cup/features/dialogs/hitagi_dialog.dart';
import 'package:geekcontrol/core/library/hitagi_cup/features/images/hitagi_images.dart';
import 'package:geekcontrol/core/library/hitagi_cup/features/text/hitagi_text.dart';
import 'package:geekcontrol/view/animes/ui/pages/details_page.dart';
import 'package:geekcontrol/view/library/controllers/library_controller.dart';
import 'package:geekcontrol/view/library/model/library_entity.dart';
import 'package:geekcontrol/view/library/ui/components/library_badges.dart';
import 'package:geekcontrol/view/library/ui/components/select_category.dart';
import 'package:go_router/go_router.dart';

class LibraryContent extends StatefulWidget {
  final List<LibraryEntity> filteredContent;
  final LibraryController controller;
  final int? itemsPerLine;
  const LibraryContent({
    super.key,
    required this.filteredContent,
    required this.controller,
    this.itemsPerLine,
  });

  @override
  State<LibraryContent> createState() => _LibraryContentState();
}

class _LibraryContentState extends State<LibraryContent> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: widget.filteredContent.isNotEmpty
            ? GridView.builder(
                itemCount: widget.filteredContent.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: widget.itemsPerLine ?? 2,
                  childAspectRatio: 0.65,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 20,
                ),
                itemBuilder: (context, index) {
                  final item = widget.filteredContent[index];
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
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(20)),
                          ),
                          builder: (_) {
                            return SelectCategory(
                              categories: widget.controller.categories,
                              onSelected: (selectedId) async {
                                final updated =
                                    item.copyWith(categoryId: selectedId);
                                await widget.controller.addInLibrary(updated);
                                await widget.controller.getLibrary();
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
                                child: HitagiImages(image: item.coverImage)),
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
                                        await widget.controller.delete(
                                          item.id,
                                          context,
                                        );
                                        await widget.controller.getLibrary();
                                        setState(() {});
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  HitagiText(
                                    text: item.title,
                                    color: Colors.white,
                                    typography: HitagiTypography.button,
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
                child: HitagiText(text: 'Nenhum item na biblioteca.'),
              ),
      ),
    );
  }
}
