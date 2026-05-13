import 'package:equatable/equatable.dart';
import '../../core/constants/enums.dart';

class Report extends Equatable {
  final String id;
  final String reporterId;
  final String bookId;
  final ReportReason reason;
  final String? description;
  final ReportStatus status;
  final DateTime createdAt;
  final DateTime? reviewedAt;
  final String? reviewedBy;

  const Report({
    required this.id,
    required this.reporterId,
    required this.bookId,
    required this.reason,
    this.description,
    this.status = ReportStatus.pending,
    required this.createdAt,
    this.reviewedAt,
    this.reviewedBy,
  });

  Report copyWith({
    String? id,
    String? reporterId,
    String? bookId,
    ReportReason? reason,
    String? description,
    ReportStatus? status,
    DateTime? createdAt,
    DateTime? reviewedAt,
    String? reviewedBy,
  }) {
    return Report(
      id: id ?? this.id,
      reporterId: reporterId ?? this.reporterId,
      bookId: bookId ?? this.bookId,
      reason: reason ?? this.reason,
      description: description ?? this.description,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      reviewedAt: reviewedAt ?? this.reviewedAt,
      reviewedBy: reviewedBy ?? this.reviewedBy,
    );
  }

  @override
  List<Object?> get props => [
        id,
        reporterId,
        bookId,
        reason,
        description,
        status,
        createdAt,
        reviewedAt,
        reviewedBy,
      ];
}
