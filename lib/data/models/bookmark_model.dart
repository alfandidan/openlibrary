import '../../domain/entities/bookmark.dart';

class BookmarkModel extends Bookmark {
  const BookmarkModel({
    required super.id,
    required super.userId,
    required super.bookId,
    required super.pageNumber,
    super.note,
    required super.createdAt,
    super.updatedAt,
  });

  factory BookmarkModel.fromJson(Map<String, dynamic> json) {
    return BookmarkModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      bookId: json['book_id'] as String,
      pageNumber: json['page_number'] as int,
      note: json['note'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'book_id': bookId,
      'page_number': pageNumber,
      'note': note,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  factory BookmarkModel.fromEntity(Bookmark bookmark) {
    return BookmarkModel(
      id: bookmark.id,
      userId: bookmark.userId,
      bookId: bookmark.bookId,
      pageNumber: bookmark.pageNumber,
      note: bookmark.note,
      createdAt: bookmark.createdAt,
      updatedAt: bookmark.updatedAt,
    );
  }
}
