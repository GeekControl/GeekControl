import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:http/http.dart' as http;
import 'package:geekcontrol/services/sites/utils_scrap.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:saver_gallery/saver_gallery.dart';

class WallpaperController {
  Future<List<String>> getWallpapers(String search) async {
    final doc = await Scraper()
        .document('https://www.uhdpaper.com/search?q=Anime&by-date=true');

    final img =
        Scraper.docSelecAllAttr(doc, '.post-outer-container img', 'src');
    final flare = await _wallpaperFlare(search);
    return [...flare, ...img];
  }

  Future<List<String>> _wallpaperFlare(String search) async {
    final doc = await Scraper().document(
        'https://www.wallpaperflare.com/search?wallpaper=$search&mobile=ok');

    final img = Scraper.docSelecAllAttr(doc, '.lazy', 'data-src');

    if (!img.contains('N/A')) {
      return img;
    }
    return img;
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
}
