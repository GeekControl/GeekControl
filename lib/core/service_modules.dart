import 'package:geekcontrol/view/animes/articles/pages/articles_module.dart';
import 'package:geekcontrol/core/core_module.dart';
import 'package:geekcontrol/core/utils/module_factory.dart';
import 'package:geekcontrol/view/home/pages/home_module.dart';
import 'package:geekcontrol/view/services/anilist/anilist_modules.dart';
import 'package:geekcontrol/view/services/cache/local_cache_module.dart';
import 'package:geekcontrol/view/services/sites/wallpapers/pages/wallpapers_module.dart';
import 'package:geekcontrol/view/settings/settings_module.dart';

class ServiceModules {
  factory ServiceModules() => _singleton;
  static final ServiceModules _singleton = ServiceModules._internal();
  ServiceModules._internal();

  static ServiceModules get of => ServiceModules();

  final List<Module> _modules = [
    LocalCacheModule(),
    CoreModule(),
    HomeModule(),
    SettingsModule(),
    WallpapersModule(),
    ArticlesModule(),
    AnilistModules(),
  ];

  Future<void> initialize() async {
    for (final module in _modules) {
      module.register();
    }
  }
}
