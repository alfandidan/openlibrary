import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/book.dart';
import '../entities/bookmark.dart';
import '../entities/favorite.dart';
import '../entities/reading_history.dart';

abstract class LibraryRepository {
  // Favorites
  /// Add book to favorites
  Future<Either<Failure, Favorite>> addToFavorites(String bookId);

  /// Remove book from favorites
  Future<Either<Failure, void>> removeFromFavorites(String bookId);

  /// Get user's favorite books
  Future<Either<Failure, List<Book>>> getFavoriteBooks({
    int page = 1,
    int limit = 20,
  });

  /// Check if book is favorited
  Future<Either<Failure, bool>> isFavorite(String bookId);

  // Bookmarks
  /// Create a bookmark
  Future<Either<Failure, Bookmark>> createBookmark({
    required String bookId,
    required int pageNumber,
    String? note,
  });

  /// Delete a bookmark
  Future<Either<Failure, void>> deleteBookmark(String bookmarkId);

  /// Get bookmarks for a book
  Future<Either<Failure, List<Bookmark>>> getBookBookmarks(String bookId);

  /// Get all user bookmarks
  Future<Either<Failure, List<Bookmark>>> getAllBookmarks({
    int page = 1,
    int limit = 20,
  });

  // Reading History
  /// Save reading progress
  Future<Either<Failure, ReadingHistory>> saveReadingProgress({
    required String bookId,
    required int lastPage,
    required int progress,
  });

  /// Get reading progress for a book
  Future<Either<Failure, ReadingHistory?>> getReadingProgress(String bookId);

  /// Get reading history
  Future<Either<Failure, List<ReadingHistory>>> getReadingHistory({
    int page = 1,
    int limit = 20,
  });

  /// Sync offline progress
  Future<Either<Failure, void>> syncOfflineProgress();
}
