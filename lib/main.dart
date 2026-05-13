import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/network/supabase_config.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'shared/providers/providers.dart';
import 'features/profile/presentation/providers/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize Supabase
  await SupabaseConfig.initialize();

  // Initialize SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      ],
      child: const OpenLibraryApp(),
    ),
  );
}

class OpenLibraryApp extends ConsumerWidget {
  const OpenLibraryApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'OpenLibrary',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _mapThemeMode(themeMode),
      routerConfig: router,
    );
  }

  ThemeMode _mapThemeMode(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
      case AppThemeMode.system:
        return ThemeMode.system;
    }
  }
}
