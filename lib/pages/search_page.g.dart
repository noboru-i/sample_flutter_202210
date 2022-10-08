// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_page.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// ignore_for_file: avoid_private_typedef_functions, non_constant_identifier_names, subtype_of_sealed_class, invalid_use_of_internal_member, unused_element, constant_identifier_names, unnecessary_raw_strings, library_private_types_in_public_api

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

String $fetchRepositoriesHash() => r'97545d9e47a3ce47d63debd5d30b14459092fe8a';

/// See also [fetchRepositories].
class FetchRepositoriesProvider
    extends AutoDisposeFutureProvider<List<Repository>> {
  FetchRepositoriesProvider({
    required this.page,
    this.query = '',
  }) : super(
          (ref) => fetchRepositories(
            ref,
            page: page,
            query: query,
          ),
          from: fetchRepositoriesProvider,
          name: r'fetchRepositoriesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : $fetchRepositoriesHash,
        );

  final int page;
  final String query;

  @override
  bool operator ==(Object other) {
    return other is FetchRepositoriesProvider &&
        other.page == page &&
        other.query == query;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, page.hashCode);
    hash = _SystemHash.combine(hash, query.hashCode);

    return _SystemHash.finish(hash);
  }
}

typedef FetchRepositoriesRef = AutoDisposeFutureProviderRef<List<Repository>>;

/// See also [fetchRepositories].
final fetchRepositoriesProvider = FetchRepositoriesFamily();

class FetchRepositoriesFamily extends Family<AsyncValue<List<Repository>>> {
  FetchRepositoriesFamily();

  FetchRepositoriesProvider call({
    required int page,
    String query = '',
  }) {
    return FetchRepositoriesProvider(
      page: page,
      query: query,
    );
  }

  @override
  AutoDisposeFutureProvider<List<Repository>> getProviderOverride(
    covariant FetchRepositoriesProvider provider,
  ) {
    return call(
      page: provider.page,
      query: provider.query,
    );
  }

  @override
  List<ProviderOrFamily>? get allTransitiveDependencies => null;

  @override
  List<ProviderOrFamily>? get dependencies => null;

  @override
  String? get name => r'fetchRepositoriesProvider';
}
