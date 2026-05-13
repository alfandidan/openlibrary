import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../domain/entities/book.dart';
import '../../../../domain/entities/category.dart';
import '../../../../shared/providers/providers.dart';

// Home State
class HomeState {
  final bool isLoading;
  final List<Book> featuredBooks;
  final List<Book> recentBooks;
  final List<Category> categories;
  final String? errorMessage;

  const HomeState({
    this.isLoading = false,
    this.featuredBooks = const [],
    this.recentBooks = const [],
    this.categories = const [],
    this.errorMessage,
  });

  HomeState copyWith({
    bool? isLoading,
    List<Book>? featuredBooks,
    List<Book>? recentBooks,
    List<Category>? categories,
    String? errorMessage,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      featuredBooks: featuredBooks ?? this.featuredBooks,
      recentBooks: recentBooks ?? this.recentBooks,
      categories: categories ?? this.categories,
      errorMessage: errorMessage,
    );
  }
}

// Home Notifier
class HomeNotifier extends StateNotifier<HomeState> {
  final Ref ref;

  HomeNotifier(this.ref) : super(const HomeState()) {
    loadHomeData();
  }

  Future<void> loadHomeData() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    final bookRepo = ref.read(bookRepositoryProvider);

    // Load all data in parallel
    final results = await Future.wait([
      bookRepo.getFeaturedBooks(),
      bookRepo.getRecentBooks(),
      bookRepo.getCategories(),
    ]);

    final featuredResult = results[0];
    final recentResult = results[1];
    final categoriesResult = results[2];

    List<Book> featured = [];
    List<Book> recent = [];
    List<Category> categories = [];
    String? error;

    featuredResult.fold(
      (failure) => error = failure.message,
      (books) => featured = books as List<Book>,
    );

    recentResult.fold(
      (failure) => error ??= failure.message,
      (books) => recent = books as List<Book>,
    );

    categoriesResult.fold(
      (failure) => error ??= failure.message,
      (cats) => categories = cats as List<Category>,
    );

    state = state.copyWith(
      isLoading: false,
      featuredBooks: featured,
      recentBooks: recent,
      categories: categories,
      errorMessage: error,
    );
  }

  Future<void> refresh() async {
    await loadHomeData();
  }
}

// Provider
final homeProvider = StateNotifierProvider<HomeNotifier, HomeState>((ref) {
  return HomeNotifier(ref);
});

// Search State
class SearchState {
  final bool isLoading;
  final String query;
  final List<Book> results;
  final String? errorMessage;
  final bool hasMore;
  final int currentPage;

  const SearchState({
    this.isLoading = false,
    this.query = '',
    this.results = const [],
    this.errorMessage,
    this.hasMore = true,
    this.currentPage = 1,
  });

  SearchState copyWith({
    bool? isLoading,
    String? query,
    List<Book>? results,
    String? errorMessage,
    bool? hasMore,
    int? currentPage,
  }) {
    return SearchState(
      isLoading: isLoading ?? this.isLoading,
      query: query ?? this.query,
      results: results ?? this.results,
      errorMessage: errorMessage,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
    );
  }
}

// Search Notifier
class SearchNotifier extends StateNotifier<SearchState> {
  final Ref ref;

  SearchNotifier(this.ref) : super(const SearchState());

  Future<void> search(String query) async {
    if (query.isEmpty) {
      state = const SearchState();
      return;
    }

    state = state.copyWith(
      isLoading: true,
      query: query,
      results: [],
      currentPage: 1,
      errorMessage: null,
    );

    final result = await ref.read(bookRepositoryProvider).searchBooks(
          query: query,
          page: 1,
        );

    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        errorMessage: failure.message,
      ),
      (books) => state = state.copyWith(
        isLoading: false,
        results: books,
        hasMore: books.length >= 20,
      ),
    );
  }

  Future<void> loadMore() async {
    if (state.isLoading || !state.hasMore) return;

    state = state.copyWith(isLoading: true);

    final nextPage = state.currentPage + 1;
    final result = await ref.read(bookRepositoryProvider).searchBooks(
          query: state.query,
          page: nextPage,
        );

    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        errorMessage: failure.message,
      ),
      (books) => state = state.copyWith(
        isLoading: false,
        results: [...state.results, ...books],
        currentPage: nextPage,
        hasMore: books.length >= 20,
      ),
    );
  }

  void clear() {
    state = const SearchState();
  }
}

// Provider
final searchProvider = StateNotifierProvider<SearchNotifier, SearchState>((ref) {
  return SearchNotifier(ref);
});
