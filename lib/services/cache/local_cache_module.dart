import 'package:geekcontrol/core/utils/global_variables.dart';
import 'package:geekcontrol/core/utils/module_factory.dart';
import 'package:geekcontrol/services/cache/local_cache.dart';

class LocalCacheModule implements Module {
  @override
  void register() {
    Globals().initializeLogger(runtimeType);
    di.registerLazySingleton<LocalCache>(() => LocalCache());
  }
}
