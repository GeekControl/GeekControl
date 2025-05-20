import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

GetIt di = GetIt.instance;

class Globals extends ChangeNotifier {
  void initializeLogger(Type caller) {
    Logger().t('Inicializando [$caller]...');
  }
}
