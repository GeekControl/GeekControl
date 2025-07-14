import 'package:flutter/material.dart';
import 'package:geekcontrol/core/library/hitagi_cup/features/images/hitagi_images.dart';
import 'package:geekcontrol/core/library/hitagi_cup/features/text/hitagi_text.dart';
import 'package:geekcontrol/core/library/page_builder/hitagi_page.dart';
import 'package:geekcontrol/core/routes/entities/wallpapers_route_entity.dart';
import 'package:geekcontrol/core/utils/global_variables.dart';
import 'package:geekcontrol/view/services/sites/wallpapers/atoms/copy_button.dart';
import 'package:geekcontrol/view/services/sites/wallpapers/controller/wallpapers_controller.dart';
import 'package:geekcontrol/view/services/sites/wallpapers/pages/components/search_wallpapers.dart';
import 'package:geekcontrol/view/services/sites/wallpapers/pages/wallpapers_fullscreen_page.dart';
import 'package:go_router/go_router.dart';

class WallpapersPage extends HitagiPage<WallpaperController> {
  static const route = '/wallpapers';
  const WallpapersPage({super.key});

  @override
  WallpaperController createController() => di<WallpaperController>();

  @override
  Widget buildLoading(BuildContext context, WallpaperController controller) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }

  @override
  Widget build(BuildContext context, WallpaperController ct) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: HitagiText(
            text: 'Wallpapers',
            typography: HitagiTypography.title,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => SearchWallpapers().showSearchBottomSheet(
              context,
              (query) => ct.getWallpapers(ct.searchQuery = query),
            ),
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 0.7,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: ct.images.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => GoRouter.of(context).push(
              WallpaperFullscreen.route,
              extra: WallpapersRouteEntity(
                images: ct.images,
                index: index,
              ).toMap(),
            ),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: HitagiImages(image: ct.images[index]),
                  ),
                  Positioned(
                    bottom: 4,
                    right: 4,
                    child: Row(
                      children: [
                        CopyButton(image: ct.images[index]),
                        IconButton(
                          icon: const Icon(Icons.download, size: 20),
                          color: Colors.white,
                          onPressed: () =>
                              ct.downloadWallpaper(ct.images[index]),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
