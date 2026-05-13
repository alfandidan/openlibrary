import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/constants/enums.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/shimmer_loading.dart';
import '../providers/book_detail_provider.dart';

class BookDetailPage extends ConsumerWidget {
  final String bookId;

  const BookDetailPage({super.key, required this.bookId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(bookDetailProvider(bookId));

    return Scaffold(
      body: state.isLoading
          ? const _LoadingView()
          : state.errorMessage != null
              ? _ErrorView(
                  message: state.errorMessage!,
                  onRetry: () =>
                      ref.read(bookDetailProvider(bookId).notifier).loadBook(),
                )
              : state.book != null
                  ? _ContentView(
                      state: state,
                      onRead: () => _openReader(context, state),
                      onFavorite: () => ref
                          .read(bookDetailProvider(bookId).notifier)
                          .toggleFavorite(),
                    )
                  : const SizedBox.shrink(),
    );
  }

  void _openReader(BuildContext context, BookDetailState state) {
    final book = state.book!;
    if (book.isEpub) {
      context.push('/reader/epub/${book.id}');
    } else {
      context.push('/reader/pdf/${book.id}');
    }
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 300,
          flexibleSpace: ShimmerLoading(
            child: Container(color: Colors.white),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerLoading(
                  child: Container(
                    height: 24,
                    width: 200,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                ShimmerLoading(
                  child: Container(
                    height: 16,
                    width: 150,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 24),
                ShimmerLoading(
                  child: Container(
                    height: 100,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Coba Lagi'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ContentView extends StatelessWidget {
  final BookDetailState state;
  final VoidCallback onRead;
  final VoidCallback onFavorite;

  const _ContentView({
    required this.state,
    required this.onRead,
    required this.onFavorite,
  });

  @override
  Widget build(BuildContext context) {
    final book = state.book!;

    return CustomScrollView(
      slivers: [
        // App Bar with Cover
        SliverAppBar(
          expandedHeight: 300,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            background: Stack(
              fit: StackFit.expand,
              children: [
                if (book.coverUrl != null)
                  CachedNetworkImage(
                    imageUrl: book.coverUrl!,
                    fit: BoxFit.cover,
                  )
                else
                  Container(
                    color: AppColors.primary.withOpacity(0.3),
                    child: const Icon(Icons.book, size: 80, color: Colors.white),
                  ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.7),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(
                state.isFavorite ? Icons.favorite : Icons.favorite_border,
                color: state.isFavorite ? AppColors.error : null,
              ),
              onPressed: onFavorite,
            ),
            IconButton(
              icon: const Icon(Icons.share),
              onPressed: () {
                // TODO: Implement share
              },
            ),
          ],
        ),

        // Content
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  book.title,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),

                // Author
                if (book.author != null)
                  Text(
                    'oleh ${book.author}',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).textTheme.bodySmall?.color,
                        ),
                  ),
                const SizedBox(height: 16),

                // Stats Row
                Row(
                  children: [
                    _StatChip(
                      icon: Icons.visibility,
                      label: NumberFormatter.formatCompact(book.totalReads),
                    ),
                    const SizedBox(width: 16),
                    _StatChip(
                      icon: Icons.download,
                      label: NumberFormatter.formatCompact(book.totalDownloads),
                    ),
                    const SizedBox(width: 16),
                    _StatChip(
                      icon: Icons.book,
                      label: book.format == BookFormat.epub ? 'EPUB' : 'PDF',
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Read Button
                CustomButton(
                  text: state.readingProgress != null
                      ? 'Lanjutkan Membaca (${state.readingProgress!.progress}%)'
                      : 'Mulai Membaca',
                  onPressed: onRead,
                  icon: Icons.menu_book,
                ),
                const SizedBox(height: 24),

                // Description
                if (book.description != null) ...[
                  Text(
                    'Deskripsi',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    book.description!,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                ],

                // Tags
                if (book.tags.isNotEmpty) ...[
                  Text(
                    'Tags',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: book.tags
                        .map((tag) => Chip(label: Text(tag)))
                        .toList(),
                  ),
                  const SizedBox(height: 24),
                ],

                // Book Info
                Text(
                  'Informasi',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                _InfoRow(label: 'Format', value: book.format == BookFormat.epub ? 'EPUB' : 'PDF'),
                if (book.categoryName != null)
                  _InfoRow(label: 'Kategori', value: book.categoryName!),
                if (book.publishYear != null)
                  _InfoRow(label: 'Tahun Terbit', value: '${book.publishYear}'),
                if (book.pageCount != null)
                  _InfoRow(label: 'Jumlah Halaman', value: '${book.pageCount}'),
                _InfoRow(
                  label: 'Lisensi',
                  value: _getLicenseLabel(book.licenseType),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _StatChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: Theme.of(context).textTheme.bodySmall?.color),
        const SizedBox(width: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}

String _getLicenseLabel(LicenseType type) {
  switch (type) {
    case LicenseType.creativeCommons:
      return 'Creative Commons';
    case LicenseType.publicDomain:
      return 'Public Domain';
    case LicenseType.custom:
      return 'Custom';
  }
}
