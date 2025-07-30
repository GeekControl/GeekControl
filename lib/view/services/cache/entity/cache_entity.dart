import 'package:geekcontrol/view/services/cache/keys_enum.dart';

class CacheEntity {
  final CacheKeys key;
  final dynamic data;

  CacheEntity({
    required this.data,
    required this.key,
  });

  Map<String, dynamic> toJson() {
    return {
      'updatedAt': DateTime.now().toIso8601String(),
      'data': data,
      'key': key.value,
    };
  }
}
