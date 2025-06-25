import 'package:logger/logger.dart';

class Loggers extends Logger {
  static final Loggers _instance = Loggers._internal();

  factory Loggers() {
    return _instance;
  }

  static void fluxControl(Object method, String? operation) {
    return _instance
        .d('${operation ?? 'Acesso'} à: $method em: ${DateTime.now()}');
  }

  static void cache({bool isCache = true, String? operation}) {
    return isCache
        ? _instance.f('[CACHE] - $operation')
        : _instance.f('[INSERT CACHE] - $operation');
  }

  static void get(String operation) {
    return _instance.f('[GET] - $operation');
  }

  static void error(String operation) {
    return _instance.f('[ERROR] - $operation');
  }

  Loggers._internal();
}
