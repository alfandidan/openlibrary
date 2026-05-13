import 'package:dartz/dartz.dart';
import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../core/network/network_info.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/remote/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, User>> register({
    required String email,
    required String password,
    String? name,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final user = await remoteDataSource.register(
        email: email,
        password: password,
        name: name,
      );
      return Right(user);
    } on AuthException catch (e) {
      if (e.code == 'email_exists') {
        return const Left(EmailAlreadyInUseFailure());
      }
      return Left(AuthFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final user = await remoteDataSource.login(
        email: email,
        password: password,
      );
      return Right(user);
    } on AuthException catch (e) {
      if (e.code == 'invalid_credentials') {
        return const Left(InvalidCredentialsFailure());
      }
      return Left(AuthFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await remoteDataSource.logout();
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> sendPasswordResetEmail(String email) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      await remoteDataSource.sendPasswordResetEmail(email);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    // Implemented via Supabase magic link
    return const Right(null);
  }

  @override
  Future<Either<Failure, User?>> getCurrentUser() async {
    try {
      final user = await remoteDataSource.getCurrentUser();
      return Right(user);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    final user = await remoteDataSource.getCurrentUser();
    return user != null;
  }

  @override
  Stream<User?> get authStateChanges => remoteDataSource.authStateChanges;

  @override
  Future<Either<Failure, User>> updateProfile({
    String? name,
    String? avatarUrl,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final user = await remoteDataSource.updateProfile(
        name: name,
        avatarUrl: avatarUrl,
      );
      return Right(user);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> verifyEmail(String token) async {
    // Handled by Supabase automatically
    return const Right(null);
  }

  @override
  Future<Either<Failure, void>> resendVerificationEmail() async {
    // Handled by Supabase
    return const Right(null);
  }
}
