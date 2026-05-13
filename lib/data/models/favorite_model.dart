import '../../domain/entities/favorite.dart';

class FavoriteModel extends Favorite {
  const FavoriteModel({
    required super.id,
    required super.userId,
    required super.bookId,
    required super.createdAt,
  });

  factory FavoriteModel.fromJson(Map<String, dynamic> json) {
    return FavoriteModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      bookId: json['book_id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'book_id': bookId,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory FavoriteModel.fromEntity(Favorite favorite) {
    return FavoriteModel(
      id: favorite.id,
      userId: favorite.userId,
      bookId: favorite.bookId,
      createdAt: favorite.createdAt,
    );
  }
}
