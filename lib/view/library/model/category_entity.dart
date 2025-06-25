class CategoryEntity {
  final String id;
  final String name;
  final String colorHex;

  CategoryEntity({
    required this.id,
    required this.name,
    required this.colorHex,
  });

  factory CategoryEntity.fromJson(Map<String, dynamic> json) {
    return CategoryEntity(
      id: json['id'],
      name: json['name'],
      colorHex: json['color'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'color': colorHex,
    };
  }
}
