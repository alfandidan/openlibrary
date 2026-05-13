import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../domain/entities/book.dart';
import '../../../../domain/entities/bookmark.dart';
import '../../../../domain/entities/reading_history.dart';
import '../../../../shared/providers/providers.dart';

// Favorites State
class FavoritesState {
  final bool isLoading;
  final List<Book> books;
  final String? errorMessage;

  const FavoritesState({
    this.isLoading = false,
    this.books = const [],
    this.errorMessage,
  });

  FavoritesState copyWith({
    bool? isLoading,
    List<Book>? books,
    String? errorMessage,
  }) {
    return FavoritesState(
      isLoading: isLoading ?? this.isLoading,
      books: books ?? this.books,
      errorMessage: errorMessage,
    );
  }
}

class FavoritesNotifier extends StateNotifier<FavoritesState> {
  final Ref ref;

  FavoritesNotifier(this.ref) : super(const FavoritesState()) {
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    state = state.copyWith(isLoading: true);

    final result = await ref.read(libraryRepositoryProvider).getFavoriteBooks();

    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        errorMessage: failure.message,
      ),
      (books) => state = state.copyWith(
        isLoading: false,
        books: books,
      ),
    );
  }

  Future<void> refresh() async {
    await loadFavorites();
  }
}

final favoritesProvider =
    StateNotifierProvider<FavoritesNotifier, FavoritesState>((ref) {
  return FavoritesNotifier(ref);
});

// Bookmarks State
class BookmarksState {
  final bool isLoading;
  final List<Bookmark> bookmarks;
  final String? errorMessage;

  const BookmarksState({
    this.isLoading = false,
    this.bookmarks = const [],
    this.errorMessage,
  });

  BookmarksState copyWith({
    bool? isLoading,
    List<Bookmark>? bookmarks,
    String? errorMessage,
  }) {
    return BookmarksState(
      isLoading: isLoading ?? this.isLoading,
      bookmarks: bookmarks ?? this.bookmarks,
      errorMessage: errorMessage,
    );
  }
}

class BookmarksNotifier extends StateNotifier<BookmarksState> {
  final Ref ref;

  BookmarksNotifier(this.ref) : super(const BookmarksState()) {
    loadBookmarks();
  }

  Future<void> loadBookmarks() async {
    state = state.copyWith(isLoading: true);

    final result = await ref.read(libraryRepositoryProvider).getAllBookmarks();

    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        errorMessage: failure.message,
      ),
      (bookmarks) => state = state.copyWith(
        isLoading: false,
        bookmarks: bookmarks,
      ),
    );
  }

  Future<void> deleteBookmark(String bookmarkId) async {
    final result =
        await ref.read(libraryRepositoryProvider).deleteBookmark(bookmarkId);

    result.fold(
      (_) {},
      (_) {
        state = state.copyWith(
          bookmarks:
              state.bookmarks.where((b) => b.id != bookmarkId).toList(),
        );
      },
    );
  }

  Future<void> refresh() async {
    await loadBookmarks();
  }
}

final bookmarksProvider =
    StateNotifierProvider<BookmarksNotifier, BookmarksState>((ref) {
  return BookmarksNotifier(ref);
});

// Reading History State
class ReadingHistoryState {
  final bool isLoading;
  final List<ReadingHistory> history;
  final String? errorMessage;

  const ReadingHistoryState({
    this.isLoading = false,
    this.history = const [],
    this.errorMessage,
  });

  ReadingHistoryState copyWith({
    bool? isLoading,
    List<ReadingHistory>? history,
    String? errorMessage,
  }) {
    return ReadingHistoryState(
      isLoading: isLoading ?? this.isLoading,
      history: history ?? this.history,
      errorMessage: errorMessage,
    );
  }
}

class ReadingHistoryNotifier extends StateNotifier<ReadingHistoryState> {
  final Ref ref;

  ReadingHistoryNotifier(this.ref) : super(const ReadingHistoryState()) {
    loadHistory();
  }

  Future<void> loadHistory() async {
    state = state.copyWith(isLoading: true);

    final result = await ref.read(libraryRepositoryProvider).getReadingHistory();

    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        errorMessage: failure.message,
      ),
      (history) => state = state.copyWith(
        isLoading: false,
        history: history,
      ),
    );
  }

  Future<void> refresh() async {
    await loadHistory();
  }
}

final readingHistoryProvider =
    StateNotifierProvider<ReadingHistoryNotifier, ReadingHistoryState>((ref) {
  return ReadingHistoryNotifier(ref);
});
