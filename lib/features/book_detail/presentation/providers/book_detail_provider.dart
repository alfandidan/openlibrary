import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../domain/entities/book.dart';
import '../../../../domain/entities/reading_history.dart';
import '../../../../shared/providers/providers.dart';

class BookDetailState {
  final bool isLoading;
  final Book? book;
  final bool isFavorite;
  final ReadingHistory? readingProgress;
  final String? errorMessage;

  const BookDetailState({
    this.isLoading = false,
    this.book,
    this.isFavorite = false,
    this.readingProgress,
    this.errorMessage,
  });

  BookDetailState copyWith({
    bool? isLoading,
    Book? book,
    bool? isFavorite,
    ReadingHistory? readingProgress,
    String? errorMessage,
  }) {
    return BookDetailState(
      isLoading: isLoading ?? this.isLoading,
      book: book ?? this.book,
      isFavorite: isFavorite ?? this.isFavorite,
      readingProgress: readingProgress ?? this.readingProgress,
      errorMessage: errorMessage,
    );
  }
}

class BookDetailNotifier extends StateNotifier<BookDetailState> {
  final Ref ref;
  final String bookId;

  BookDetailNotifier(this.ref, this.bookId) : super(const BookDetailState()) {
    loadBook();
  }

  Future<void> loadBook() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    final bookRepo = ref.read(bookRepositoryProvider);
    final libraryRepo = ref.read(libraryRepositoryProvider);

    // Load book details
    final bookResult = await bookRepo.getBookById(bookId);

    await bookResult.fold(
      (failure) async {
        state = state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        );
      },
      (book) async {
        // Load favorite status and reading progress in parallel
        final results = await Future.wait([
          libraryRepo.isFavorite(bookId),
          libraryRepo.getReadingProgress(bookId),
        ]);

        final isFavoriteResult = results[0];
        final progressResult = results[1];

        bool isFavorite = false;
        ReadingHistory? progress;

        isFavoriteResult.fold(
          (_) {},
          (value) => isFavorite = value as bool,
        );

        progressResult.fold(
          (_) {},
          (value) => progress = value as ReadingHistory?,
        );

        state = state.copyWith(
          isLoading: false,
          book: book,
          isFavorite: isFavorite,
          readingProgress: progress,
        );

        // Increment read count
        bookRepo.incrementReadCount(bookId);
      },
    );
  }

  Future<void> toggleFavorite() async {
    final libraryRepo = ref.read(libraryRepositoryProvider);

    if (state.isFavorite) {
      final result = await libraryRepo.removeFromFavorites(bookId);
      result.fold(
        (_) {},
        (_) => state = state.copyWith(isFavorite: false),
      );
    } else {
      final result = await libraryRepo.addToFavorites(bookId);
      result.fold(
        (_) {},
        (_) => state = state.copyWith(isFavorite: true),
      );
    }
  }
}

final bookDetailProvider = StateNotifierProvider.family<BookDetailNotifier,
    BookDetailState, String>((ref, bookId) {
  return BookDetailNotifier(ref, bookId);
});
