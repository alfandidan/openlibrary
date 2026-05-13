import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final user = authState.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Profile Header
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: AppColors.primary,
                  backgroundImage: user?.avatarUrl != null
                      ? NetworkImage(user!.avatarUrl!)
                      : null,
                  child: user?.avatarUrl == null
                      ? Text(
                          user?.name?.substring(0, 1).toUpperCase() ?? 'U',
                          style: const TextStyle(
                            fontSize: 36,
                            color: Colors.white,
                          ),
                        )
                      : null,
                ),
                const SizedBox(height: 16),
                Text(
                  user?.name ?? 'User',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 4),
                Text(
                  user?.email ?? '',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).textTheme.bodySmall?.color,
                      ),
                ),
                const SizedBox(height: 8),
                Chip(
                  label: Text(user?.role.name.toUpperCase() ?? 'USER'),
                  backgroundColor: AppColors.primary.withOpacity(0.1),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Menu Items
          _MenuSection(
            title: 'Akun',
            items: [
              _MenuItem(
                icon: Icons.person_outline,
                title: 'Edit Profil',
                onTap: () {
                  // TODO: Navigate to edit profile
                },
              ),
              _MenuItem(
                icon: Icons.lock_outline,
                title: 'Ubah Password',
                onTap: () {
                  // TODO: Navigate to change password
                },
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Author Section (if user is author)
          if (user?.isAuthor ?? false) ...[
            _MenuSection(
              title: 'Penulis',
              items: [
                _MenuItem(
                  icon: Icons.upload_file,
                  title: 'Upload Buku',
                  onTap: () => context.push('/upload'),
                ),
                _MenuItem(
                  icon: Icons.dashboard_outlined,
                  title: 'Dashboard Penulis',
                  onTap: () {
                    // TODO: Navigate to author dashboard
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],

          // Admin Section (if user is admin)
          if (user?.isAdmin ?? false) ...[
            _MenuSection(
              title: 'Admin',
              items: [
                _MenuItem(
                  icon: Icons.admin_panel_settings,
                  title: 'Dashboard Admin',
                  onTap: () => context.push('/admin'),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],

          _MenuSection(
            title: 'Lainnya',
            items: [
              _MenuItem(
                icon: Icons.help_outline,
                title: 'Bantuan',
                onTap: () {
                  // TODO: Navigate to help
                },
              ),
              _MenuItem(
                icon: Icons.info_outline,
                title: 'Tentang Aplikasi',
                onTap: () {
                  showAboutDialog(
                    context: context,
                    applicationName: 'OpenLibrary',
                    applicationVersion: '1.0.0',
                    applicationLegalese: '© 2024 OpenLibrary',
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Logout Button
          OutlinedButton.icon(
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Keluar'),
                  content: const Text('Apakah Anda yakin ingin keluar?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Batal'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Keluar'),
                    ),
                  ],
                ),
              );

              if (confirm == true) {
                await ref.read(authProvider.notifier).logout();
                if (context.mounted) {
                  context.go('/login');
                }
              }
            },
            icon: const Icon(Icons.logout, color: AppColors.error),
            label: const Text('Keluar', style: TextStyle(color: AppColors.error)),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.error),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuSection extends StatelessWidget {
  final String title;
  final List<_MenuItem> items;

  const _MenuSection({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
        ),
        const SizedBox(height: 8),
        Card(
          child: Column(
            children: items,
          ),
        ),
      ],
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
