import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../data/datasources/local/library_local_datasource.dart';
import '../../../../shared/providers/providers.dart';
import '../../../../core/constants/enums.dart' show ThemeMode;

enum AppThemeMode { light, dark, system }

class ThemeNotifier extends StateNotifier<AppThemeMode> {
  final LibraryLocalDataSource localDataSource;

  ThemeNotifier(this.localDataSource) : super(AppThemeMode.system) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final savedTheme = await localDataSource.getAppTheme();
    switch (savedTheme.name) {
      case 'light':
        state = AppThemeMode.light;
        break;
      case 'dark':
        state = AppThemeMode.dark;
        break;
      default:
        state = AppThemeMode.system;
    }
  }

  Future<void> setTheme(AppThemeMode mode) async {
    state = mode;
    switch (mode) {
      case AppThemeMode.light:
        await localDataSource.saveAppTheme(ThemeMode.light);
        break;
      case AppThemeMode.dark:
        await localDataSource.saveAppTheme(ThemeMode.dark);
        break;
      case AppThemeMode.system:
        await localDataSource.saveAppTheme(ThemeMode.system);
        break;
    }
  }
}

final themeModeProvider =
    StateNotifierProvider<ThemeNotifier, AppThemeMode>((ref) {
  return ThemeNotifier(ref.watch(libraryLocalDataSourceProvider));
});
