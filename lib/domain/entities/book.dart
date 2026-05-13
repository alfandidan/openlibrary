import 'package:equatable/equatable.dart';
import '../../core/constants/enums.dart';

class Book extends Equatable {
  final String id;
  final String title;
  final String? author;
  final String? authorId;
  final String? description;
  final String? coverUrl;
  final String? fileUrl;
  final BookFormat format;
  final String? categoryId;
  final String? categoryName;
  final LicenseType licenseType;
  final BookStatus status;
  final int totalReads;
  final int totalDownloads;
  final List<String> tags;
  final DateTime createdAt;
  final DateTime? updatedAt;

  // Open Library specific fields
  final String? openLibraryKey;
  final String? isbn;
  final int? publishYear;
  final int? pageCount;

  const Book({
    required this.id,
    required this.title,
    this.author,
    this.authorId,
    this.description,
    this.coverUrl,
    this.fileUrl,
    this.format = BookFormat.epub,
    this.categoryId,
    this.categoryName,
    this.licenseType = LicenseType.publicDomain,
    this.status = BookStatus.published,
    this.totalReads = 0,
    this.totalDownloads = 0,
    this.tags = const [],
    required this.createdAt,
    this.updatedAt,
    this.openLibraryKey,
    this.isbn,
    this.publishYear,
    this.pageCount,
  });

  bool get isPublished => status == BookStatus.published;
  bool get isPending => status == BookStatus.pending;
  bool get isEpub => format == BookFormat.epub;
  bool get isPdf => format == BookFormat.pdf;
  bool get isFromOpenLibrary => openLibraryKey != null;

  Book copyWith({
    String? id,
    String? title,
    String? author,
    String? authorId,
    String? description,
    String? coverUrl,
    String? fileUrl,
    BookFormat? format,
    String? categoryId,
    String? categoryName,
    LicenseType? licenseType,
    BookStatus? status,
    int? totalReads,
    int? totalDownloads,
    List<String>? tags,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? openLibraryKey,
    String? isbn,
    int? publishYear,
    int? pageCount,
  }) {
    return Book(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      authorId: authorId ?? this.authorId,
      description: description ?? this.description,
      coverUrl: coverUrl ?? this.coverUrl,
      fileUrl: fileUrl ?? this.fileUrl,
      format: format ?? this.format,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      licenseType: licenseType ?? this.licenseType,
      status: status ?? this.status,
      totalReads: totalReads ?? this.totalReads,
      totalDownloads: totalDownloads ?? this.totalDownloads,
      tags: tags ?? this.tags,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      openLibraryKey: openLibraryKey ?? this.openLibraryKey,
      isbn: isbn ?? this.isbn,
      publishYear: publishYear ?? this.publishYear,
      pageCount: pageCount ?? this.pageCount,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        author,
        authorId,
        description,
        coverUrl,
        fileUrl,
        format,
        categoryId,
        categoryName,
        licenseType,
        status,
        totalReads,
        totalDownloads,
        tags,
        createdAt,
        updatedAt,
        openLibraryKey,
        isbn,
        publishYear,
        pageCount,
      ];
}
