import '../../core/constants/enums.dart';
import '../../domain/entities/book.dart';

class BookModel extends Book {
  const BookModel({
    required super.id,
    required super.title,
    super.author,
    super.authorId,
    super.description,
    super.coverUrl,
    super.fileUrl,
    super.format,
    super.categoryId,
    super.categoryName,
    super.licenseType,
    super.status,
    super.totalReads,
    super.totalDownloads,
    super.tags,
    required super.createdAt,
    super.updatedAt,
    super.openLibraryKey,
    super.isbn,
    super.publishYear,
    super.pageCount,
  });

  factory BookModel.fromJson(Map<String, dynamic> json) {
    return BookModel(
      id: json['id'] as String,
      title: json['title'] as String,
      author: json['author'] as String?,
      authorId: json['author_id'] as String?,
      description: json['description'] as String?,
      coverUrl: json['cover_url'] as String?,
      fileUrl: json['file_url'] as String?,
      format: _parseFormat(json['format'] as String?),
      categoryId: json['category_id'] as String?,
      categoryName: json['category_name'] as String?,
      licenseType: _parseLicenseType(json['license_type'] as String?),
      status: _parseStatus(json['status'] as String?),
      totalReads: json['total_reads'] as int? ?? 0,
      totalDownloads: json['total_downloads'] as int? ?? 0,
      tags: (json['tags'] as List<dynamic>?)?.cast<String>() ?? [],
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
      openLibraryKey: json['open_library_key'] as String?,
      isbn: json['isbn'] as String?,
      publishYear: json['publish_year'] as int?,
      pageCount: json['page_count'] as int?,
    );
  }

  factory BookModel.fromOpenLibrary(Map<String, dynamic> json) {
    final coverId = json['cover_i'] as int?;
    final coverUrl = coverId != null
        ? 'https://covers.openlibrary.org/b/id/$coverId-L.jpg'
        : null;

    return BookModel(
      id: json['key'] as String? ?? '',
      title: json['title'] as String? ?? 'Unknown Title',
      author: (json['author_name'] as List<dynamic>?)?.firstOrNull as String?,
      description: json['first_sentence'] != null
          ? (json['first_sentence'] as List<dynamic>?)?.firstOrNull as String?
          : null,
      coverUrl: coverUrl,
      format: BookFormat.epub,
      status: BookStatus.published,
      createdAt: DateTime.now(),
      openLibraryKey: json['key'] as String?,
      isbn: (json['isbn'] as List<dynamic>?)?.firstOrNull as String?,
      publishYear: json['first_publish_year'] as int?,
      pageCount: json['number_of_pages_median'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'author_id': authorId,
      'description': description,
      'cover_url': coverUrl,
      'file_url': fileUrl,
      'format': format.name,
      'category_id': categoryId,
      'license_type': licenseType.name,
      'status': status.name,
      'total_reads': totalReads,
      'total_downloads': totalDownloads,
      'tags': tags,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'open_library_key': openLibraryKey,
      'isbn': isbn,
      'publish_year': publishYear,
      'page_count': pageCount,
    };
  }

  static BookFormat _parseFormat(String? format) {
    switch (format) {
      case 'pdf':
        return BookFormat.pdf;
      default:
        return BookFormat.epub;
    }
  }

  static LicenseType _parseLicenseType(String? type) {
    switch (type) {
      case 'creativeCommons':
        return LicenseType.creativeCommons;
      case 'custom':
        return LicenseType.custom;
      default:
        return LicenseType.publicDomain;
    }
  }

  static BookStatus _parseStatus(String? status) {
    switch (status) {
      case 'pending':
        return BookStatus.pending;
      case 'rejected':
        return BookStatus.rejected;
      case 'unlisted':
        return BookStatus.unlisted;
      default:
        return BookStatus.published;
    }
  }

  factory BookModel.fromEntity(Book book) {
    return BookModel(
      id: book.id,
      title: book.title,
      author: book.author,
      authorId: book.authorId,
      description: book.description,
      coverUrl: book.coverUrl,
      fileUrl: book.fileUrl,
      format: book.format,
      categoryId: book.categoryId,
      categoryName: book.categoryName,
      licenseType: book.licenseType,
      status: book.status,
      totalReads: book.totalReads,
      totalDownloads: book.totalDownloads,
      tags: book.tags,
      createdAt: book.createdAt,
      updatedAt: book.updatedAt,
      openLibraryKey: book.openLibraryKey,
      isbn: book.isbn,
      publishYear: book.publishYear,
      pageCount: book.pageCount,
    );
  }
}
