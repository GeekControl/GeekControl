class UserEntity {
  final String id;
  final String name;
  final String email;
  final String? cover;
  final String? bio;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.cover,
    this.bio,
  });

  factory UserEntity.fromJson(Map<String, dynamic> json) {
    return UserEntity(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      cover: json['cover'] as String?,
      bio: json['bio'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'cover': cover,
      'bio': bio,
    };
  }

  @override
  String toString() {
    return 'UserEntity(id: $id, name: $name, email: $email, cover: $cover, bio: $bio)';
  }

  static empty() {
    return UserEntity(
      id: '',
      name: '',
      email: '',
      cover: '',
      bio: '',
    );
  }
}
