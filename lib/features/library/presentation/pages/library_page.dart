import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/widgets/book_card.dart';
import '../providers/library_provider.dart';

class LibraryPage extends ConsumerStatefulWidget {
  const LibraryPage({super.key});

  @override
  ConsumerState<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends ConsumerState<LibraryPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
        title: const Text('Perpustakaan'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Favorit'),
            Tab(text: 'Bookmark'),
            Tab(text: 'Riwayat'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          _FavoritesTab(),
          _BookmarksTab(),
          _HistoryTab(),
        ],
      ),
    );
  }
}

class _FavoritesTab extends ConsumerWidget {
  const _FavoritesTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(favoritesProvider);

    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.books.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_border,
              size: 64,
              color: Theme.of(context).disabledColor,
            ),
            const SizedBox(height: 16),
            Text(
              'Belum ada buku favorit',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Tambahkan buku ke favorit untuk melihatnya di sini',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).disabledColor,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(favoritesProvider.notifier).refresh(),
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.65,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: state.books.length,
        itemBuilder: (context, index) {
          final book = state.books[index];
          return BookCard(
            book: book,
            onTap: () => context.push('/book/${book.id}'),
          );
        },
      ),
    );
  }
}

class _BookmarksTab extends ConsumerWidget {
  const _BookmarksTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(bookmarksProvider);

    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.bookmarks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.bookmark_border,
              size: 64,
              color: Theme.of(context).disabledColor,
            ),
            const SizedBox(height: 16),
            Text(
              'Belum ada bookmark',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Tandai halaman saat membaca untuk melihatnya di sini',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).disabledColor,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(bookmarksProvider.notifier).refresh(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: state.bookmarks.length,
        itemBuilder: (context, index) {
          final bookmark = state.bookmarks[index];
          return Card(
            child: ListTile(
              leading: const Icon(Icons.bookmark),
              title: Text('Halaman ${bookmark.pageNumber}'),
              subtitle: bookmark.note != null ? Text(bookmark.note!) : null,
              trailing: IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: () {
                  ref.read(bookmarksProvider.notifier).deleteBookmark(bookmark.id);
                },
              ),
              onTap: () {
                // Navigate to reader at bookmark position
                context.push('/book/${bookmark.bookId}');
              },
            ),
          );
        },
      ),
    );
  }
}

class _HistoryTab extends ConsumerWidget {
  const _HistoryTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(readingHistoryProvider);

    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.history.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.history,
              size: 64,
              color: Theme.of(context).disabledColor,
            ),
            const SizedBox(height: 16),
            Text(
              'Belum ada riwayat bacaan',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Buku yang kamu baca akan muncul di sini',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).disabledColor,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(readingHistoryProvider.notifier).refresh(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: state.history.length,
        itemBuilder: (context, index) {
          final history = state.history[index];
          return Card(
            child: ListTile(
              leading: CircularProgressIndicator(
                value: history.progress / 100,
                backgroundColor: Theme.of(context).dividerColor,
              ),
              title: Text('Book ID: ${history.bookId}'),
              subtitle: Text('Progress: ${history.progress}%'),
              trailing: Text('Hal. ${history.lastPage}'),
              onTap: () => context.push('/book/${history.bookId}'),
            ),
          );
        },
      ),
    );
  }
}
