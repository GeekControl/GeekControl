// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geekcontrol/core/library/hitagi_cup/features/dialogs/hitagi_toast.dart';
import 'package:geekcontrol/core/utils/global_variables.dart';
import 'package:geekcontrol/core/utils/logger.dart';
import 'package:geekcontrol/view/services/cache/keys_enum.dart';
import 'package:geekcontrol/view/services/cache/local_cache.dart';
import 'package:geekcontrol/view/services/firebase/firebase.dart';
import 'package:go_router/go_router.dart';

class AuthController extends ChangeNotifier {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  FirebaseService get _firebase => di<FirebaseService>();
  final LocalCache _cache = di<LocalCache>();

  Future<void> registerUser({
    required String email,
    required String password,
    required String name,
    required BuildContext context,
  }) async {
    final hasError = await _validation();

    try {
      if (hasError == null) {
        final user = await _firebase.registerUser(
            email: email, password: password, name: name);
        if (user != null) {
          Globals.user = user;
          Globals.isLoggedIn = true;
          Globals.uid = user.id;

          HitagiToast.show(context,
              message: 'Cadastro realizado com sucesso.',
              type: ToastType.success);
          GoRouter.of(context).go('/');
        }
      } else {
        HitagiToast.show(context,
            message: hasError.toString(), type: ToastType.error);
      }
    } catch (e) {
      if (e is FirebaseAuthException) {
        Loggers.error('Erro ao registrar o usuário: $e');
        HitagiToast.show(context,
            message: e.message ?? 'Erro no cadastro.', type: ToastType.error);
      }
    }
  }

  Future<void> loginUser(
      {required String email,
      required String password,
      required BuildContext context}) async {
    try {
      final hasError = await _validation(isLogin: true);
      if (hasError == null) {
        await _firebase.signIn(email: email, password: password);
        HitagiToast.show(context,
            message: 'Login realizado com sucesso.', type: ToastType.success);
        GoRouter.of(context).go('/');
      } else {
        HitagiToast.show(context,
            message: hasError.toString(), type: ToastType.error);
      }
    } catch (e) {
      if (e is FirebaseAuthException) {
        Loggers.error('Erro ao entrar com email e senha: $e');
        HitagiToast.show(context, message: e.message!, type: ToastType.error);
      }
    }
  }

  Future<Exception?> _validation({bool isLogin = false}) async {
    final name = nameController.text;
    final email = emailController.text;
    final password = passwordController.text;

    if ((!isLogin && name.isEmpty) || email.isEmpty || password.isEmpty) {
      return Exception('Preencha todos os campos');
    }
    if (password.length < 6) {
      return Exception('Senha deve ter no mínimo 6 caracteres');
    }
    if (!_isValidEmail()) {
      return Exception('E-mail inválido');
    }
    return null;
  }

  Future<void> setAnonymousMode() async {
    await _cache.put(CacheKeys.anonymousMode, true);
  }

  bool _isValidEmail() {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(emailController.text);
  }
}
