import 'package:equatable/equatable.dart';
import '../../core/constants/enums.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String? name;
  final String? avatarUrl;
  final UserRole role;
  final bool isBanned;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const User({
    required this.id,
    required this.email,
    this.name,
    this.avatarUrl,
    this.role = UserRole.user,
    this.isBanned = false,
    required this.createdAt,
    this.updatedAt,
  });

  bool get isAdmin => role == UserRole.admin;
  bool get isAuthor => role == UserRole.author || role == UserRole.admin;

  User copyWith({
    String? id,
    String? email,
    String? name,
    String? avatarUrl,
    UserRole? role,
    bool? isBanned,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      role: role ?? this.role,
      isBanned: isBanned ?? this.isBanned,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [id, email, name, avatarUrl, role, isBanned, createdAt, updatedAt];
}
