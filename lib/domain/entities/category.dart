import 'package:equatable/equatable.dart';

class Category extends Equatable {
  final String id;
  final String name;
  final String? description;
  final String? iconUrl;
  final int bookCount;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const Category({
    required this.id,
    required this.name,
    this.description,
    this.iconUrl,
    this.bookCount = 0,
    required this.createdAt,
    this.updatedAt,
  });

  Category copyWith({
    String? id,
    String? name,
    String? description,
    String? iconUrl,
    int? bookCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      iconUrl: iconUrl ?? this.iconUrl,
      bookCount: bookCount ?? this.bookCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [id, name, description, iconUrl, bookCount, createdAt, updatedAt];
}
