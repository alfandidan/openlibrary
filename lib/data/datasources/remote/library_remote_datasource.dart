import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import '../../../core/constants/api_endpoints.dart';
import '../../../core/errors/exceptions.dart';
import '../../../core/network/supabase_config.dart';
import '../../models/bookmark_model.dart';
import '../../models/favorite_model.dart';
import '../../models/reading_history_model.dart';

abstract class LibraryRemoteDataSource {
  // Favorites
  Future<FavoriteModel> addToFavorites(String bookId);
  Future<void> removeFromFavorites(String bookId);
  Future<List<String>> getFavoriteBookIds();
  Future<bool> isFavorite(String bookId);

  // Bookmarks
  Future<BookmarkModel> createBookmark({
    required String bookId,
    required int pageNumber,
    String? note,
  });
  Future<void> deleteBookmark(String bookmarkId);
  Future<List<BookmarkModel>> getBookBookmarks(String bookId);
  Future<List<BookmarkModel>> getAllBookmarks({int page = 1, int limit = 20});

  // Reading History
  Future<ReadingHistoryModel> saveReadingProgress({
    required String bookId,
    required int lastPage,
    required int progress,
  });
  Future<ReadingHistoryModel?> getReadingProgress(String bookId);
  Future<List<ReadingHistoryModel>> getReadingHistory({int page = 1, int limit = 20});
}

class LibraryRemoteDataSourceImpl implements LibraryRemoteDataSource {
  final SupabaseClient client;
  final Uuid uuid;

  LibraryRemoteDataSourceImpl({required this.client, required this.uuid});

  String get _userId => SupabaseConfig.currentUserId;

  // Favorites
  @override
  Future<FavoriteModel> addToFavorites(String bookId) async {
    try {
      final favoriteData = {
        'id': uuid.v4(),
        'user_id': _userId,
        'book_id': bookId,
        'created_at': DateTime.now().toIso8601String(),
      };

      await client.from(ApiEndpoints.favoritesTable).insert(favoriteData);

      return FavoriteModel.fromJson(favoriteData);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> removeFromFavorites(String bookId) async {
    try {
      await client
          .from(ApiEndpoints.favoritesTable)
          .delete()
          .eq('user_id', _userId)
          .eq('book_id', bookId);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<String>> getFavoriteBookIds() async {
    try {
      final data = await client
          .from(ApiEndpoints.favoritesTable)
          .select('book_id')
          .eq('user_id', _userId)
          .order('created_at', ascending: false);

      return (data as List).map((e) => e['book_id'] as String).toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<bool> isFavorite(String bookId) async {
    try {
      final data = await client
          .from(ApiEndpoints.favoritesTable)
          .select('id')
          .eq('user_id', _userId)
          .eq('book_id', bookId)
          .maybeSingle();

      return data != null;
    } catch (e) {
      return false;
    }
  }

  // Bookmarks
  @override
  Future<BookmarkModel> createBookmark({
    required String bookId,
    required int pageNumber,
    String? note,
  }) async {
    try {
      // Check bookmark limit
      final existingCount = await client
          .from(ApiEndpoints.bookmarksTable)
          .select('id')
          .eq('user_id', _userId)
          .eq('book_id', bookId);

      if ((existingCount as List).length >= 50) {
        throw ValidationException(message: 'Maksimal 50 bookmark per buku');
      }

      final bookmarkData = {
        'id': uuid.v4(),
        'user_id': _userId,
        'book_id': bookId,
        'page_number': pageNumber,
        'note': note,
        'created_at': DateTime.now().toIso8601String(),
      };

      await client.from(ApiEndpoints.bookmarksTable).insert(bookmarkData);

      return BookmarkModel.fromJson(bookmarkData);
    } catch (e) {
      if (e is ValidationException) rethrow;
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> deleteBookmark(String bookmarkId) async {
    try {
      await client
          .from(ApiEndpoints.bookmarksTable)
          .delete()
          .eq('id', bookmarkId)
          .eq('user_id', _userId);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<BookmarkModel>> getBookBookmarks(String bookId) async {
    try {
      final data = await client
          .from(ApiEndpoints.bookmarksTable)
          .select()
          .eq('user_id', _userId)
          .eq('book_id', bookId)
          .order('page_number');

      return (data as List).map((json) => BookmarkModel.fromJson(json)).toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<BookmarkModel>> getAllBookmarks({int page = 1, int limit = 20}) async {
    try {
      final offset = (page - 1) * limit;

      final data = await client
          .from(ApiEndpoints.bookmarksTable)
          .select()
          .eq('user_id', _userId)
          .order('created_at', ascending: false)
          .range(offset, offset + limit - 1);

      return (data as List).map((json) => BookmarkModel.fromJson(json)).toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  // Reading History
  @override
  Future<ReadingHistoryModel> saveReadingProgress({
    required String bookId,
    required int lastPage,
    required int progress,
  }) async {
    try {
      final now = DateTime.now().toIso8601String();

      // Check if history exists
      final existing = await client
          .from(ApiEndpoints.readingHistoryTable)
          .select()
          .eq('user_id', _userId)
          .eq('book_id', bookId)
          .maybeSingle();

      if (existing != null) {
        // Update existing
        final updated = await client
            .from(ApiEndpoints.readingHistoryTable)
            .update({
              'last_page': lastPage,
              'progress': progress,
              'updated_at': now,
            })
            .eq('id', existing['id'])
            .select()
            .single();

        return ReadingHistoryModel.fromJson(updated);
      } else {
        // Create new
        final historyData = {
          'id': uuid.v4(),
          'user_id': _userId,
          'book_id': bookId,
          'last_page': lastPage,
          'progress': progress,
          'updated_at': now,
        };

        await client.from(ApiEndpoints.readingHistoryTable).insert(historyData);

        return ReadingHistoryModel.fromJson(historyData);
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<ReadingHistoryModel?> getReadingProgress(String bookId) async {
    try {
      final data = await client
          .from(ApiEndpoints.readingHistoryTable)
          .select()
          .eq('user_id', _userId)
          .eq('book_id', bookId)
          .maybeSingle();

      if (data == null) return null;

      return ReadingHistoryModel.fromJson(data);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<ReadingHistoryModel>> getReadingHistory({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final offset = (page - 1) * limit;

      final data = await client
          .from(ApiEndpoints.readingHistoryTable)
          .select()
          .eq('user_id', _userId)
          .order('updated_at', ascending: false)
          .range(offset, offset + limit - 1);

      return (data as List)
          .map((json) => ReadingHistoryModel.fromJson(json))
          .toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
