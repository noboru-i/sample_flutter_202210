import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sample_flutter_202210/components/search_bar.dart';
import 'package:sample_flutter_202210/pages/detail_page.dart';

import '../components/my_app_bar.dart';

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
            child: ListView(
              children: [
                ListTile(
                  title: const Text('foo'),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const DetailPage()),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
