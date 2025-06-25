import 'package:geekcontrol/core/utils/global_variables.dart';
import 'package:geekcontrol/core/utils/module_factory.dart';
import 'package:geekcontrol/view/library/controllers/library_controller.dart';

class LibraryModule implements Module {
  @override
  void register() {
    Globals().initializeLogger(runtimeType);
    di.registerFactory(() => LibraryController());
  }
}
