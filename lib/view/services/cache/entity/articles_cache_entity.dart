class ArticlesCacheEntity {
  final DateTime createAt;
  final DateTime updateAt;
  final bool read;
  final String key;
  final String value;
  final int quantity;

  ArticlesCacheEntity({
    required this.createAt,
    required this.updateAt,
    required this.read,
    required this.key,
    required this.value,
    required this.quantity,
  });

  Map<String, dynamic> toMap() {
    return {
      'createAt': createAt.toIso8601String(),
      'updateAt': updateAt.toIso8601String(),
      'read': read,
      'key': key,
      'value': value,
      'quantity': quantity,
    };
  }
}
