import 'package:geekcontrol/view/home/controller/home_controller.dart';

import 'package:geekcontrol/core/utils/module_factory.dart';
import 'package:geekcontrol/core/utils/global_variables.dart';

class HomeModule implements Module {
  @override
  void register() {
    Globals().initializeLogger(runtimeType);
    //Controllers
    di.registerFactory(() => HomeController());
  }
}
