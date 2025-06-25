import 'package:geekcontrol/view/animes/articles/controller/articles_controller.dart';
import 'package:geekcontrol/core/utils/global_variables.dart';
import 'package:geekcontrol/core/utils/module_factory.dart';

class ArticlesModule implements Module {
  @override
  void register() {
    Globals().initializeLogger(runtimeType);
    di.registerFactory(() => ArticlesController());
  }
}
