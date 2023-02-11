import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../components/my_app_bar.dart';
import '../components/search_bar.dart';
import '../data/api_client.dart';

part 'search_page.g.dart';

const pageSize = 20;

@riverpod
Future<List<Repository>> fetchRepositories(
  FetchRepositoriesRef ref, {
  required int page,
  String query = '',
}) async {
  final cancelToken = CancelToken();
  ref.onDispose(() {
    cancelToken.cancel();
  });
  if (query.isEmpty) {
    return [];
  }

  // debouncing the request.
  await Future<void>.delayed(const Duration(milliseconds: 250));
  if (cancelToken.isCancelled) {
    throw Exception('cancelled');
  }

  final client = ref.read(apiClientProvider);

  final response = await client.searchRepositories(
    query,
    pageSize,
    page,
    cancelToken,
  );
  return response.items;
}

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: MyAppBar(
        title: 'Sample counter',
      ),
      body: _Body(),
    );
  }
}

class _Body extends HookConsumerWidget {
  const _Body();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchController = useTextEditingController();
    useListenable(searchController);

    return Column(
      children: [
        SearchBar(controller: searchController),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () {
              ref.invalidate(fetchRepositoriesProvider);
              return ref.read(fetchRepositoriesProvider(
                      page: 1, query: searchController.text)
                  .future);
            },
            child: ListView.custom(
              childrenDelegate: SliverChildBuilderDelegate(((context, index) {
                final page = index ~/ pageSize + 1;
                final indexInPage = index % pageSize;
                final repositories = ref.watch(fetchRepositoriesProvider(
                  page: page,
                  query: searchController.text,
                ));

                return repositories.when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (_, __) => const Text('Error'),
                  data: (repositories) {
                    if (indexInPage >= repositories.length) {
                      return null;
                    }

                    final repository = repositories[indexInPage];

                    return _ListItem(
                      key: ValueKey(repository.fullName),
                      repository: repository,
                    );
                  },
                );
              })),
            ),
          ),
        ),
      ],
    );
  }
}

class _ListItem extends StatefulWidget {
  const _ListItem({
    required this.repository,
    super.key,
  });

  final Repository repository;

  @override
  State<_ListItem> createState() => _ListItemState();
}

class _ListItemState extends State<_ListItem>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ListTile(
      title: Text(widget.repository.fullName),
      onTap: () => GoRouter.of(context).go('/search/detail'),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
