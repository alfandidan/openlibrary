import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/errors/exceptions.dart';
import '../../models/book_model.dart';

abstract class BookLocalDataSource {
  Future<void> cacheBooks(String key, List<BookModel> books);
  Future<List<BookModel>> getCachedBooks(String key);
  Future<void> cacheBook(BookModel book);
  Future<BookModel?> getCachedBook(String id);
  Future<void> clearCache();
}

class BookLocalDataSourceImpl implements BookLocalDataSource {
  final SharedPreferences prefs;

  static const String _booksPrefix = 'cached_books_';
  static const String _bookPrefix = 'cached_book_';
  static const Duration _cacheValidity = Duration(hours: 1);

  BookLocalDataSourceImpl({required this.prefs});

  @override
  Future<void> cacheBooks(String key, List<BookModel> books) async {
    try {
      final cacheData = {
        'timestamp': DateTime.now().toIso8601String(),
        'books': books.map((b) => b.toJson()).toList(),
      };
      await prefs.setString('$_booksPrefix$key', jsonEncode(cacheData));
    } catch (e) {
      throw CacheException(message: e.toString());
    }
  }

  @override
  Future<List<BookModel>> getCachedBooks(String key) async {
    try {
      final jsonString = prefs.getString('$_booksPrefix$key');
      if (jsonString == null) {
        throw CacheException(message: 'No cached data');
      }

      final cacheData = jsonDecode(jsonString);
      final timestamp = DateTime.parse(cacheData['timestamp']);

      if (DateTime.now().difference(timestamp) > _cacheValidity) {
        throw CacheException(message: 'Cache expired');
      }

      final booksList = cacheData['books'] as List;
      return booksList.map((json) => BookModel.fromJson(json)).toList();
    } catch (e) {
      throw CacheException(message: e.toString());
    }
  }

  @override
  Future<void> cacheBook(BookModel book) async {
    try {
      final cacheData = {
        'timestamp': DateTime.now().toIso8601String(),
        'book': book.toJson(),
      };
      await prefs.setString('$_bookPrefix${book.id}', jsonEncode(cacheData));
    } catch (e) {
      throw CacheException(message: e.toString());
    }
  }

  @override
  Future<BookModel?> getCachedBook(String id) async {
    try {
      final jsonString = prefs.getString('$_bookPrefix$id');
      if (jsonString == null) return null;

      final cacheData = jsonDecode(jsonString);
      final timestamp = DateTime.parse(cacheData['timestamp']);

      if (DateTime.now().difference(timestamp) > _cacheValidity) {
        return null;
      }

      return BookModel.fromJson(cacheData['book']);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> clearCache() async {
    final keys = prefs.getKeys();
    for (final key in keys) {
      if (key.startsWith(_booksPrefix) || key.startsWith(_bookPrefix)) {
        await prefs.remove(key);
      }
    }
  }
}
