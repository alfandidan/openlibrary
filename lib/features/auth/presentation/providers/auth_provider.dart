import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../domain/entities/user.dart';
import '../../../../shared/providers/providers.dart';

// Auth State
enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class AuthState {
  final AuthStatus status;
  final User? user;
  final String? errorMessage;

  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.errorMessage,
  });

  AuthState copyWith({
    AuthStatus? status,
    User? user,
    String? errorMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage,
    );
  }
}

// Auth Notifier
class AuthNotifier extends StateNotifier<AuthState> {
  final Ref ref;

  AuthNotifier(this.ref) : super(const AuthState()) {
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    state = state.copyWith(status: AuthStatus.loading);

    final result = await ref.read(authRepositoryProvider).getCurrentUser();

    result.fold(
      (failure) => state = state.copyWith(status: AuthStatus.unauthenticated),
      (user) {
        if (user != null) {
          state = state.copyWith(status: AuthStatus.authenticated, user: user);
        } else {
          state = state.copyWith(status: AuthStatus.unauthenticated);
        }
      },
    );
  }

  Future<bool> login({required String email, required String password}) async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);

    final result = await ref.read(authRepositoryProvider).login(
          email: email,
          password: password,
        );

    return result.fold(
      (failure) {
        state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: failure.message,
        );
        return false;
      },
      (user) {
        state = state.copyWith(status: AuthStatus.authenticated, user: user);
        return true;
      },
    );
  }

  Future<bool> register({
    required String email,
    required String password,
    String? name,
  }) async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);

    final result = await ref.read(authRepositoryProvider).register(
          email: email,
          password: password,
          name: name,
        );

    return result.fold(
      (failure) {
        state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: failure.message,
        );
        return false;
      },
      (user) {
        state = state.copyWith(status: AuthStatus.authenticated, user: user);
        return true;
      },
    );
  }

  Future<void> logout() async {
    await ref.read(authRepositoryProvider).logout();
    state = const AuthState(status: AuthStatus.unauthenticated);
  }

  Future<bool> sendPasswordResetEmail(String email) async {
    final result =
        await ref.read(authRepositoryProvider).sendPasswordResetEmail(email);

    return result.fold(
      (failure) => false,
      (_) => true,
    );
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}

// Provider
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref);
});

// Convenience providers
final currentUserProvider = Provider<User?>((ref) {
  return ref.watch(authProvider).user;
});

final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).status == AuthStatus.authenticated;
});

final isAdminProvider = Provider<bool>((ref) {
  return ref.watch(currentUserProvider)?.isAdmin ?? false;
});

final isAuthorProvider = Provider<bool>((ref) {
  return ref.watch(currentUserProvider)?.isAuthor ?? false;
});
