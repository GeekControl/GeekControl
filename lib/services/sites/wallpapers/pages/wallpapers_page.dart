import 'package:flutter/material.dart';
import 'package:geekcontrol/core/library/hitagi_cup/features/images/hitagi_images.dart';
import 'package:geekcontrol/core/library/hitagi_cup/features/text/hitagi_text.dart';
import 'package:geekcontrol/services/sites/wallpapers/atoms/copy_button.dart';
import 'package:geekcontrol/services/sites/wallpapers/pages/wallpapers_fullscreen_page.dart';
import 'package:geekcontrol/services/sites/wallpapers/controller/wallpapers_controller.dart';
import 'package:go_router/go_router.dart';

class WallpapersPage extends StatefulWidget {
  static const route = '/wallpapers';
  const WallpapersPage({super.key});

  @override
  State<WallpapersPage> createState() => _WallpapersPageState();
}

class _WallpapersPageState extends State<WallpapersPage> {
  final WallpaperController _controller = WallpaperController();
  List<String> _images = [];
  String _searchQuery = 'anime';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchWallpapers();
  }

  Future<void> _fetchWallpapers() async {
    setState(() => _isLoading = true);
    final images = await _controller.getWallpapers(_searchQuery);
    setState(() {
      _images = images;
      _isLoading = false;
    });
  }

  void _showSearchPopup() {
    showDialog(
      context: context,
      builder: (context) {
        final TextEditingController searchController = TextEditingController();
        return AlertDialog(
          title: const HitagiText(
            text: 'Pesquisar Wallpapers',
            typography: HitagiTypography.title,
          ),
          content: TextField(
            controller: searchController,
            decoration: const InputDecoration(hintText: 'Digite o tema...'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const HitagiText(
                text: 'Cancelar',
                typography: HitagiTypography.button,
              ),
            ),
            TextButton(
              onPressed: () {
                final query = searchController.text.trim();
                if (query.isNotEmpty) {
                  _searchQuery = query;
                  _fetchWallpapers();
                }
                Navigator.of(context).pop();
              },
              child: const HitagiText(
                text: 'Pesquisar',
                typography: HitagiTypography.button,
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wallpapers'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _showSearchPopup,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 0.7,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: _images.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => GoRouter.of(context)
                      .push(WallpaperFullscreen.route, extra: {
                    'images': _images,
                    'index': index,
                  }),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: HitagiImages(image: _images[index]),
                        ),
                        Positioned(
                          bottom: 4,
                          right: 4,
                          child: Row(
                            children: [
                              CoppyButton(image: _images[index]),
                              IconButton(
                                icon: const Icon(Icons.download, size: 20),
                                color: Colors.white,
                                onPressed: () => _controller
                                    .downloadWallpaper(_images[index]),
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
