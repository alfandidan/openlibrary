import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/widgets/book_card.dart';
import '../providers/home_provider.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(searchProvider.notifier).loadMore();
    }
  }

  void _onSearch(String query) {
    ref.read(searchProvider.notifier).search(query);
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(searchProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cari Buku'),
      ),
      body: Column(
        children: [
          // Search Field
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Cari judul, penulis, atau deskripsi...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          ref.read(searchProvider.notifier).clear();
                        },
                      )
                    : null,
              ),
              onChanged: _onSearch,
              textInputAction: TextInputAction.search,
              onSubmitted: _onSearch,
            ),
          ),

          // Results
          Expanded(
            child: searchState.query.isEmpty
                ? const _EmptySearchView()
                : searchState.isLoading && searchState.results.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : searchState.results.isEmpty
                        ? const _NoResultsView()
                        : _ResultsView(
                            searchState: searchState,
                            scrollController: _scrollController,
                          ),
          ),
        ],
      ),
    );
  }
}

class _EmptySearchView extends StatelessWidget {
  const _EmptySearchView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search,
            size: 64,
            color: Theme.of(context).disabledColor,
          ),
          const SizedBox(height: 16),
          Text(
            'Cari buku favoritmu',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).disabledColor,
                ),
          ),
        ],
      ),
    );
  }
}

class _NoResultsView extends StatelessWidget {
  const _NoResultsView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Theme.of(context).disabledColor,
          ),
          const SizedBox(height: 16),
          Text(
            'Tidak ada hasil ditemukan',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Coba kata kunci lain',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).disabledColor,
                ),
          ),
        ],
      ),
    );
  }
}

class _ResultsView extends StatelessWidget {
  final SearchState searchState;
  final ScrollController scrollController;

  const _ResultsView({
    required this.searchState,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      controller: scrollController,
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.65,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: searchState.results.length + (searchState.hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= searchState.results.length) {
          return const Center(child: CircularProgressIndicator());
        }

        final book = searchState.results[index];
        return BookCard(
          book: book,
          onTap: () => context.push('/book/${book.id}'),
        );
      },
    );
  }
}
