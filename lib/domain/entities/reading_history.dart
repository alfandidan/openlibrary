import 'package:equatable/equatable.dart';

class ReadingHistory extends Equatable {
  final String id;
  final String userId;
  final String bookId;
  final int lastPage;
  final int progress; // 0-100
  final DateTime updatedAt;

  const ReadingHistory({
    required this.id,
    required this.userId,
    required this.bookId,
    required this.lastPage,
    required this.progress,
    required this.updatedAt,
  });

  ReadingHistory copyWith({
    String? id,
    String? userId,
    String? bookId,
    int? lastPage,
    int? progress,
    DateTime? updatedAt,
  }) {
    return ReadingHistory(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      bookId: bookId ?? this.bookId,
      lastPage: lastPage ?? this.lastPage,
      progress: progress ?? this.progress,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [id, userId, bookId, lastPage, progress, updatedAt];
}
