import 'package:geekcontrol/core/utils/global_variables.dart';
import 'package:geekcontrol/core/utils/module_factory.dart';

class CoreModule implements Module {
  @override
  void register() {
    Globals().initializeLogger(runtimeType);
    di.registerSingleton<Globals>(Globals());
  }
}
