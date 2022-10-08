
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final counterProvider = StateProvider((_) => 0);

class SearchPage extends HookConsumerWidget {
  const SearchPage({super.key});

  void _incrementCounter(WidgetRef ref) {
    ref.read(counterProvider.notifier).update((count) => count + 1);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(counterProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sample counter'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$count',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _incrementCounter(ref),
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
