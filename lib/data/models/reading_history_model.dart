import '../../domain/entities/reading_history.dart';

class ReadingHistoryModel extends ReadingHistory {
  const ReadingHistoryModel({
    required super.id,
    required super.userId,
    required super.bookId,
    required super.lastPage,
    required super.progress,
    required super.updatedAt,
  });

  factory ReadingHistoryModel.fromJson(Map<String, dynamic> json) {
    return ReadingHistoryModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      bookId: json['book_id'] as String,
      lastPage: json['last_page'] as int,
      progress: json['progress'] as int,
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'book_id': bookId,
      'last_page': lastPage,
      'progress': progress,
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory ReadingHistoryModel.fromEntity(ReadingHistory history) {
    return ReadingHistoryModel(
      id: history.id,
      userId: history.userId,
      bookId: history.bookId,
      lastPage: history.lastPage,
      progress: history.progress,
      updatedAt: history.updatedAt,
    );
  }
}
