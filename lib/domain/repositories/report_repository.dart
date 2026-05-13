import 'package:dartz/dartz.dart';
import '../../core/constants/enums.dart';
import '../../core/errors/failures.dart';
import '../entities/report.dart';

abstract class ReportRepository {
  /// Submit a report for a book
  Future<Either<Failure, Report>> submitReport({
    required String bookId,
    required ReportReason reason,
    String? description,
  });

  /// Check if user has already reported a book
  Future<Either<Failure, bool>> hasReported(String bookId);

  /// Get user's submitted reports
  Future<Either<Failure, List<Report>>> getUserReports({
    int page = 1,
    int limit = 20,
  });
}
