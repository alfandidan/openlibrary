import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  final String? code;

  const Failure({required this.message, this.code});

  @override
  List<Object?> get props => [message, code];
}

// Auth Failures
class AuthFailure extends Failure {
  const AuthFailure({required super.message, super.code});
}

class InvalidCredentialsFailure extends AuthFailure {
  const InvalidCredentialsFailure()
      : super(message: 'Email atau password salah');
}

class EmailAlreadyInUseFailure extends AuthFailure {
  const EmailAlreadyInUseFailure()
      : super(message: 'Email sudah digunakan');
}

class AccountLockedFailure extends AuthFailure {
  final int remainingMinutes;

  const AccountLockedFailure({required this.remainingMinutes})
      : super(message: 'Akun terkunci. Coba lagi dalam $remainingMinutes menit');
}

class SessionExpiredFailure extends AuthFailure {
  const SessionExpiredFailure()
      : super(message: 'Sesi telah berakhir. Silakan login kembali');
}

class UserBannedFailure extends AuthFailure {
  const UserBannedFailure()
      : super(message: 'Akun Anda telah diblokir');
}

// Network Failures
class NetworkFailure extends Failure {
  const NetworkFailure({super.message = 'Tidak ada koneksi internet', super.code});
}

class ServerFailure extends Failure {
  const ServerFailure({super.message = 'Layanan sedang tidak tersedia', super.code});
}

class TimeoutFailure extends Failure {
  const TimeoutFailure({super.message = 'Koneksi timeout', super.code});
}

// Data Failures
class CacheFailure extends Failure {
  const CacheFailure({super.message = 'Gagal mengakses data lokal', super.code});
}

class NotFoundFailure extends Failure {
  const NotFoundFailure({super.message = 'Data tidak ditemukan', super.code});
}

class ValidationFailure extends Failure {
  const ValidationFailure({required super.message, super.code});
}

// Book Failures
class BookLoadFailure extends Failure {
  const BookLoadFailure({super.message = 'Gagal memuat buku', super.code});
}

class BookCorruptedFailure extends Failure {
  const BookCorruptedFailure({super.message = 'File buku rusak atau tidak dapat dibuka', super.code});
}

class InsufficientStorageFailure extends Failure {
  const InsufficientStorageFailure({super.message = 'Ruang penyimpanan tidak cukup', super.code});
}

// Upload Failures
class FileTooLargeFailure extends Failure {
  const FileTooLargeFailure({super.message = 'Ukuran file terlalu besar', super.code});
}

class InvalidFileFormatFailure extends Failure {
  const InvalidFileFormatFailure({super.message = 'Format file tidak didukung', super.code});
}

class UploadFailure extends Failure {
  const UploadFailure({super.message = 'Gagal mengunggah file', super.code});
}

// Permission Failures
class PermissionDeniedFailure extends Failure {
  const PermissionDeniedFailure({super.message = 'Akses ditolak', super.code});
}

// Report Failures
class AlreadyReportedFailure extends Failure {
  const AlreadyReportedFailure({super.message = 'Anda sudah melaporkan buku ini', super.code});
}
