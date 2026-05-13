import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/constants/app_constants.dart';

class SupabaseConfig {
  static SupabaseClient? _client;

  static Future<void> initialize() async {
    await Supabase.initialize(
      url: AppConstants.supabaseUrl,
      anonKey: AppConstants.supabaseAnonKey,
    );
    _client = Supabase.instance.client;
  }

  static SupabaseClient get client {
    if (_client == null) {
      throw Exception('Supabase not initialized. Call initialize() first.');
    }
    return _client!;
  }

  static GoTrueClient get auth => client.auth;
  static SupabaseStorageClient get storage => client.storage;

  static String get currentUserId {
    final user = auth.currentUser;
    if (user == null) {
      throw Exception('No authenticated user');
    }
    return user.id;
  }

  static bool get isAuthenticated => auth.currentUser != null;
}
