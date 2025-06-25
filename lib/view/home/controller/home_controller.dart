import 'package:flutter/material.dart';
import 'package:geekcontrol/core/utils/global_variables.dart';
import 'package:geekcontrol/view/auth/ui/login_page.dart';
import 'package:geekcontrol/view/services/cache/keys_enum.dart';
import 'package:geekcontrol/view/services/firebase/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:geekcontrol/view/services/cache/local_cache.dart';

class HomeController extends ChangeNotifier {
  final LocalCache _cache = di<LocalCache>();

  Future<void> init(BuildContext context) async {
    final anonymousMode = await _cache.get(CacheKeys.anonymousMode);
    final auth = di<FirebaseAuthService>();
    await auth.waitForAuthReady();
    await auth.userIsLoggedIn();
    if (!Globals.isLoggedIn && anonymousMode == null) {
      if (context.mounted) {
        GoRouter.of(context).go(LoginPage.route);
      }
    }
    notifyListeners();
  }
}
