class ApiEndpoints {
  ApiEndpoints._();

  // Open Library API
  static const String openLibraryBaseUrl = 'https://openlibrary.org';
  static const String searchBooks = '/search.json';
  static const String bookDetails = '/works';
  static const String authorDetails = '/authors';
  static const String coverImage = 'https://covers.openlibrary.org/b';

  // Supabase Tables
  static const String usersTable = 'users';
  static const String booksTable = 'books';
  static const String categoriesTable = 'categories';
  static const String bookmarksTable = 'bookmarks';
  static const String favoritesTable = 'favorites';
  static const String readingHistoryTable = 'reading_history';
  static const String reportsTable = 'reports';
  static const String tagsTable = 'tags';
  static const String bookTagsTable = 'book_tags';
  static const String featuredBooksTable = 'featured_books';
}
