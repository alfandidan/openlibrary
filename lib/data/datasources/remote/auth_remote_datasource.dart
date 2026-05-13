import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/constants/api_endpoints.dart';
import '../../core/errors/exceptions.dart';
import '../../core/network/supabase_config.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> register({
    required String email,
    required String password,
    String? name,
  });

  Future<UserModel> login({
    required String email,
    required String password,
  });

  Future<void> logout();

  Future<void> sendPasswordResetEmail(String email);

  Future<UserModel?> getCurrentUser();

  Stream<UserModel?> get authStateChanges;

  Future<UserModel> updateProfile({
    String? name,
    String? avatarUrl,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient client;

  AuthRemoteDataSourceImpl({required this.client});

  @override
  Future<UserModel> register({
    required String email,
    required String password,
    String? name,
  }) async {
    try {
      final response = await client.auth.signUp(
        email: email,
        password: password,
        data: {'name': name},
      );

      if (response.user == null) {
        throw AuthException(message: 'Registration failed');
      }

      // Create user profile in users table
      final userData = {
        'id': response.user!.id,
        'email': email,
        'name': name,
        'role': 'user',
        'is_banned': false,
        'created_at': DateTime.now().toIso8601String(),
      };

      await client.from(ApiEndpoints.usersTable).insert(userData);

      return UserModel.fromJson(userData);
    } on AuthException catch (e) {
      if (e.message.contains('already registered')) {
        throw AuthException(message: 'Email sudah digunakan', code: 'email_exists');
      }
      throw AuthException(message: e.message);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw AuthException(message: 'Login failed');
      }

      final userData = await client
          .from(ApiEndpoints.usersTable)
          .select()
          .eq('id', response.user!.id)
          .single();

      return UserModel.fromJson(userData);
    } on AuthException {
      throw AuthException(message: 'Email atau password salah', code: 'invalid_credentials');
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> logout() async {
    try {
      await client.auth.signOut();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await client.auth.resetPasswordForEmail(email);
    } catch (e) {
      // Don't reveal if email exists or not
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final user = client.auth.currentUser;
      if (user == null) return null;

      final userData = await client
          .from(ApiEndpoints.usersTable)
          .select()
          .eq('id', user.id)
          .single();

      return UserModel.fromJson(userData);
    } catch (e) {
      return null;
    }
  }

  @override
  Stream<UserModel?> get authStateChanges {
    return client.auth.onAuthStateChange.asyncMap((event) async {
      if (event.session?.user == null) return null;

      try {
        final userData = await client
            .from(ApiEndpoints.usersTable)
            .select()
            .eq('id', event.session!.user.id)
            .single();

        return UserModel.fromJson(userData);
      } catch (e) {
        return null;
      }
    });
  }

  @override
  Future<UserModel> updateProfile({
    String? name,
    String? avatarUrl,
  }) async {
    try {
      final userId = SupabaseConfig.currentUserId;
      final updates = <String, dynamic>{
        'updated_at': DateTime.now().toIso8601String(),
      };

      if (name != null) updates['name'] = name;
      if (avatarUrl != null) updates['avatar_url'] = avatarUrl;

      final userData = await client
          .from(ApiEndpoints.usersTable)
          .update(updates)
          .eq('id', userId)
          .select()
          .single();

      return UserModel.fromJson(userData);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
