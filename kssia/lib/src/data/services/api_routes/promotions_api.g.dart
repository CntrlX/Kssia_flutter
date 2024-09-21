// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'promotions_api.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$fetchPromotionsHash() => r'599633bb6f7458fb7080c78cda7cd21ffb5e8d3b';

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

/// See also [fetchPromotions].
@ProviderFor(fetchPromotions)
const fetchPromotionsProvider = FetchPromotionsFamily();

/// See also [fetchPromotions].
class FetchPromotionsFamily extends Family<AsyncValue<List<Promotion>>> {
  /// See also [fetchPromotions].
  const FetchPromotionsFamily();

  /// See also [fetchPromotions].
  FetchPromotionsProvider call({
    int pageNo = 1,
    int limit = 10,
  }) {
    return FetchPromotionsProvider(
      pageNo: pageNo,
      limit: limit,
    );
  }

  @override
  FetchPromotionsProvider getProviderOverride(
    covariant FetchPromotionsProvider provider,
  ) {
    return call(
      pageNo: provider.pageNo,
      limit: provider.limit,
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
  String? get name => r'fetchPromotionsProvider';
}

/// See also [fetchPromotions].
class FetchPromotionsProvider
    extends AutoDisposeFutureProvider<List<Promotion>> {
  /// See also [fetchPromotions].
  FetchPromotionsProvider({
    int pageNo = 1,
    int limit = 10,
  }) : this._internal(
          (ref) => fetchPromotions(
            ref as FetchPromotionsRef,
            pageNo: pageNo,
            limit: limit,
          ),
          from: fetchPromotionsProvider,
          name: r'fetchPromotionsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$fetchPromotionsHash,
          dependencies: FetchPromotionsFamily._dependencies,
          allTransitiveDependencies:
              FetchPromotionsFamily._allTransitiveDependencies,
          pageNo: pageNo,
          limit: limit,
        );

  FetchPromotionsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.pageNo,
    required this.limit,
  }) : super.internal();

  final int pageNo;
  final int limit;

  @override
  Override overrideWith(
    FutureOr<List<Promotion>> Function(FetchPromotionsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FetchPromotionsProvider._internal(
        (ref) => create(ref as FetchPromotionsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        pageNo: pageNo,
        limit: limit,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Promotion>> createElement() {
    return _FetchPromotionsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FetchPromotionsProvider &&
        other.pageNo == pageNo &&
        other.limit == limit;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, pageNo.hashCode);
    hash = _SystemHash.combine(hash, limit.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin FetchPromotionsRef on AutoDisposeFutureProviderRef<List<Promotion>> {
  /// The parameter `pageNo` of this provider.
  int get pageNo;

  /// The parameter `limit` of this provider.
  int get limit;
}

class _FetchPromotionsProviderElement
    extends AutoDisposeFutureProviderElement<List<Promotion>>
    with FetchPromotionsRef {
  _FetchPromotionsProviderElement(super.provider);

  @override
  int get pageNo => (origin as FetchPromotionsProvider).pageNo;
  @override
  int get limit => (origin as FetchPromotionsProvider).limit;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
