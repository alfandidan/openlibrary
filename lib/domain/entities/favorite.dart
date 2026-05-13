import 'package:equatable/equatable.dart';

class Favorite extends Equatable {
  final String id;
  final String userId;
  final String bookId;
  final DateTime createdAt;

  const Favorite({
    required this.id,
    required this.userId,
    required this.bookId,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, userId, bookId, createdAt];
}
