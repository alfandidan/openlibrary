import '../../core/constants/enums.dart';
import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.email,
    super.name,
    super.avatarUrl,
    super.role,
    super.isBanned,
    required super.createdAt,
    super.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      role: _parseRole(json['role'] as String?),
      isBanned: json['is_banned'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'avatar_url': avatarUrl,
      'role': role.name,
      'is_banned': isBanned,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  static UserRole _parseRole(String? role) {
    switch (role) {
      case 'admin':
        return UserRole.admin;
      case 'author':
        return UserRole.author;
      default:
        return UserRole.user;
    }
  }

  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      email: user.email,
      name: user.name,
      avatarUrl: user.avatarUrl,
      role: user.role,
      isBanned: user.isBanned,
      createdAt: user.createdAt,
      updatedAt: user.updatedAt,
    );
  }
}
