import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'app.dart';

void main() {
  runApp(
    ProviderScope(
      child: App(),
    ),
  );
}

var productsProvider = Provider<List<int>>((ref) {
  return [0, 1, 2];
});

ProviderBase<int> provider = Provider((ref) => 0);

Provider<int> provider2 = Provider((ref) => 0);

final Provider<int> provider3 = Provider((ref) => 0);
