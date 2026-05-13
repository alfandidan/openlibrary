import 'package:dio/dio.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/constants/api_endpoints.dart';
import '../../../core/errors/exceptions.dart';
import '../../models/book_model.dart';
import '../../models/category_model.dart';

abstract class BookRemoteDataSource {
  Future<List<BookModel>> getFeaturedBooks();
  Future<List<BookModel>> getRecentBooks({int page = 1, int limit = 20});
  Future<List<BookModel>> searchBooks({required String query, int page = 1, int limit = 20});
  Future<List<BookModel>> getBooksByCategory({required String categoryId, int page = 1, int limit = 20});
  Future<BookModel> getBookById(String id);
  Future<List<CategoryModel>> getCategories();
  Future<List<BookModel>> searchOpenLibrary({required String query, int page = 1, int limit = 20});
  Future<BookModel> getOpenLibraryBook(String key);
  Future<void> incrementReadCount(String bookId);
  Future<void> incrementDownloadCount(String bookId);
  Future<List<BookModel>> getUserBooks({required String userId, int page = 1, int limit = 20});
  Future<List<BookModel>> getPendingBooks({int page = 1, int limit = 20});
}

class BookRemoteDataSourceImpl implements BookRemoteDataSource {
  final SupabaseClient client;
  final Dio dio;

  BookRemoteDataSourceImpl({required this.client, required this.dio});

  @override
  Future<List<BookModel>> getFeaturedBooks() async {
    try {
      // Get featured book IDs
      final featuredIds = await client
          .from(ApiEndpoints.featuredBooksTable)
          .select('book_id')
          .order('position');

      if (featuredIds.isEmpty) {
        return [];
      }

      final bookIds = (featuredIds as List).map((e) => e['book_id'] as String).toList();

      final booksData = await client
          .from(ApiEndpoints.booksTable)
          .select('*, categories(name)')
          .inFilter('id', bookIds)
          .eq('status', 'published');

      return (booksData as List).map((json) {
        if (json['categories'] != null) {
          json['category_name'] = json['categories']['name'];
        }
        return BookModel.fromJson(json);
      }).toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<BookModel>> getRecentBooks({int page = 1, int limit = 20}) async {
    try {
      final offset = (page - 1) * limit;

      final booksData = await client
          .from(ApiEndpoints.booksTable)
          .select('*, categories(name)')
          .eq('status', 'published')
          .order('created_at', ascending: false)
          .range(offset, offset + limit - 1);

      return (booksData as List).map((json) {
        if (json['categories'] != null) {
          json['category_name'] = json['categories']['name'];
        }
        return BookModel.fromJson(json);
      }).toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<BookModel>> searchBooks({
    required String query,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final offset = (page - 1) * limit;

      final booksData = await client
          .from(ApiEndpoints.booksTable)
          .select('*, categories(name)')
          .eq('status', 'published')
          .or('title.ilike.%$query%,author.ilike.%$query%,description.ilike.%$query%')
          .order('created_at', ascending: false)
          .range(offset, offset + limit - 1);

      return (booksData as List).map((json) {
        if (json['categories'] != null) {
          json['category_name'] = json['categories']['name'];
        }
        return BookModel.fromJson(json);
      }).toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<BookModel>> getBooksByCategory({
    required String categoryId,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final offset = (page - 1) * limit;

      final booksData = await client
          .from(ApiEndpoints.booksTable)
          .select('*, categories(name)')
          .eq('status', 'published')
          .eq('category_id', categoryId)
          .order('created_at', ascending: false)
          .range(offset, offset + limit - 1);

      return (booksData as List).map((json) {
        if (json['categories'] != null) {
          json['category_name'] = json['categories']['name'];
        }
        return BookModel.fromJson(json);
      }).toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<BookModel> getBookById(String id) async {
    try {
      final bookData = await client
          .from(ApiEndpoints.booksTable)
          .select('*, categories(name)')
          .eq('id', id)
          .single();

      if (bookData['categories'] != null) {
        bookData['category_name'] = bookData['categories']['name'];
      }

      return BookModel.fromJson(bookData);
    } catch (e) {
      throw NotFoundException(message: 'Buku tidak ditemukan');
    }
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    try {
      final categoriesData = await client
          .from(ApiEndpoints.categoriesTable)
          .select()
          .order('name');

      return (categoriesData as List)
          .map((json) => CategoryModel.fromJson(json))
          .toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<BookModel>> searchOpenLibrary({
    required String query,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await dio.get(
        '${ApiEndpoints.openLibraryBaseUrl}${ApiEndpoints.searchBooks}',
        queryParameters: {
          'q': query,
          'page': page,
          'limit': limit,
        },
      );

      if (response.statusCode == 200) {
        final docs = response.data['docs'] as List<dynamic>? ?? [];
        return docs.map((json) => BookModel.fromOpenLibrary(json)).toList();
      }

      throw ServerException(message: 'Failed to search Open Library');
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Network error');
    }
  }

  @override
  Future<BookModel> getOpenLibraryBook(String key) async {
    try {
      final response = await dio.get(
        '${ApiEndpoints.openLibraryBaseUrl}$key.json',
      );

      if (response.statusCode == 200) {
        return BookModel.fromOpenLibrary(response.data);
      }

      throw NotFoundException(message: 'Book not found');
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Network error');
    }
  }

  @override
  Future<void> incrementReadCount(String bookId) async {
    try {
      await client.rpc('increment_read_count', params: {'book_id': bookId});
    } catch (e) {
      // Silently fail - not critical
    }
  }

  @override
  Future<void> incrementDownloadCount(String bookId) async {
    try {
      await client.rpc('increment_download_count', params: {'book_id': bookId});
    } catch (e) {
      // Silently fail - not critical
    }
  }

  @override
  Future<List<BookModel>> getUserBooks({
    required String userId,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final offset = (page - 1) * limit;

      final booksData = await client
          .from(ApiEndpoints.booksTable)
          .select('*, categories(name)')
          .eq('author_id', userId)
          .order('created_at', ascending: false)
          .range(offset, offset + limit - 1);

      return (booksData as List).map((json) {
        if (json['categories'] != null) {
          json['category_name'] = json['categories']['name'];
        }
        return BookModel.fromJson(json);
      }).toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<BookModel>> getPendingBooks({int page = 1, int limit = 20}) async {
    try {
      final offset = (page - 1) * limit;

      final booksData = await client
          .from(ApiEndpoints.booksTable)
          .select('*, categories(name)')
          .eq('status', 'pending')
          .order('created_at')
          .range(offset, offset + limit - 1);

      return (booksData as List).map((json) {
        if (json['categories'] != null) {
          json['category_name'] = json['categories']['name'];
        }
        return BookModel.fromJson(json);
      }).toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
