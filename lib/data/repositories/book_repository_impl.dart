import 'package:dartz/dartz.dart';
import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../core/network/network_info.dart';
import '../../domain/entities/book.dart';
import '../../domain/entities/category.dart';
import '../../domain/repositories/book_repository.dart';
import '../datasources/local/book_local_datasource.dart';
import '../datasources/remote/book_remote_datasource.dart';

class BookRepositoryImpl implements BookRepository {
  final BookRemoteDataSource remoteDataSource;
  final BookLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  BookRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Book>>> getFeaturedBooks() async {
    try {
      if (await networkInfo.isConnected) {
        final books = await remoteDataSource.getFeaturedBooks();
        await localDataSource.cacheBooks('featured', books);
        return Right(books);
      } else {
        final cachedBooks = await localDataSource.getCachedBooks('featured');
        return Right(cachedBooks);
      }
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on CacheException {
      return const Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<Book>>> getRecentBooks({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      if (await networkInfo.isConnected) {
        final books = await remoteDataSource.getRecentBooks(
          page: page,
          limit: limit,
        );
        if (page == 1) {
          await localDataSource.cacheBooks('recent', books);
        }
        return Right(books);
      } else {
        if (page == 1) {
          final cachedBooks = await localDataSource.getCachedBooks('recent');
          return Right(cachedBooks);
        }
        return const Left(NetworkFailure());
      }
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on CacheException {
      return const Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<Book>>> searchBooks({
    required String query,
    int page = 1,
    int limit = 20,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final books = await remoteDataSource.searchBooks(
        query: query,
        page: page,
        limit: limit,
      );
      return Right(books);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<Book>>> getBooksByCategory({
    required String categoryId,
    int page = 1,
    int limit = 20,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final books = await remoteDataSource.getBooksByCategory(
        categoryId: categoryId,
        page: page,
        limit: limit,
      );
      return Right(books);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, Book>> getBookById(String id) async {
    try {
      // Try cache first
      final cachedBook = await localDataSource.getCachedBook(id);
      if (cachedBook != null && !await networkInfo.isConnected) {
        return Right(cachedBook);
      }

      if (await networkInfo.isConnected) {
        final book = await remoteDataSource.getBookById(id);
        await localDataSource.cacheBook(book);
        return Right(book);
      } else if (cachedBook != null) {
        return Right(cachedBook);
      } else {
        return const Left(NetworkFailure());
      }
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<Category>>> getCategories() async {
    try {
      if (await networkInfo.isConnected) {
        final categories = await remoteDataSource.getCategories();
        return Right(categories);
      } else {
        return const Left(NetworkFailure());
      }
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<Book>>> searchOpenLibrary({
    required String query,
    int page = 1,
    int limit = 20,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final books = await remoteDataSource.searchOpenLibrary(
        query: query,
        page: page,
        limit: limit,
      );
      return Right(books);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, Book>> getOpenLibraryBook(String key) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final book = await remoteDataSource.getOpenLibraryBook(key);
      return Right(book);
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> incrementReadCount(String bookId) async {
    try {
      await remoteDataSource.incrementReadCount(bookId);
      return const Right(null);
    } catch (e) {
      return const Right(null); // Non-critical, don't fail
    }
  }

  @override
  Future<Either<Failure, void>> incrementDownloadCount(String bookId) async {
    try {
      await remoteDataSource.incrementDownloadCount(bookId);
      return const Right(null);
    } catch (e) {
      return const Right(null); // Non-critical, don't fail
    }
  }

  @override
  Future<Either<Failure, List<Book>>> getUserBooks({
    required String userId,
    int page = 1,
    int limit = 20,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final books = await remoteDataSource.getUserBooks(
        userId: userId,
        page: page,
        limit: limit,
      );
      return Right(books);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<Book>>> getPendingBooks({
    int page = 1,
    int limit = 20,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final books = await remoteDataSource.getPendingBooks(
        page: page,
        limit: limit,
      );
      return Right(books);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }
}
