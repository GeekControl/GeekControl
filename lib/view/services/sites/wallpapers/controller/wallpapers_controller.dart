import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geekcontrol/core/library/page_builder/hitagi_page.dart';
import 'package:geekcontrol/view/services/sites/wallpapers/webscrap/alphacoders_webscrap.dart';
import 'package:geekcontrol/view/services/sites/wallpapers/webscrap/wallpapersflare_webscrap.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:saver_gallery/saver_gallery.dart';

class WallpaperController extends HitagiController {
  final List<String> images = [];
  PageController? _pageController;
  PageController get pageController => _pageController ??= PageController();
  final alphacoders = AlphacodersWebscrap();
  final wallpaperFlare = WallpapersflareWebscrap();
  String? searchQuery;
  int currentPage = 1;
  bool isLoadingMore = false;
  bool hasMore = true;
  bool firstTime = true;

  final ScrollController scrollController = ScrollController();

  @override
  Future<void> init({param}) async {
    final params = param is Map ? param : <String, dynamic>{};
    setFullScreen(enabled: params['isFullScreen'] ?? false);
    _pageController?.dispose();
    _pageController = PageController(initialPage: params['initialPage'] ?? 0);
    images.clear();
    currentPage = 1;
    hasMore = true;
    if (firstTime) {
      setState(ControllerState.loading);
      await getWallpapers(searchQuery, reset: true);
      setState(ControllerState.success);
      firstTime = false;
    } else {
      await getWallpapers(searchQuery, reset: true);
    }
    notifyListeners();
  }

  Future<List<String>> getWallpapers(String? query,
      {bool reset = false}) async {
    if (isLoadingMore || !hasMore) return images;
    isLoadingMore = true;
    if (reset) {
      currentPage = 1;
      hasMore = true;
      images.clear();
    }
    final fetchedImages =
        await alphacoders.get(query: query, page: currentPage);
    isLoadingMore = false;
    if (fetchedImages.isNotEmpty) {
      images.addAll(fetchedImages);
      currentPage++;
    } else {
      hasMore = false;
    }
    notifyListeners();
    return images;
  }

  Future<void> downloadWallpaper(String uri) async {
    try {
      if (!Platform.isAndroid) return;
      final deviceInfo = await DeviceInfoPlugin().androidInfo;
      final sdkInt = deviceInfo.version.sdkInt;
      bool permissionGranted;
      if (sdkInt >= 33) {
        permissionGranted = await Permission.photos.request().isGranted;
      } else {
        permissionGranted = await Permission.storage.request().isGranted;
      }
      if (!permissionGranted) {
        Logger().e('Storage permission denied');
        return;
      }
      final url = Uri.parse(uri);
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final name = url.pathSegments.last;
        final result = await SaverGallery.saveImage(
          response.bodyBytes,
          fileName: name,
          skipIfExists: false,
        );
        Logger().i('Wallpaper saved to gallery: $result');
      } else {
        Logger().e('Failed to download wallpaper: ${response.statusCode}');
      }
    } catch (e) {
      Logger().e('Error saving wallpaper: $e');
    }
  }

  Future<void> setFullScreen({bool enabled = true}) async {
    enabled
        ? await SystemChrome.setEnabledSystemUIMode(
            SystemUiMode.immersiveSticky)
        : SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    notifyListeners();
  }
}
