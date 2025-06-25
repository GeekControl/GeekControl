import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:geekcontrol/core/library/hitagi_cup/features/dialogs/hitagi_toast.dart';
import 'package:geekcontrol/core/utils/global_variables.dart';
import 'package:geekcontrol/core/utils/logger.dart';
import 'package:geekcontrol/view/services/profile/model/user_entity.dart';

class FirebaseAuthService {
  FirebaseAuth get _firebase => FirebaseAuth.instance;

  Future<void> signOut(BuildContext context) async {
    try {
      await _firebase.signOut();
      Globals.user = null;
      Globals.isLoggedIn = false;
      Globals.uid = null;
      Loggers.get('Usuário deslogou. ID: ${Globals.uid}');
      if (context.mounted) {
        HitagiToast.show(
          context,
          message: 'Logout realizado com sucesso.',
          type: ToastType.success,
        );
      }
    } catch (e) {
      Loggers.error('Erro ao deslogar: $e');
      if (context.mounted) {
        HitagiToast.show(
          context,
          message: 'Erro ao deslogar. $e',
          type: ToastType.error,
        );
      }
      rethrow;
    }
  }

  Future<UserEntity?> createUser({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final credential = await _firebase.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await credential.user?.updateDisplayName(name);
      await credential.user?.reload();

      final user = credential.user;
      if (user == null) return null;

      return UserEntity(
        id: user.uid,
        name: user.displayName ?? '',
        email: user.email ?? '',
        cover: user.photoURL,
      );
    } catch (e) {
      Loggers.error('Erro ao criar usuário: $e');
      rethrow;
    }
  }

  Future<UserEntity?> _getUser() async {
    try {
      User? user = _firebase.currentUser;

      if (user == null) {
        try {
          final guestUser = await _firebase.signInAnonymously();
          user = guestUser.user;
          Loggers.get('Usuário anônimo autenticado. ID: ${user?.uid}');
        } catch (e) {
          Loggers.error('Erro ao autenticar como usuário anônimo: $e');
          return null;
        }
      }

      if (user == null) return null;

      return UserEntity(
        id: user.uid,
        name: user.displayName ?? '',
        email: user.email!,
        cover: user.photoURL,
      );
    } catch (e) {
      return null;
    }
  }

  Future<void> userIsLoggedIn() async {
    final UserEntity? user = await _getUser();
    if (user != null) {
      Globals.user = user;
      Globals.isLoggedIn = true;
      Globals.uid = user.id;
      Loggers.get('Usuário autenticado. ID: ${Globals.uid}');
    }
  }

  Future<void> waitForAuthReady() async {
    final completer = Completer<void>();
    late final StreamSubscription<User?> sub;

    sub = FirebaseAuth.instance.authStateChanges().listen((_) {
      completer.complete();
      sub.cancel();
    });

    await completer.future.timeout(const Duration(seconds: 5));
  }

  Future<void> deleteUser() async {}

  Future<void> updateUser() async {}
}
