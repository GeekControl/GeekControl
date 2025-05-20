import 'package:geekcontrol/animes/articles/controller/articles_controller.dart';
import 'package:geekcontrol/core/utils/global_variables.dart';
import 'package:geekcontrol/core/utils/module_factory.dart';
import 'package:get_it/get_it.dart';

class ArticlesModule implements Module {
  @override
  void register() {
    Globals().initializeLogger(runtimeType);
    GetIt.instance.registerFactory(() => ArticlesController());
  }
}
