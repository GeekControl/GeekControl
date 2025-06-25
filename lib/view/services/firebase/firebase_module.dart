import 'package:geekcontrol/core/utils/global_variables.dart';
import 'package:geekcontrol/core/utils/module_factory.dart';
import 'package:geekcontrol/view/services/firebase/firebase.dart';
import 'package:geekcontrol/view/services/firebase/firebase_auth.dart';

class FirebaseModule implements Module {
  @override
  void register() {
    Globals().initializeLogger(runtimeType);
    di.registerFactory(() => FirebaseService());
    di.registerFactory(() => FirebaseAuthService());
  }
}
