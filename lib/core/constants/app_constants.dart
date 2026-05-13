class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'OpenLibrary';
  static const String appVersion = '1.0.0';

  // Supabase
  static const String supabaseUrl = 'YOUR_SUPABASE_URL';
  static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';

  // Storage Buckets
  static const String bookCoversBucket = 'book-covers';
  static const String bookFilesBucket = 'book-files';

  // Pagination
  static const int defaultPageSize = 20;
  static const int featuredBooksLimit = 10;
  static const int maxBookmarksPerBook = 50;

  // Validation
  static const int minPasswordLength = 8;
  static const int maxTitleLength = 200;
  static const int maxDescriptionLength = 5000;
  static const int maxTagLength = 30;
  static const int maxTagsCount = 10;
  static const int maxFileSizeMB = 50;
  static const int maxCoverSizeMB = 5;

  // Session
  static const int sessionLifetimeDays = 7;
  static const int maxLoginAttempts = 5;
  static const int lockoutDurationMinutes = 15;
  static const int passwordResetExpiryMinutes = 60;

  // Reader Settings
  static const double minFontSize = 12.0;
  static const double maxFontSize = 32.0;
  static const double defaultFontSize = 16.0;
  static const double fontSizeStep = 2.0;
  static const double minZoom = 1.0;
  static const double maxZoom = 5.0;

  // Sync
  static const int progressSyncDelaySeconds = 5;
  static const int offlineSyncDelaySeconds = 30;
  static const int maxSyncRetries = 3;

  // Timeouts
  static const int loadTimeoutSeconds = 10;
  static const int downloadTimeoutSeconds = 60;
  static const int themeTransitionMs = 500;
}
