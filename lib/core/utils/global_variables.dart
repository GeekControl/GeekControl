import 'package:flutter/material.dart';
import 'package:geekcontrol/view/services/profile/model/user_entity.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

GetIt di = GetIt.instance;

class Globals extends ChangeNotifier {
  static UserEntity? user;
  static String? uid;
  static bool isLoggedIn = false;
  void initializeLogger(Type caller) {
    Logger().t('Inicializando [$caller]...');
  }
}
