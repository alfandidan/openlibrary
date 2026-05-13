import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/theme_provider.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan'),
      ),
      body: ListView(
        children: [
          // Theme Section
          _SectionHeader(title: 'Tampilan'),
          ListTile(
            leading: const Icon(Icons.brightness_6),
            title: const Text('Tema'),
            subtitle: Text(_getThemeLabel(currentTheme)),
            onTap: () => _showThemeDialog(context, ref, currentTheme),
          ),
          const Divider(),

          // Reader Settings
          _SectionHeader(title: 'Pembaca'),
          ListTile(
            leading: const Icon(Icons.text_fields),
            title: const Text('Ukuran Font Default'),
            subtitle: const Text('16px'),
            onTap: () {
              // TODO: Show font size picker
            },
          ),
          ListTile(
            leading: const Icon(Icons.swipe),
            title: const Text('Mode Navigasi'),
            subtitle: const Text('Geser Horizontal'),
            onTap: () {
              // TODO: Show navigation mode picker
            },
          ),
          const Divider(),

          // Storage Section
          _SectionHeader(title: 'Penyimpanan'),
          ListTile(
            leading: const Icon(Icons.folder),
            title: const Text('Buku Terunduh'),
            subtitle: const Text('0 buku (0 MB)'),
            onTap: () {
              // TODO: Navigate to downloads management
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete_outline),
            title: const Text('Hapus Cache'),
            subtitle: const Text('Hapus data cache aplikasi'),
            onTap: () => _showClearCacheDialog(context),
          ),
          const Divider(),

          // About Section
          _SectionHeader(title: 'Tentang'),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('Versi Aplikasi'),
            subtitle: const Text('1.0.0'),
          ),
          ListTile(
            leading: const Icon(Icons.description_outlined),
            title: const Text('Kebijakan Privasi'),
            onTap: () {
              // TODO: Open privacy policy
            },
          ),
          ListTile(
            leading: const Icon(Icons.gavel_outlined),
            title: const Text('Syarat dan Ketentuan'),
            onTap: () {
              // TODO: Open terms
            },
          ),
        ],
      ),
    );
  }

  String _getThemeLabel(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.light:
        return 'Terang';
      case AppThemeMode.dark:
        return 'Gelap';
      case AppThemeMode.system:
        return 'Ikuti Sistem';
    }
  }

  void _showThemeDialog(
    BuildContext context,
    WidgetRef ref,
    AppThemeMode currentTheme,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pilih Tema'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<AppThemeMode>(
              title: const Text('Terang'),
              value: AppThemeMode.light,
              groupValue: currentTheme,
              onChanged: (value) {
                ref.read(themeModeProvider.notifier).setTheme(value!);
                Navigator.pop(context);
              },
            ),
            RadioListTile<AppThemeMode>(
              title: const Text('Gelap'),
              value: AppThemeMode.dark,
              groupValue: currentTheme,
              onChanged: (value) {
                ref.read(themeModeProvider.notifier).setTheme(value!);
                Navigator.pop(context);
              },
            ),
            RadioListTile<AppThemeMode>(
              title: const Text('Ikuti Sistem'),
              value: AppThemeMode.system,
              groupValue: currentTheme,
              onChanged: (value) {
                ref.read(themeModeProvider.notifier).setTheme(value!);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showClearCacheDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Cache'),
        content: const Text(
          'Ini akan menghapus semua data cache. Buku yang terunduh tidak akan terpengaruh.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              // TODO: Clear cache
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Cache berhasil dihapus')),
              );
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
      ),
    );
  }
}
