import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../components/my_app_bar.dart';
import '../components/search_bar.dart';
import '../data/api_client.dart';
import 'detail_page.dart';

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
          child: ListView.custom(
            childrenDelegate: SliverChildBuilderDelegate(((context, index) {
              final page = index ~/ pageSize + 1;
              final indexInPage = index % pageSize;
              final repositories = ref.watch(fetchRepositoriesProvider(
                page: page,
                query: searchController.text,
              ));

              return repositories.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (_, __) => const Text('Error'),
                data: (repositories) {
                  if (indexInPage >= repositories.length) {
                    return null;
                  }

                  final repository = repositories[indexInPage];

                  return ListTile(
                    title: Text(repository.fullName ?? ''),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const DetailPage()),
                    ),
                  );
                },
              );
            })),
          ),
        ),
      ],
    );
  }
}
