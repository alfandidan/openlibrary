enum ThemeMode { light, dark, system }

enum BookFormat { epub, pdf }

enum BookStatus { pending, published, rejected, unlisted }

enum LicenseType { creativeCommons, publicDomain, custom }

enum ReportReason { copyright, inappropriate, spam, other }

enum ReportStatus { pending, reviewed, resolved, dismissed }

enum UserRole { user, author, admin }

enum ReaderTheme { light, dark, sepia }

enum NavigationMode { horizontal, vertical }

extension BookFormatExtension on BookFormat {
  String get displayName {
    switch (this) {
      case BookFormat.epub:
        return 'EPUB';
      case BookFormat.pdf:
        return 'PDF';
    }
  }

  String get extension {
    switch (this) {
      case BookFormat.epub:
        return '.epub';
      case BookFormat.pdf:
        return '.pdf';
    }
  }
}

extension BookStatusExtension on BookStatus {
  String get displayName {
    switch (this) {
      case BookStatus.pending:
        return 'Menunggu Review';
      case BookStatus.published:
        return 'Dipublikasikan';
      case BookStatus.rejected:
        return 'Ditolak';
      case BookStatus.unlisted:
        return 'Tidak Terdaftar';
    }
  }
}

extension LicenseTypeExtension on LicenseType {
  String get displayName {
    switch (this) {
      case LicenseType.creativeCommons:
        return 'Creative Commons';
      case LicenseType.publicDomain:
        return 'Public Domain';
      case LicenseType.custom:
        return 'Custom';
    }
  }
}

extension ReportReasonExtension on ReportReason {
  String get displayName {
    switch (this) {
      case ReportReason.copyright:
        return 'Pelanggaran Hak Cipta';
      case ReportReason.inappropriate:
        return 'Konten Tidak Pantas';
      case ReportReason.spam:
        return 'Spam';
      case ReportReason.other:
        return 'Lainnya';
    }
  }
}

extension ReaderThemeExtension on ReaderTheme {
  String get displayName {
    switch (this) {
      case ReaderTheme.light:
        return 'Terang';
      case ReaderTheme.dark:
        return 'Gelap';
      case ReaderTheme.sepia:
        return 'Sepia';
    }
  }
}
