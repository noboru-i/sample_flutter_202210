import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sample_flutter_202210/components/search_bar.dart';
import 'package:sample_flutter_202210/data/api_client.dart';
import 'package:sample_flutter_202210/pages/detail_page.dart';

import '../components/my_app_bar.dart';

part 'search_page.g.dart';

@riverpod
Future<List<Repository>> fetchRepositories(FetchRepositoriesRef ref) async {
  final dio = Dio();
  dio.options.headers['Accept'] = 'application/vnd.github.v3+json';
  final client = ApiClient(dio);

  final response = await client.searchRepositories('sample');
  return response.items;
}

class SearchPage extends HookConsumerWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchController = useTextEditingController();
    useListenable(searchController);

    return Scaffold(
      appBar: const MyAppBar(
        title: 'Sample counter',
      ),
      body: Column(
        children: [
          SearchBar(controller: searchController),
          Expanded(
            child: ListView.custom(
              childrenDelegate: SliverChildBuilderDelegate(((context, index) {
                final repositories = ref.watch(fetchRepositoriesProvider);

                return repositories.when(
                  loading: () => const CircularProgressIndicator(),
                  error: (_, __) => const Text('Error'),
                  data: (repositories) {
                    if (index >= repositories.length) return null;

                    final repository = repositories[index];

                    return ListTile(
                      title: Text(repository.name),
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
      ),
    );
  }
}
