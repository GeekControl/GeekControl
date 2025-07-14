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

  late final PageController pageController;

  final alphacoders = AlphacodersWebscrap();
  final wallpaperFlare = WallpapersflareWebscrap();

  String? searchQuery;

  @override
  Future<void> init({param}) async {
    final Map<String, dynamic> params = {
      'isFullScreen': true,
      'initialPage': 0,
    };
    setFullScreen(enabled: params['isFullScreen']);
    pageController = PageController(initialPage: params['initialPage']);
    images.clear();
    images.addAll(await getWallpapers(searchQuery));
    notifyListeners();
  }

  Future<List<String>> getWallpapers(String? query) async {
    final fetchedImages = await handleTry<List<String>>(() async {
      final result = await alphacoders.get(query: query);
      return result;
    });

    if (fetchedImages != null) {
      images
        ..clear()
        ..addAll(fetchedImages);
      notifyListeners();
    }

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
