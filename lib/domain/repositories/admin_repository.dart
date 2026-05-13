import 'package:dartz/dartz.dart';
import '../../core/constants/enums.dart';
import '../../core/errors/failures.dart';
import '../entities/book.dart';
import '../entities/category.dart';
import '../entities/report.dart';
import '../entities/user.dart';

abstract class AdminRepository {
  // Book Moderation
  /// Approve a pending book
  Future<Either<Failure, Book>> approveBook(String bookId);

  /// Reject a pending book
  Future<Either<Failure, Book>> rejectBook({
    required String bookId,
    required String reason,
  });

  /// Get pending books for moderation
  Future<Either<Failure, List<Book>>> getPendingBooks({
    int page = 1,
    int limit = 20,
  });

  // User Management
  /// Ban a user
  Future<Either<Failure, User>> banUser({
    required String userId,
    required String reason,
  });

  /// Unban a user
  Future<Either<Failure, User>> unbanUser(String userId);

  /// Get all users
  Future<Either<Failure, List<User>>> getUsers({
    int page = 1,
    int limit = 20,
    UserRole? filterByRole,
  });

  // Category Management
  /// Create a new category
  Future<Either<Failure, Category>> createCategory({
    required String name,
    String? description,
  });

  /// Update a category
  Future<Either<Failure, Category>> updateCategory({
    required String categoryId,
    String? name,
    String? description,
  });

  /// Delete a category
  Future<Either<Failure, void>> deleteCategory(String categoryId);

  // Featured Books
  /// Set featured books
  Future<Either<Failure, void>> setFeaturedBooks(List<String> bookIds);

  /// Get featured book IDs
  Future<Either<Failure, List<String>>> getFeaturedBookIds();

  // Reports
  /// Get pending reports
  Future<Either<Failure, List<Report>>> getPendingReports({
    int page = 1,
    int limit = 20,
  });

  /// Review a report
  Future<Either<Failure, Report>> reviewReport({
    required String reportId,
    required ReportStatus status,
  });

  // Analytics
  /// Get platform statistics
  Future<Either<Failure, PlatformStats>> getPlatformStats();

  /// Get top books by reads
  Future<Either<Failure, List<Book>>> getTopBooks({int limit = 10});

  /// Get top authors
  Future<Either<Failure, List<AuthorStats>>> getTopAuthors({int limit = 10});

  /// Get monthly growth data
  Future<Either<Failure, List<MonthlyGrowth>>> getMonthlyGrowth({int months = 12});
}

class PlatformStats {
  final int totalUsers;
  final int totalBooks;
  final int totalAuthors;
  final int activeReaders;

  const PlatformStats({
    required this.totalUsers,
    required this.totalBooks,
    required this.totalAuthors,
    required this.activeReaders,
  });
}

class AuthorStats {
  final String authorId;
  final String authorName;
  final int totalBooks;
  final int totalReads;

  const AuthorStats({
    required this.authorId,
    required this.authorName,
    required this.totalBooks,
    required this.totalReads,
  });
}

class MonthlyGrowth {
  final DateTime month;
  final int newUsers;
  final int newBooks;
  final int newAuthors;

  const MonthlyGrowth({
    required this.month,
    required this.newUsers,
    required this.newBooks,
    required this.newAuthors,
  });
}
