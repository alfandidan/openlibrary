import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/home/presentation/pages/search_page.dart';
import '../../features/book_detail/presentation/pages/book_detail_page.dart';
import '../../features/reader/presentation/pages/epub_reader_page.dart';
import '../../features/reader/presentation/pages/pdf_reader_page.dart';
import '../../features/library/presentation/pages/library_page.dart';
import '../../features/upload/presentation/pages/upload_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/profile/presentation/pages/settings_page.dart';
import '../../features/admin/presentation/pages/admin_dashboard_page.dart';
import '../../shared/widgets/main_scaffold.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/login',
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final isAuthenticated = authState.status == AuthStatus.authenticated;
      final isAuthRoute = state.matchedLocation == '/login' ||
          state.matchedLocation == '/register' ||
          state.matchedLocation == '/forgot-password';

      if (!isAuthenticated && !isAuthRoute) {
        return '/login';
      }

      if (isAuthenticated && isAuthRoute) {
        return '/home';
      }

      return null;
    },
    routes: [
      // Auth Routes
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: '/forgot-password',
        name: 'forgot-password',
        builder: (context, state) => const ForgotPasswordPage(),
      ),

      // Main App Routes with Bottom Navigation
      ShellRoute(
        builder: (context, state, child) => MainScaffold(child: child),
        routes: [
          GoRoute(
            path: '/home',
            name: 'home',
            builder: (context, state) => const HomePage(),
          ),
          GoRoute(
            path: '/library',
            name: 'library',
            builder: (context, state) => const LibraryPage(),
          ),
          GoRoute(
            path: '/profile',
            name: 'profile',
            builder: (context, state) => const ProfilePage(),
          ),
        ],
      ),

      // Search
      GoRoute(
        path: '/search',
        name: 'search',
        builder: (context, state) => const SearchPage(),
      ),

      // Book Detail
      GoRoute(
        path: '/book/:id',
        name: 'book-detail',
        builder: (context, state) {
          final bookId = state.pathParameters['id']!;
          return BookDetailPage(bookId: bookId);
        },
      ),

      // Category Books
      GoRoute(
        path: '/category/:id',
        name: 'category',
        builder: (context, state) {
          final categoryId = state.pathParameters['id']!;
          return CategoryBooksPage(categoryId: categoryId);
        },
      ),

      // Reader Routes
      GoRoute(
        path: '/reader/epub/:id',
        name: 'epub-reader',
        builder: (context, state) {
          final bookId = state.pathParameters['id']!;
          return EpubReaderPage(bookId: bookId);
        },
      ),
      GoRoute(
        path: '/reader/pdf/:id',
        name: 'pdf-reader',
        builder: (context, state) {
          final bookId = state.pathParameters['id']!;
          return PdfReaderPage(bookId: bookId);
        },
      ),

      // Upload
      GoRoute(
        path: '/upload',
        name: 'upload',
        builder: (context, state) => const UploadPage(),
      ),

      // Settings
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => const SettingsPage(),
      ),

      // Admin Routes
      GoRoute(
        path: '/admin',
        name: 'admin',
        builder: (context, state) => const AdminDashboardPage(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64),
            const SizedBox(height: 16),
            Text('Halaman tidak ditemukan: ${state.matchedLocation}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go('/home'),
              child: const Text('Kembali ke Beranda'),
            ),
          ],
        ),
      ),
    ),
  );
});

// Placeholder for CategoryBooksPage
class CategoryBooksPage extends StatelessWidget {
  final String categoryId;

  const CategoryBooksPage({super.key, required this.categoryId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kategori')),
      body: Center(child: Text('Category: $categoryId')),
    );
  }
}
