// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'requirement_api.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$fetchRequirementsHash() => r'cd157fb82f182e5db5b62b48997f7473e5355f24';

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

/// See also [fetchRequirements].
@ProviderFor(fetchRequirements)
const fetchRequirementsProvider = FetchRequirementsFamily();

/// See also [fetchRequirements].
class FetchRequirementsFamily extends Family<AsyncValue<List<Requirement>>> {
  /// See also [fetchRequirements].
  const FetchRequirementsFamily();

  /// See also [fetchRequirements].
  FetchRequirementsProvider call({
    int pageNo = 1,
    int limit = 10,
  }) {
    return FetchRequirementsProvider(
      pageNo: pageNo,
      limit: limit,
    );
  }

  @override
  FetchRequirementsProvider getProviderOverride(
    covariant FetchRequirementsProvider provider,
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
  String? get name => r'fetchRequirementsProvider';
}

/// See also [fetchRequirements].
class FetchRequirementsProvider
    extends AutoDisposeFutureProvider<List<Requirement>> {
  /// See also [fetchRequirements].
  FetchRequirementsProvider({
    int pageNo = 1,
    int limit = 10,
  }) : this._internal(
          (ref) => fetchRequirements(
            ref as FetchRequirementsRef,
            pageNo: pageNo,
            limit: limit,
          ),
          from: fetchRequirementsProvider,
          name: r'fetchRequirementsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$fetchRequirementsHash,
          dependencies: FetchRequirementsFamily._dependencies,
          allTransitiveDependencies:
              FetchRequirementsFamily._allTransitiveDependencies,
          pageNo: pageNo,
          limit: limit,
        );

  FetchRequirementsProvider._internal(
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
    FutureOr<List<Requirement>> Function(FetchRequirementsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FetchRequirementsProvider._internal(
        (ref) => create(ref as FetchRequirementsRef),
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
  AutoDisposeFutureProviderElement<List<Requirement>> createElement() {
    return _FetchRequirementsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FetchRequirementsProvider &&
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

mixin FetchRequirementsRef on AutoDisposeFutureProviderRef<List<Requirement>> {
  /// The parameter `pageNo` of this provider.
  int get pageNo;

  /// The parameter `limit` of this provider.
  int get limit;
}

class _FetchRequirementsProviderElement
    extends AutoDisposeFutureProviderElement<List<Requirement>>
    with FetchRequirementsRef {
  _FetchRequirementsProviderElement(super.provider);

  @override
  int get pageNo => (origin as FetchRequirementsProvider).pageNo;
  @override
  int get limit => (origin as FetchRequirementsProvider).limit;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
