import 'package:flutter/material.dart';
import 'package:geekcontrol/core/library/hitagi_cup/features/dialogs/hitagi_toast.dart';
import 'package:geekcontrol/core/library/hitagi_cup/features/text/hitagi_text.dart';
import 'package:geekcontrol/core/library/page_builder/hitagi_page.dart';
import 'package:geekcontrol/core/utils/global_variables.dart';
import 'package:geekcontrol/view/auth/ui/move_to_login.dart';
import 'package:geekcontrol/view/library/controllers/library_controller.dart';
import 'package:geekcontrol/view/library/ui/components/custom_bottom_sheet.dart';
import 'package:geekcontrol/view/library/ui/components/library_content.dart';
import 'package:geekcontrol/view/library/ui/components/library_category.dart';
import 'package:geekcontrol/view/services/cache/keys_enum.dart';
import 'package:go_router/go_router.dart';

class LibraryPage extends HitagiPage<LibraryController> {
  static const route = '/library';
  const LibraryPage({super.key});

  @override
  LibraryController createController() => di<LibraryController>();

  @override
  Widget build(BuildContext context, LibraryController controller) {
    return Scaffold(
      body: Globals.isLoggedIn
          ? StatefulBuilder(
              builder: (context, setState) {
                final filteredContent = controller.filteredContent;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 32),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: HitagiText(
                            text: 'Minha Biblioteca',
                            typography: HitagiTypography.title,
                          ),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: IconButton(
                              onPressed: () async {
                                final result =
                                    await CustomBottomSheet.showSlider(
                                  context: context,
                                  title: 'Imagens por linha',
                                  currentValue: controller.imagesPerLine,
                                  min: 1,
                                  max: 3,
                                );
                                if (result != null) {
                                  setState(() {
                                    controller.imagesPerLine = result;
                                    controller.savePreferences(
                                      context,
                                      CacheKeys.itemsPerLine.value,
                                      result,
                                    );
                                  });
                                }
                              },
                              icon: const Icon(Icons.settings),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    LibraryCategory(
                      categories: controller.categories,
                      onCreate: (cat) async {
                        await controller.createCategory(cat);
                        setState(() {});
                      },
                      onSelected: (cat) {
                        controller.setSelectedCategory(cat?.id);
                        setState(() {});
                      },
                      onDelete: (cat) async {
                        await controller.deleteCategory(cat.id, context);
                        controller.setSelectedCategory(null);
                        if (context.mounted) {
                          context.pop();
                          HitagiToast.show(
                            context,
                            message: 'Categoria excluída com sucesso.',
                            type: ToastType.success,
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    LibraryContent(
                      filteredContent: filteredContent,
                      controller: controller,
                      itemsPerLine: controller.imagesPerLine,
                    ),
                  ],
                );
              },
            )
          : const MoveToLogin(title: 'Biblioteca'),
    );
  }
}
