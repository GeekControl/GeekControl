import 'package:geekcontrol/core/utils/global_variables.dart';
import 'package:geekcontrol/core/utils/module_factory.dart';
import 'package:geekcontrol/view/home/splash/splash_controller.dart';

class SplashModule implements Module {
  @override
  void register() {
    Globals().initializeLogger(runtimeType);
    di.registerFactory(() => SplashController());
  }
}
