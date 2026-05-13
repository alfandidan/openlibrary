import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../../core/network/network_info.dart';
import '../../core/network/supabase_config.dart';
import '../../data/datasources/local/book_local_datasource.dart';
import '../../data/datasources/local/library_local_datasource.dart';
import '../../data/datasources/remote/auth_remote_datasource.dart';
import '../../data/datasources/remote/book_remote_datasource.dart';
import '../../data/datasources/remote/library_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/repositories/book_repository_impl.dart';
import '../../data/repositories/library_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/book_repository.dart';
import '../../domain/repositories/library_repository.dart';

// External Dependencies
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences must be overridden');
});

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio();
  dio.options.connectTimeout = const Duration(seconds: 30);
  dio.options.receiveTimeout = const Duration(seconds: 30);
  return dio;
});

final uuidProvider = Provider<Uuid>((ref) => const Uuid());

final connectivityProvider = Provider<Connectivity>((ref) => Connectivity());

// Network
final networkInfoProvider = Provider<NetworkInfo>((ref) {
  return NetworkInfoImpl(connectivity: ref.watch(connectivityProvider));
});

// Data Sources - Remote
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSourceImpl(client: SupabaseConfig.client);
});

final bookRemoteDataSourceProvider = Provider<BookRemoteDataSource>((ref) {
  return BookRemoteDataSourceImpl(
    client: SupabaseConfig.client,
    dio: ref.watch(dioProvider),
  );
});

final libraryRemoteDataSourceProvider = Provider<LibraryRemoteDataSource>((ref) {
  return LibraryRemoteDataSourceImpl(
    client: SupabaseConfig.client,
    uuid: ref.watch(uuidProvider),
  );
});

// Data Sources - Local
final bookLocalDataSourceProvider = Provider<BookLocalDataSource>((ref) {
  return BookLocalDataSourceImpl(prefs: ref.watch(sharedPreferencesProvider));
});

final libraryLocalDataSourceProvider = Provider<LibraryLocalDataSource>((ref) {
  return LibraryLocalDataSourceImpl(prefs: ref.watch(sharedPreferencesProvider));
});

// Repositories
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    remoteDataSource: ref.watch(authRemoteDataSourceProvider),
    networkInfo: ref.watch(networkInfoProvider),
  );
});

final bookRepositoryProvider = Provider<BookRepository>((ref) {
  return BookRepositoryImpl(
    remoteDataSource: ref.watch(bookRemoteDataSourceProvider),
    localDataSource: ref.watch(bookLocalDataSourceProvider),
    networkInfo: ref.watch(networkInfoProvider),
  );
});

final libraryRepositoryProvider = Provider<LibraryRepository>((ref) {
  return LibraryRepositoryImpl(
    remoteDataSource: ref.watch(libraryRemoteDataSourceProvider),
    localDataSource: ref.watch(libraryLocalDataSourceProvider),
    bookRemoteDataSource: ref.watch(bookRemoteDataSourceProvider),
    networkInfo: ref.watch(networkInfoProvider),
  );
});
