import 'package:geekcontrol/core/utils/global_variables.dart';
import 'package:geekcontrol/core/utils/module_factory.dart';
import 'package:geekcontrol/services/anilist/controller/anilist_controller.dart';

class AnilistModules implements Module {
  @override
  void register() {
    Globals().initializeLogger(runtimeType);
    //Controllers
    di.registerFactory(() => AnilistController());
  }
}
