import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../core/constants/enums.dart';
import '../../core/errors/failures.dart';
import '../entities/book.dart';

abstract class UploadRepository {
  /// Upload a new book
  Future<Either<Failure, Book>> uploadBook({
    required String title,
    required String description,
    required String categoryId,
    required LicenseType licenseType,
    required File coverImage,
    required File bookFile,
    required BookFormat format,
    List<String>? tags,
  });

  /// Update book metadata
  Future<Either<Failure, Book>> updateBook({
    required String bookId,
    String? title,
    String? description,
    String? categoryId,
    LicenseType? licenseType,
    File? coverImage,
    List<String>? tags,
  });

  /// Delete a book
  Future<Either<Failure, void>> deleteBook(String bookId);

  /// Get upload progress stream
  Stream<double> get uploadProgress;

  /// Cancel ongoing upload
  Future<void> cancelUpload();

  /// Validate book file
  Future<Either<Failure, bool>> validateBookFile(File file);

  /// Validate cover image
  Future<Either<Failure, bool>> validateCoverImage(File file);
}
