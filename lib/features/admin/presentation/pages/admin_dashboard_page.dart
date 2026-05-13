import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';

class AdminDashboardPage extends ConsumerStatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  ConsumerState<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends ConsumerState<AdminDashboardPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: 'Overview'),
            Tab(text: 'Moderasi'),
            Tab(text: 'Laporan'),
            Tab(text: 'Kategori'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          _OverviewTab(),
          _ModerationTab(),
          _ReportsTab(),
          _CategoriesTab(),
        ],
      ),
    );
  }
}

class _OverviewTab extends StatelessWidget {
  const _OverviewTab();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stats Cards
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  title: 'Total Pengguna',
                  value: '1,234',
                  icon: Icons.people,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  title: 'Total Buku',
                  value: '567',
                  icon: Icons.book,
                  color: AppColors.secondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  title: 'Total Penulis',
                  value: '89',
                  icon: Icons.edit,
                  color: AppColors.warning,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  title: 'Pembaca Aktif',
                  value: '456',
                  icon: Icons.trending_up,
                  color: AppColors.info,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Top Books
          Text(
            'Buku Terpopuler',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          Card(
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 5,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    child: Text('${index + 1}'),
                  ),
                  title: Text('Buku Populer ${index + 1}'),
                  subtitle: Text('${1000 - index * 100} pembaca'),
                  trailing: const Icon(Icons.chevron_right),
                );
              },
            ),
          ),
          const SizedBox(height: 24),

          // Top Authors
          Text(
            'Penulis Terpopuler',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          Card(
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 5,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppColors.primary,
                    child: Text(
                      'A${index + 1}',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text('Penulis ${index + 1}'),
                  subtitle: Text('${50 - index * 5} buku'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 12),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

class _ModerationTab extends StatelessWidget {
  const _ModerationTab();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 60,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppColors.dividerLight,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Icon(Icons.book),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Buku Pending ${index + 1}',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'oleh Penulis ${index + 1}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Diupload: ${DateTime.now().subtract(Duration(days: index)).toString().substring(0, 10)}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _showRejectDialog(context),
                        icon: const Icon(Icons.close, color: AppColors.error),
                        label: const Text(
                          'Tolak',
                          style: TextStyle(color: AppColors.error),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Buku berhasil disetujui'),
                              backgroundColor: AppColors.success,
                            ),
                          );
                        },
                        icon: const Icon(Icons.check),
                        label: const Text('Setujui'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showRejectDialog(BuildContext context) {
    final reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tolak Buku'),
        content: TextField(
          controller: reasonController,
          decoration: const InputDecoration(
            labelText: 'Alasan Penolakan',
            hintText: 'Minimal 10 karakter',
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              if (reasonController.text.length >= 10) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Buku berhasil ditolak'),
                    backgroundColor: AppColors.error,
                  ),
                );
              }
            },
            child: const Text('Tolak'),
          ),
        ],
      ),
    );
  }
}

class _ReportsTab extends StatelessWidget {
  const _ReportsTab();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      itemBuilder: (context, index) {
        final reasons = ['Hak Cipta', 'Konten Tidak Pantas', 'Spam', 'Lainnya'];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: const CircleAvatar(
              backgroundColor: AppColors.warning,
              child: Icon(Icons.report, color: Colors.white),
            ),
            title: Text('Laporan untuk Buku ${index + 1}'),
            subtitle: Text('Alasan: ${reasons[index % reasons.length]}'),
            trailing: PopupMenuButton(
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'review',
                  child: Text('Tinjau'),
                ),
                const PopupMenuItem(
                  value: 'dismiss',
                  child: Text('Abaikan'),
                ),
                const PopupMenuItem(
                  value: 'action',
                  child: Text('Ambil Tindakan'),
                ),
              ],
              onSelected: (value) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Aksi: $value')),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class _CategoriesTab extends StatelessWidget {
  const _CategoriesTab();

  @override
  Widget build(BuildContext context) {
    final categories = [
      'Fiksi',
      'Non-Fiksi',
      'Teknologi',
      'Bisnis',
      'Sains',
      'Sejarah',
      'Biografi',
    ];

    return Scaffold(
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: const Icon(Icons.category),
              title: Text(categories[index]),
              subtitle: Text('${(index + 1) * 10} buku'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      // TODO: Edit category
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: AppColors.error),
                    onPressed: () {
                      // TODO: Delete category
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddCategoryDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddCategoryDialog(BuildContext context) {
    final nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tambah Kategori'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(
            labelText: 'Nama Kategori',
            hintText: '2-50 karakter',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              if (nameController.text.length >= 2) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Kategori berhasil ditambahkan'),
                    backgroundColor: AppColors.success,
                  ),
                );
              }
            },
            child: const Text('Tambah'),
          ),
        ],
      ),
    );
  }
}
