import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/book.dart';
import '../entities/category.dart';

abstract class BookRepository {
  /// Get featured books for home page
  Future<Either<Failure, List<Book>>> getFeaturedBooks();

  /// Get recently added books
  Future<Either<Failure, List<Book>>> getRecentBooks({
    int page = 1,
    int limit = 20,
  });

  /// Search books by query
  Future<Either<Failure, List<Book>>> searchBooks({
    required String query,
    int page = 1,
    int limit = 20,
  });

  /// Get books by category
  Future<Either<Failure, List<Book>>> getBooksByCategory({
    required String categoryId,
    int page = 1,
    int limit = 20,
  });

  /// Get book details by ID
  Future<Either<Failure, Book>> getBookById(String id);

  /// Get all categories
  Future<Either<Failure, List<Category>>> getCategories();

  /// Get books from Open Library API
  Future<Either<Failure, List<Book>>> searchOpenLibrary({
    required String query,
    int page = 1,
    int limit = 20,
  });

  /// Get book details from Open Library
  Future<Either<Failure, Book>> getOpenLibraryBook(String key);

  /// Increment book read count
  Future<Either<Failure, void>> incrementReadCount(String bookId);

  /// Increment book download count
  Future<Either<Failure, void>> incrementDownloadCount(String bookId);

  /// Get user's uploaded books (for authors)
  Future<Either<Failure, List<Book>>> getUserBooks({
    required String userId,
    int page = 1,
    int limit = 20,
  });

  /// Get pending books for moderation (admin only)
  Future<Either<Failure, List<Book>>> getPendingBooks({
    int page = 1,
    int limit = 20,
  });
}
