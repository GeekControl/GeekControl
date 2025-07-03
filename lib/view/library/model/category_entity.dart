class CategoryEntity {
  final String id;
  final String name;
  final String colorHex;
  final bool editable;

  CategoryEntity({
    required this.id,
    required this.name,
    required this.colorHex,
    required this.editable, 
  });

  factory CategoryEntity.fromJson(Map<String, dynamic> json) {
    return CategoryEntity(
      id: json['id'],
      name: json['name'],
      colorHex: json['color'],
      editable: json['editable'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'color': colorHex,
      'editable': editable,
    };
  }
}
