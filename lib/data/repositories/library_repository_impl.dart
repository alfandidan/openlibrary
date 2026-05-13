import 'package:dartz/dartz.dart';
import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../core/network/network_info.dart';
import '../../domain/entities/book.dart';
import '../../domain/entities/bookmark.dart';
import '../../domain/entities/favorite.dart';
import '../../domain/entities/reading_history.dart';
import '../../domain/repositories/library_repository.dart';
import '../datasources/local/library_local_datasource.dart';
import '../datasources/remote/library_remote_datasource.dart';
import '../datasources/remote/book_remote_datasource.dart';
import '../models/reading_history_model.dart';

class LibraryRepositoryImpl implements LibraryRepository {
  final LibraryRemoteDataSource remoteDataSource;
  final LibraryLocalDataSource localDataSource;
  final BookRemoteDataSource bookRemoteDataSource;
  final NetworkInfo networkInfo;

  LibraryRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.bookRemoteDataSource,
    required this.networkInfo,
  });

  // Favorites
  @override
  Future<Either<Failure, Favorite>> addToFavorites(String bookId) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final favorite = await remoteDataSource.addToFavorites(bookId);
      return Right(favorite);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> removeFromFavorites(String bookId) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      await remoteDataSource.removeFromFavorites(bookId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<Book>>> getFavoriteBooks({
    int page = 1,
    int limit = 20,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final bookIds = await remoteDataSource.getFavoriteBookIds();
      if (bookIds.isEmpty) return const Right([]);

      // Fetch book details for each favorite
      final books = <Book>[];
      for (final id in bookIds) {
        try {
          final book = await bookRemoteDataSource.getBookById(id);
          books.add(book);
        } catch (e) {
          // Skip books that can't be fetched
        }
      }
      return Right(books);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, bool>> isFavorite(String bookId) async {
    try {
      final result = await remoteDataSource.isFavorite(bookId);
      return Right(result);
    } catch (e) {
      return const Right(false);
    }
  }

  // Bookmarks
  @override
  Future<Either<Failure, Bookmark>> createBookmark({
    required String bookId,
    required int pageNumber,
    String? note,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final bookmark = await remoteDataSource.createBookmark(
        bookId: bookId,
        pageNumber: pageNumber,
        note: note,
      );
      return Right(bookmark);
    } on ValidationException catch (e) {
      return Left(ValidationFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> deleteBookmark(String bookmarkId) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      await remoteDataSource.deleteBookmark(bookmarkId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<Bookmark>>> getBookBookmarks(String bookId) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final bookmarks = await remoteDataSource.getBookBookmarks(bookId);
      return Right(bookmarks);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<Bookmark>>> getAllBookmarks({
    int page = 1,
    int limit = 20,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final bookmarks = await remoteDataSource.getAllBookmarks(
        page: page,
        limit: limit,
      );
      return Right(bookmarks);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  // Reading History
  @override
  Future<Either<Failure, ReadingHistory>> saveReadingProgress({
    required String bookId,
    required int lastPage,
    required int progress,
  }) async {
    final progressModel = ReadingHistoryModel(
      id: '',
      userId: '',
      bookId: bookId,
      lastPage: lastPage,
      progress: progress,
      updatedAt: DateTime.now(),
    );

    // Always cache locally first
    await localDataSource.cacheReadingProgress(progressModel);

    if (!await networkInfo.isConnected) {
      return Right(progressModel);
    }

    try {
      final savedProgress = await remoteDataSource.saveReadingProgress(
        bookId: bookId,
        lastPage: lastPage,
        progress: progress,
      );
      await localDataSource.clearSyncedProgress(bookId);
      return Right(savedProgress);
    } on ServerException {
      // Return cached version on failure
      return Right(progressModel);
    }
  }

  @override
  Future<Either<Failure, ReadingHistory?>> getReadingProgress(String bookId) async {
    // Check local cache first
    final cachedProgress = await localDataSource.getCachedReadingProgress(bookId);

    if (!await networkInfo.isConnected) {
      return Right(cachedProgress);
    }

    try {
      final remoteProgress = await remoteDataSource.getReadingProgress(bookId);

      // Use the most recent one
      if (cachedProgress != null && remoteProgress != null) {
        if (cachedProgress.updatedAt.isAfter(remoteProgress.updatedAt)) {
          return Right(cachedProgress);
        }
      }

      return Right(remoteProgress ?? cachedProgress);
    } on ServerException {
      return Right(cachedProgress);
    }
  }

  @override
  Future<Either<Failure, List<ReadingHistory>>> getReadingHistory({
    int page = 1,
    int limit = 20,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final history = await remoteDataSource.getReadingHistory(
        page: page,
        limit: limit,
      );
      return Right(history);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> syncOfflineProgress() async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final pendingProgress = await localDataSource.getPendingSyncProgress();

      for (final progress in pendingProgress) {
        try {
          await remoteDataSource.saveReadingProgress(
            bookId: progress.bookId,
            lastPage: progress.lastPage,
            progress: progress.progress,
          );
          await localDataSource.clearSyncedProgress(progress.bookId);
        } catch (e) {
          // Continue with other items
        }
      }

      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
