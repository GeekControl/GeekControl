import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geekcontrol/core/utils/api_utils.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:saver_gallery/saver_gallery.dart';
import 'package:scraper/scraper.dart';

class WallpaperController extends ChangeNotifier {
  final _scraper = Scraper();

  Future<void> init() async {}

  Future<List<String>> getWallpapers(String search) async {
    final doc = await _scraper.getDocument(url: WallpapersUtils.uri);

    final img = _scraper.querySelectAllAttr(
      doc: doc,
      query: '.post-outer-container img',
      attr: 'src',
    );
    if (img == null || img.isEmpty) return [];
    final flare = await _wallpaperFlare(search);
    return [...flare, ...img.whereType<String>()];
  }

  Future<List<String>> _wallpaperFlare(String search) async {
    final doc = await _scraper.getDocument(
      url: '${WallpapersUtils.wallpaperFlare}$search&mobile=ok',
    );

    final img = _scraper.querySelectAllAttr(
      doc: doc,
      query: '.lazy',
      attr: 'data-src',
    );

    if (img == null || img.isEmpty) return [];

    if (!img.contains('N/A')) {
      return img.whereType<String>().toList();
    }
    return img.whereType<String>().toList();
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

  Future<void> _setFullScreen() async {
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }
}
