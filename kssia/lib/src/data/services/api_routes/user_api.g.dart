// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_api.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$fetchUserDetailsHash() => r'8546032eb9a76ed770b4149f5926fc1a34e91649';

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

/// See also [fetchUserDetails].
@ProviderFor(fetchUserDetails)
const fetchUserDetailsProvider = FetchUserDetailsFamily();

/// See also [fetchUserDetails].
class FetchUserDetailsFamily extends Family<AsyncValue<UserModel>> {
  /// See also [fetchUserDetails].
  const FetchUserDetailsFamily();

  /// See also [fetchUserDetails].
  FetchUserDetailsProvider call(
    String token,
    String userId,
  ) {
    return FetchUserDetailsProvider(
      token,
      userId,
    );
  }

  @override
  FetchUserDetailsProvider getProviderOverride(
    covariant FetchUserDetailsProvider provider,
  ) {
    return call(
      provider.token,
      provider.userId,
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
  String? get name => r'fetchUserDetailsProvider';
}

/// See also [fetchUserDetails].
class FetchUserDetailsProvider extends AutoDisposeFutureProvider<UserModel> {
  /// See also [fetchUserDetails].
  FetchUserDetailsProvider(
    String token,
    String userId,
  ) : this._internal(
          (ref) => fetchUserDetails(
            ref as FetchUserDetailsRef,
            token,
            userId,
          ),
          from: fetchUserDetailsProvider,
          name: r'fetchUserDetailsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$fetchUserDetailsHash,
          dependencies: FetchUserDetailsFamily._dependencies,
          allTransitiveDependencies:
              FetchUserDetailsFamily._allTransitiveDependencies,
          token: token,
          userId: userId,
        );

  FetchUserDetailsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.token,
    required this.userId,
  }) : super.internal();

  final String token;
  final String userId;

