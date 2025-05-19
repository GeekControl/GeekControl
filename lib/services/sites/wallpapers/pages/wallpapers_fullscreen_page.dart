import 'package:flutter/material.dart';
import 'package:geekcontrol/core/library/hitagi_cup/features/dialogs/hitagi_toast.dart';
import 'package:geekcontrol/core/library/hitagi_cup/features/images/hitagi_images.dart';
import 'package:geekcontrol/services/sites/wallpapers/atoms/copy_button.dart';
import 'package:geekcontrol/services/sites/wallpapers/controller/wallpapers_controller.dart';
import 'package:logger/web.dart';

class WallpaperFullscreen extends StatefulWidget {
  static const route = '/wallpaper-fullscreen';
  final List<String> images;
  final int index;

  const WallpaperFullscreen({
    super.key,
    required this.images,
    required this.index,
  });

  @override
  State<WallpaperFullscreen> createState() => _WallpaperFullscreenState();
}

class _WallpaperFullscreenState extends State<WallpaperFullscreen> {
  bool fullscreen = false;
  late final PageController _pageController;
  final ct = WallpaperController();

  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.index);
    currentIndex = widget.index;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            scrollDirection: Axis.vertical,
            itemCount: widget.images.length,
            onPageChanged: (index) {
              setState(() {
                currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              final imageUrl = widget.images[currentIndex];
              return GestureDetector(
                onLongPress: () => setState(() => fullscreen = false),
                onTap: () => setState(() => fullscreen = true),
                child: HitagiImages(
                  image: imageUrl,
                  fit: BoxFit.cover,
                ),
              );
            },
          ),
          if (!fullscreen)
            Positioned(
              top: 40,
              left: 16,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ),
          if (!fullscreen)
            Positioned(
              left: 0,
              right: 0,
              bottom: 32,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Builder(
                    builder: (context) {
                      final currentIndex = _pageController.hasClients
                          ? _pageController.page?.round() ?? 0
                          : widget.index;
                      final imageUrl = widget.images[currentIndex];
                      return Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(width: 16),
                            CopyButton(image: imageUrl),
                            const SizedBox(width: 16),
                            IconButton(
                              icon: const Icon(Icons.download,
                                  color: Colors.white),
                              onPressed: () {
                                try {
                                  ct.downloadWallpaper(imageUrl);
                                  HitagiToast.show(
                                    context,
                                    message: 'Wallpaper baixado com sucesso!',
                                    type: ToastType.success,
                                  );
                                } catch (e) {
                                  Logger().e('Error downloading wallpaper: $e');
                                  HitagiToast.show(
                                    context,
                                    message: 'Erro ao baixar o wallpaper: $e',
                                    type: ToastType.error,
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
