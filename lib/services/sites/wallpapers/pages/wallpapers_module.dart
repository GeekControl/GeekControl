import 'package:geekcontrol/core/utils/global_variables.dart';
import 'package:geekcontrol/core/utils/module_factory.dart';
import 'package:geekcontrol/services/sites/wallpapers/controller/wallpapers_controller.dart';
import 'package:get_it/get_it.dart';

class WallpapersModule implements Module {
  @override
  void register() {
    Globals().initializeLogger(runtimeType);
    //Controller
    GetIt.instance.registerFactory(() => WallpaperController());
  }
}
