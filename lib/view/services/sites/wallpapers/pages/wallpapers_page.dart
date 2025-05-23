import 'package:flutter/material.dart';
import 'package:geekcontrol/core/library/hitagi_cup/features/images/hitagi_images.dart';
import 'package:geekcontrol/core/library/hitagi_cup/features/text/hitagi_text.dart';
import 'package:geekcontrol/core/routes/entities/wallpapers_route_entity.dart';
import 'package:geekcontrol/core/utils/global_variables.dart';
import 'package:geekcontrol/view/services/sites/wallpapers/atoms/copy_button.dart';
import 'package:geekcontrol/view/services/sites/wallpapers/pages/wallpapers_fullscreen_page.dart';
import 'package:geekcontrol/view/services/sites/wallpapers/controller/wallpapers_controller.dart';
import 'package:go_router/go_router.dart';

class WallpapersPage extends StatefulWidget {
  static const route = '/wallpapers';
  const WallpapersPage({super.key});

  @override
  State<WallpapersPage> createState() => _WallpapersPageState();
}

class _WallpapersPageState extends State<WallpapersPage> {
  final WallpaperController ct = di<WallpaperController>();
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
    final images = await ct.getWallpapers(_searchQuery);
    setState(() {
      _images = images;
      _isLoading = false;
    });
  }

  void _showSearchBottomSheet() {
    final TextEditingController searchController = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 24,
            right: 24,
            top: 32,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const HitagiText(
                text: 'Pesquisar wallpapers',
                typography: HitagiTypography.title,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: searchController,
                decoration: const InputDecoration(
                  hintText: 'Digite o termo de pesquisa...',
                  hintStyle: TextStyle(color: Colors.grey),
                  filled: true,
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.search),
                ),
                textInputAction: TextInputAction.search,
                onSubmitted: (value) {
                  final query = value.trim();
                  if (query.isNotEmpty) {
                    _searchQuery = query;
                    _fetchWallpapers();
                    Navigator.of(context).pop();
                  }
                },
              ),
              const SizedBox(height: 24),
              Align(
                child: ElevatedButton(
                  onPressed: () {
                    final query = searchController.text.trim();
                    if (query.isNotEmpty) {
                      _searchQuery = query;
                      _fetchWallpapers();
                    }
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Center(
                    child: const HitagiText(
                      text: 'Buscar',
                      typography: HitagiTypography.button,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: const HitagiText(
            text: 'Wallpapers',
            typography: HitagiTypography.title,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _showSearchBottomSheet,
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
                  onTap: () => GoRouter.of(context).push(
                    WallpaperFullscreen.route,
                    extra: WallpapersRouteEntity(images: _images, index: index)
                        .toMap(),
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
                          child: HitagiImages(image: _images[index]),
                        ),
                        Positioned(
                          bottom: 4,
                          right: 4,
                          child: Row(
                            children: [
                              CopyButton(image: _images[index]),
                              IconButton(
                                icon: const Icon(Icons.download, size: 20),
                                color: Colors.white,
                                onPressed: () =>
                                    ct.downloadWallpaper(_images[index]),
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
