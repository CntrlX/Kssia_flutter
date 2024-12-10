// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'products_api.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$fetchProductsHash() => r'9d7296a3bdef3866fea060494b61eebacafb0c65';

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

/// See also [fetchProducts].
@ProviderFor(fetchProducts)
const fetchProductsProvider = FetchProductsFamily();

/// See also [fetchProducts].
class FetchProductsFamily extends Family<AsyncValue<List<Product>>> {
  /// See also [fetchProducts].
  const FetchProductsFamily();

  /// See also [fetchProducts].
  FetchProductsProvider call({
    int pageNo = 1,
    int limit = 10,
    String? search,
    String? category,
    String? subcategory,
  }) {
    return FetchProductsProvider(
      pageNo: pageNo,
      limit: limit,
      search: search,
      category: category,
      subcategory: subcategory,
    );
  }

  @override
  FetchProductsProvider getProviderOverride(
    covariant FetchProductsProvider provider,
  ) {
    return call(
      pageNo: provider.pageNo,
      limit: provider.limit,
      search: provider.search,
      category: provider.category,
      subcategory: provider.subcategory,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'fetchProductsProvider';
}

/// See also [fetchProducts].
class FetchProductsProvider extends AutoDisposeFutureProvider<List<Product>> {
  /// See also [fetchProducts].
  FetchProductsProvider({
    int pageNo = 1,
    int limit = 10,
    String? search,
    String? category,
    String? subcategory,
  }) : this._internal(
          (ref) => fetchProducts(
            ref as FetchProductsRef,
            pageNo: pageNo,
            limit: limit,
            search: search,
            category: category,
            subcategory: subcategory,
          ),
          from: fetchProductsProvider,
          name: r'fetchProductsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$fetchProductsHash,
          dependencies: FetchProductsFamily._dependencies,
          allTransitiveDependencies:
              FetchProductsFamily._allTransitiveDependencies,
          pageNo: pageNo,
          limit: limit,
          search: search,
          category: category,
          subcategory: subcategory,
        );

  FetchProductsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.pageNo,
    required this.limit,
    required this.search,
    required this.category,
    required this.subcategory,
  }) : super.internal();

  final int pageNo;
  final int limit;
  final String? search;
  final String? category;
  final String? subcategory;

  @override
  Override overrideWith(
    FutureOr<List<Product>> Function(FetchProductsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FetchProductsProvider._internal(
        (ref) => create(ref as FetchProductsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        pageNo: pageNo,
        limit: limit,
        search: search,
        category: category,
        subcategory: subcategory,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Product>> createElement() {
    return _FetchProductsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FetchProductsProvider &&
        other.pageNo == pageNo &&
        other.limit == limit &&
        other.search == search &&
        other.category == category &&
        other.subcategory == subcategory;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, pageNo.hashCode);
    hash = _SystemHash.combine(hash, limit.hashCode);
    hash = _SystemHash.combine(hash, search.hashCode);
    hash = _SystemHash.combine(hash, category.hashCode);
    hash = _SystemHash.combine(hash, subcategory.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin FetchProductsRef on AutoDisposeFutureProviderRef<List<Product>> {
  /// The parameter `pageNo` of this provider.
  int get pageNo;

  /// The parameter `limit` of this provider.
  int get limit;

  /// The parameter `search` of this provider.
  String? get search;

  /// The parameter `category` of this provider.
  String? get category;

  /// The parameter `subcategory` of this provider.
  String? get subcategory;
}

class _FetchProductsProviderElement
    extends AutoDisposeFutureProviderElement<List<Product>>
    with FetchProductsRef {
  _FetchProductsProviderElement(super.provider);

  @override
  int get pageNo => (origin as FetchProductsProvider).pageNo;
  @override
  int get limit => (origin as FetchProductsProvider).limit;
  @override
  String? get search => (origin as FetchProductsProvider).search;
  @override
  String? get category => (origin as FetchProductsProvider).category;
  @override
  String? get subcategory => (origin as FetchProductsProvider).subcategory;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