  @override
  Override overrideWith(
    FutureOr<UserModel> Function(FetchUserDetailsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FetchUserDetailsProvider._internal(
        (ref) => create(ref as FetchUserDetailsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        token: token,
        userId: userId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<UserModel> createElement() {
    return _FetchUserDetailsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FetchUserDetailsProvider &&
        other.token == token &&
        other.userId == userId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, token.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin FetchUserDetailsRef on AutoDisposeFutureProviderRef<UserModel> {
  /// The parameter `token` of this provider.
  String get token;

  /// The parameter `userId` of this provider.
  String get userId;
}

class _FetchUserDetailsProviderElement
    extends AutoDisposeFutureProviderElement<UserModel>
    with FetchUserDetailsRef {
  _FetchUserDetailsProviderElement(super.provider);

  @override
  String get token => (origin as FetchUserDetailsProvider).token;
  @override
  String get userId => (origin as FetchUserDetailsProvider).userId;
}

String _$fetchUsersHash() => r'4671c31e68f2e465ba953796cb24a3a7f30dd6f6';

/// See also [fetchUsers].
@ProviderFor(fetchUsers)
const fetchUsersProvider = FetchUsersFamily();

/// See also [fetchUsers].
class FetchUsersFamily extends Family<AsyncValue<List<UserModel>>> {
  /// See also [fetchUsers].
  const FetchUsersFamily();

  /// See also [fetchUsers].
  FetchUsersProvider call({
    int pageNo = 1,
    int limit = 20,
  }) {
    return FetchUsersProvider(
      pageNo: pageNo,
      limit: limit,
    );
  }

  @override
  FetchUsersProvider getProviderOverride(
    covariant FetchUsersProvider provider,
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
  String? get name => r'fetchUsersProvider';
}

/// See also [fetchUsers].
class FetchUsersProvider extends AutoDisposeFutureProvider<List<UserModel>> {
  /// See also [fetchUsers].
  FetchUsersProvider({
    int pageNo = 1,
    int limit = 20,
  }) : this._internal(
          (ref) => fetchUsers(
            ref as FetchUsersRef,
            pageNo: pageNo,
            limit: limit,
          ),
          from: fetchUsersProvider,
          name: r'fetchUsersProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$fetchUsersHash,
          dependencies: FetchUsersFamily._dependencies,
          allTransitiveDependencies:
              FetchUsersFamily._allTransitiveDependencies,
          pageNo: pageNo,
          limit: limit,
        );

  FetchUsersProvider._internal(
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
    FutureOr<List<UserModel>> Function(FetchUsersRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FetchUsersProvider._internal(
        (ref) => create(ref as FetchUsersRef),
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
  AutoDisposeFutureProviderElement<List<UserModel>> createElement() {
    return _FetchUsersProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FetchUsersProvider &&
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

mixin FetchUsersRef on AutoDisposeFutureProviderRef<List<UserModel>> {
  /// The parameter `pageNo` of this provider.
  int get pageNo;

  /// The parameter `limit` of this provider.
  int get limit;
}

class _FetchUsersProviderElement
    extends AutoDisposeFutureProviderElement<List<UserModel>>
    with FetchUsersRef {
  _FetchUsersProviderElement(super.provider);

  @override
  int get pageNo => (origin as FetchUsersProvider).pageNo;
  @override
  int get limit => (origin as FetchUsersProvider).limit;
}

String _$fetchUserRequirementsHash() =>
    r'70a98749b03496377a7b52cf7796680eed1ce6ea';

/// See also [fetchUserRequirements].
@ProviderFor(fetchUserRequirements)
const fetchUserRequirementsProvider = FetchUserRequirementsFamily();

/// See also [fetchUserRequirements].
class FetchUserRequirementsFamily
    extends Family<AsyncValue<List<UserRequirementModel>>> {
  /// See also [fetchUserRequirements].
  const FetchUserRequirementsFamily();

  /// See also [fetchUserRequirements].
  FetchUserRequirementsProvider call(
    String token,
  ) {
    return FetchUserRequirementsProvider(
      token,
    );
  }

  @override
  FetchUserRequirementsProvider getProviderOverride(
    covariant FetchUserRequirementsProvider provider,
  ) {
    return call(
      provider.token,
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
  String? get name => r'fetchUserRequirementsProvider';
}

/// See also [fetchUserRequirements].
class FetchUserRequirementsProvider
    extends AutoDisposeFutureProvider<List<UserRequirementModel>> {
  /// See also [fetchUserRequirements].
  FetchUserRequirementsProvider(
    String token,
  ) : this._internal(
          (ref) => fetchUserRequirements(
            ref as FetchUserRequirementsRef,
            token,
          ),
          from: fetchUserRequirementsProvider,
          name: r'fetchUserRequirementsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$fetchUserRequirementsHash,
          dependencies: FetchUserRequirementsFamily._dependencies,
          allTransitiveDependencies:
              FetchUserRequirementsFamily._allTransitiveDependencies,
          token: token,
        );

  FetchUserRequirementsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.token,
  }) : super.internal();

  final String token;

  @override
  Override overrideWith(
    FutureOr<List<UserRequirementModel>> Function(
            FetchUserRequirementsRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FetchUserRequirementsProvider._internal(
        (ref) => create(ref as FetchUserRequirementsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        token: token,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<UserRequirementModel>> createElement() {
    return _FetchUserRequirementsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FetchUserRequirementsProvider && other.token == token;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, token.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin FetchUserRequirementsRef
    on AutoDisposeFutureProviderRef<List<UserRequirementModel>> {
  /// The parameter `token` of this provider.
  String get token;
}

class _FetchUserRequirementsProviderElement
    extends AutoDisposeFutureProviderElement<List<UserRequirementModel>>
    with FetchUserRequirementsRef {
  _FetchUserRequirementsProviderElement(super.provider);

  @override
  String get token => (origin as FetchUserRequirementsProvider).token;
}

String _$fetchUserRsvpdEventsHash() =>
    r'c91662b4f4ddf1078b38ac20423258640a576294';

/// See also [fetchUserRsvpdEvents].
@ProviderFor(fetchUserRsvpdEvents)
final fetchUserRsvpdEventsProvider =
    AutoDisposeFutureProvider<List<Event>>.internal(
  fetchUserRsvpdEvents,
  name: r'fetchUserRsvpdEventsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$fetchUserRsvpdEventsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef FetchUserRsvpdEventsRef = AutoDisposeFutureProviderRef<List<Event>>;
String _$getUserPaymentsHash() => r'e019316ed5c55be972e9e2921e5c44327407a345';

/// See also [getUserPayments].
@ProviderFor(getUserPayments)
final getUserPaymentsProvider =
    AutoDisposeFutureProvider<List<Subscription>>.internal(
  getUserPayments,
  name: r'getUserPaymentsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getUserPaymentsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef GetUserPaymentsRef = AutoDisposeFutureProviderRef<List<Subscription>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
