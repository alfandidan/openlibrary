import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/widgets/book_card.dart';
import '../../../../shared/widgets/category_chip.dart';
import '../../../../shared/widgets/shimmer_loading.dart';
import '../providers/home_provider.dart';
import '../widgets/featured_carousel.dart';
import '../widgets/section_header.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('OpenLibrary'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => context.push('/search'),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(homeProvider.notifier).refresh(),
        child: homeState.isLoading && homeState.featuredBooks.isEmpty
            ? const _LoadingView()
            : homeState.errorMessage != null && homeState.featuredBooks.isEmpty
                ? _ErrorView(
                    message: homeState.errorMessage!,
                    onRetry: () => ref.read(homeProvider.notifier).refresh(),
                  )
                : _ContentView(homeState: homeState),
      ),
    );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Featured shimmer
          ShimmerLoading(
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Categories shimmer
          ShimmerLoading(
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Books shimmer
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.65,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: 4,
            itemBuilder: (context, index) => ShimmerLoading(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
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
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
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
  final HomeState homeState;

  const _ContentView({required this.homeState});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(bottom: 24),
      children: [
        // Featured Books
        if (homeState.featuredBooks.isNotEmpty) ...[
          const SectionHeader(title: 'Pilihan Editor'),
          FeaturedCarousel(books: homeState.featuredBooks),
          const SizedBox(height: 24),
        ],

        // Categories
        if (homeState.categories.isNotEmpty) ...[
          const SectionHeader(title: 'Kategori'),
          SizedBox(
            height: 44,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: homeState.categories.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final category = homeState.categories[index];
                return CategoryChip(
                  label: category.name,
                  onTap: () => context.push('/category/${category.id}'),
                );
              },
            ),
          ),
          const SizedBox(height: 24),
        ],

        // Recent Books
        if (homeState.recentBooks.isNotEmpty) ...[
          SectionHeader(
            title: 'Baru Ditambahkan',
            onSeeAll: () => context.push('/books'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.65,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: homeState.recentBooks.length > 6
                  ? 6
                  : homeState.recentBooks.length,
              itemBuilder: (context, index) {
                final book = homeState.recentBooks[index];
                return BookCard(
                  book: book,
                  onTap: () => context.push('/book/${book.id}'),
                );
              },
            ),
          ),
        ],
      ],
    );
  }
}
