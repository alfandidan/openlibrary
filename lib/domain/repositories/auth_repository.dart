import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  /// Register a new user with email and password
  Future<Either<Failure, User>> register({
    required String email,
    required String password,
    String? name,
  });

  /// Login with email and password
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  });

  /// Logout current user
  Future<Either<Failure, void>> logout();

  /// Send password reset email
  Future<Either<Failure, void>> sendPasswordResetEmail(String email);

  /// Reset password with token
  Future<Either<Failure, void>> resetPassword({
    required String token,
    required String newPassword,
  });

  /// Get current authenticated user
  Future<Either<Failure, User?>> getCurrentUser();

  /// Check if user is authenticated
  Future<bool> isAuthenticated();

  /// Stream of auth state changes
  Stream<User?> get authStateChanges;

  /// Update user profile
  Future<Either<Failure, User>> updateProfile({
    String? name,
    String? avatarUrl,
  });

  /// Verify email with token
  Future<Either<Failure, void>> verifyEmail(String token);

  /// Resend verification email
  Future<Either<Failure, void>> resendVerificationEmail();
}
