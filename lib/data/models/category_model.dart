import '../../domain/entities/category.dart';

class CategoryModel extends Category {
  const CategoryModel({
    required super.id,
    required super.name,
    super.description,
    super.iconUrl,
    super.bookCount,
    required super.createdAt,
    super.updatedAt,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      iconUrl: json['icon_url'] as String?,
      bookCount: json['book_count'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'icon_url': iconUrl,
      'book_count': bookCount,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  factory CategoryModel.fromEntity(Category category) {
    return CategoryModel(
      id: category.id,
      name: category.name,
      description: category.description,
      iconUrl: category.iconUrl,
      bookCount: category.bookCount,
      createdAt: category.createdAt,
      updatedAt: category.updatedAt,
    );
  }
}
