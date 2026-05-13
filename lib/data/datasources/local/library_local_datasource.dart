import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/enums.dart';
import '../../../core/errors/exceptions.dart';
import '../../models/reading_history_model.dart';

abstract class LibraryLocalDataSource {
  // Reading Progress Cache
  Future<void> cacheReadingProgress(ReadingHistoryModel progress);
  Future<ReadingHistoryModel?> getCachedReadingProgress(String bookId);
  Future<List<ReadingHistoryModel>> getPendingSyncProgress();
  Future<void> clearSyncedProgress(String bookId);

  // Theme Settings
  Future<void> saveReaderTheme(ReaderTheme theme);
  Future<ReaderTheme> getReaderTheme();
  Future<void> saveFontSize(double size);
  Future<double> getFontSize();
  Future<void> saveNavigationMode(NavigationMode mode);
  Future<NavigationMode> getNavigationMode();

  // App Theme
  Future<void> saveAppTheme(ThemeMode mode);
  Future<ThemeMode> getAppTheme();
}

class LibraryLocalDataSourceImpl implements LibraryLocalDataSource {
  final SharedPreferences prefs;

  static const String _readerThemeKey = 'reader_theme';
  static const String _fontSizeKey = 'font_size';
  static const String _navigationModeKey = 'navigation_mode';
  static const String _appThemeKey = 'app_theme';
  static const String _pendingProgressKey = 'pending_progress';

  LibraryLocalDataSourceImpl({required this.prefs});

  @override
  Future<void> cacheReadingProgress(ReadingHistoryModel progress) async {
    try {
      final pendingJson = prefs.getString(_pendingProgressKey);
      final Map<String, dynamic> pending = pendingJson != null
          ? jsonDecode(pendingJson)
          : {};

      pending[progress.bookId] = progress.toJson();

      await prefs.setString(_pendingProgressKey, jsonEncode(pending));
    } catch (e) {
      throw CacheException(message: e.toString());
    }
  }

  @override
  Future<ReadingHistoryModel?> getCachedReadingProgress(String bookId) async {
    try {
      final pendingJson = prefs.getString(_pendingProgressKey);
      if (pendingJson == null) return null;

      final Map<String, dynamic> pending = jsonDecode(pendingJson);
      if (!pending.containsKey(bookId)) return null;

      return ReadingHistoryModel.fromJson(pending[bookId]);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<ReadingHistoryModel>> getPendingSyncProgress() async {
    try {
      final pendingJson = prefs.getString(_pendingProgressKey);
      if (pendingJson == null) return [];

      final Map<String, dynamic> pending = jsonDecode(pendingJson);
      return pending.values
          .map((json) => ReadingHistoryModel.fromJson(json))
          .toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<void> clearSyncedProgress(String bookId) async {
    try {
      final pendingJson = prefs.getString(_pendingProgressKey);
      if (pendingJson == null) return;

      final Map<String, dynamic> pending = jsonDecode(pendingJson);
      pending.remove(bookId);

      await prefs.setString(_pendingProgressKey, jsonEncode(pending));
    } catch (e) {
      // Ignore
    }
  }

  @override
  Future<void> saveReaderTheme(ReaderTheme theme) async {
    await prefs.setString(_readerThemeKey, theme.name);
  }

  @override
  Future<ReaderTheme> getReaderTheme() async {
    final themeName = prefs.getString(_readerThemeKey);
    switch (themeName) {
      case 'dark':
        return ReaderTheme.dark;
      case 'sepia':
        return ReaderTheme.sepia;
      default:
        return ReaderTheme.light;
    }
  }

  @override
  Future<void> saveFontSize(double size) async {
    await prefs.setDouble(_fontSizeKey, size);
  }

  @override
  Future<double> getFontSize() async {
    return prefs.getDouble(_fontSizeKey) ?? 16.0;
  }

  @override
  Future<void> saveNavigationMode(NavigationMode mode) async {
    await prefs.setString(_navigationModeKey, mode.name);
  }

  @override
  Future<NavigationMode> getNavigationMode() async {
    final modeName = prefs.getString(_navigationModeKey);
    return modeName == 'vertical'
        ? NavigationMode.vertical
        : NavigationMode.horizontal;
  }

  @override
  Future<void> saveAppTheme(ThemeMode mode) async {
    await prefs.setString(_appThemeKey, mode.name);
  }

  @override
  Future<ThemeMode> getAppTheme() async {
    final modeName = prefs.getString(_appThemeKey);
    switch (modeName) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }
}
