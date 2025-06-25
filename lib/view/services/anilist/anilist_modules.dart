import 'package:geekcontrol/core/utils/global_variables.dart';
import 'package:geekcontrol/core/utils/module_factory.dart';
import 'package:geekcontrol/view/services/anilist/controller/anilist_controller.dart';
import 'package:geekcontrol/view/services/anilist/repository/anilist_repository.dart';

class AnilistModules implements Module {
  @override
  void register() {
    Globals().initializeLogger(runtimeType);
    //Controllers
    di.registerFactory(() => AnilistController());
    //Repositories
    di.registerFactory(() => AnilistRepository());
  }
}
