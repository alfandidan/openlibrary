import '../../core/constants/enums.dart';
import '../../domain/entities/report.dart';

class ReportModel extends Report {
  const ReportModel({
    required super.id,
    required super.reporterId,
    required super.bookId,
    required super.reason,
    super.description,
    super.status,
    required super.createdAt,
    super.reviewedAt,
    super.reviewedBy,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      id: json['id'] as String,
      reporterId: json['reporter_id'] as String,
      bookId: json['book_id'] as String,
      reason: _parseReason(json['reason'] as String),
      description: json['description'] as String?,
      status: _parseStatus(json['status'] as String?),
      createdAt: DateTime.parse(json['created_at'] as String),
      reviewedAt: json['reviewed_at'] != null
          ? DateTime.parse(json['reviewed_at'] as String)
          : null,
      reviewedBy: json['reviewed_by'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'reporter_id': reporterId,
      'book_id': bookId,
      'reason': reason.name,
      'description': description,
      'status': status.name,
      'created_at': createdAt.toIso8601String(),
      'reviewed_at': reviewedAt?.toIso8601String(),
      'reviewed_by': reviewedBy,
    };
  }

  static ReportReason _parseReason(String reason) {
    switch (reason) {
      case 'copyright':
        return ReportReason.copyright;
      case 'inappropriate':
        return ReportReason.inappropriate;
      case 'spam':
        return ReportReason.spam;
      default:
        return ReportReason.other;
    }
  }

  static ReportStatus _parseStatus(String? status) {
    switch (status) {
      case 'reviewed':
        return ReportStatus.reviewed;
      case 'resolved':
        return ReportStatus.resolved;
      case 'dismissed':
        return ReportStatus.dismissed;
      default:
        return ReportStatus.pending;
    }
  }

  factory ReportModel.fromEntity(Report report) {
    return ReportModel(
      id: report.id,
      reporterId: report.reporterId,
      bookId: report.bookId,
      reason: report.reason,
      description: report.description,
      status: report.status,
      createdAt: report.createdAt,
      reviewedAt: report.reviewedAt,
      reviewedBy: report.reviewedBy,
    );
  }
}
