import 'package:flutter/material.dart';
import 'package:geekcontrol/core/utils/global_variables.dart';
import 'package:geekcontrol/view/services/cache/keys_enum.dart';
import 'package:geekcontrol/view/services/cache/local_cache.dart';
import 'package:geekcontrol/view/services/firebase/firebase_auth.dart';

class SplashController extends ChangeNotifier {
  final auth = di<FirebaseAuthService>();
  final cache = di<LocalCache>();

  String currentStep = 'Inicializando...';

  Future<String> resolveInitialRoute() async {
    _update('Carregando preferências...');
    Globals.translateReviews =
        await cache.getUserPreference<bool>('translateReviews') ?? true;

    _update('Verificando autenticação...');
    await auth.waitForAuthReady();
    final isLogged = await auth.userIsLoggedIn();
    final anonymous = await cache.get(CacheKeys.anonymousMode) != null;

    _update('Finalizando...');
    await Future.delayed(const Duration(milliseconds: 300));

    return isLogged || anonymous ? '/' : '/login';
  }

  void _update(String step) {
    currentStep = step;
    notifyListeners();
  }
}
