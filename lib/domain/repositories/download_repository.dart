import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/book.dart';

abstract class DownloadRepository {
  /// Download a book for offline reading
  Future<Either<Failure, String>> downloadBook(Book book);

  /// Get download progress stream
  Stream<double> getDownloadProgress(String bookId);

  /// Cancel ongoing download
  Future<void> cancelDownload(String bookId);

  /// Get list of downloaded books
  Future<Either<Failure, List<Book>>> getDownloadedBooks();

  /// Check if book is downloaded
  Future<bool> isDownloaded(String bookId);

  /// Get local file path for downloaded book
  Future<Either<Failure, File>> getLocalBookFile(String bookId);

  /// Delete downloaded book
  Future<Either<Failure, void>> deleteDownloadedBook(String bookId);

  /// Get available storage space
  Future<Either<Failure, int>> getAvailableStorage();

  /// Get total downloaded size
  Future<Either<Failure, int>> getTotalDownloadedSize();
}
