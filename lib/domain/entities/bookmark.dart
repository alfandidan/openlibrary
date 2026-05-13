import 'package:equatable/equatable.dart';

class Bookmark extends Equatable {
  final String id;
  final String userId;
  final String bookId;
  final int pageNumber;
  final String? note;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const Bookmark({
    required this.id,
    required this.userId,
    required this.bookId,
    required this.pageNumber,
    this.note,
    required this.createdAt,
    this.updatedAt,
  });

  Bookmark copyWith({
    String? id,
    String? userId,
    String? bookId,
    int? pageNumber,
    String? note,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Bookmark(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      bookId: bookId ?? this.bookId,
      pageNumber: pageNumber ?? this.pageNumber,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [id, userId, bookId, pageNumber, note, createdAt, updatedAt];
}
