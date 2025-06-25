import 'package:geekcontrol/core/utils/global_variables.dart';
import 'package:geekcontrol/core/utils/module_factory.dart';
import 'package:geekcontrol/view/auth/controllers/auth_controller.dart';

class AuthModule implements Module {
  @override
  void register() {
    Globals().initializeLogger(runtimeType);
    di.registerFactory(() => AuthController());
  }
}
