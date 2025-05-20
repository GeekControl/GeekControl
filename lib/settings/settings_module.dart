import 'package:geekcontrol/core/utils/global_variables.dart';
import 'package:geekcontrol/core/utils/module_factory.dart';
import 'package:geekcontrol/settings/controller/settings_controller.dart';

class SettingsModule implements Module {
  @override
  void register() {
    Globals().initializeLogger(runtimeType);
    di.registerFactory(() => SettingsController());
  }
}
