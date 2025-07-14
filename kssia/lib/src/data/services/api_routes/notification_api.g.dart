// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_api.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$notificationApiServiceHash() =>
    r'18f4757e7e9e58d198fc139465d580a945732fa7';

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

/// See also [notificationApiService].
@ProviderFor(notificationApiService)
const notificationApiServiceProvider = NotificationApiServiceFamily();

/// See also [notificationApiService].
class NotificationApiServiceFamily extends Family<NotificationApiService> {
  /// See also [notificationApiService].
  const NotificationApiServiceFamily();

  /// See also [notificationApiService].
  NotificationApiServiceProvider call(
    String token,
  ) {
    return NotificationApiServiceProvider(
      token,
    );
  }

  @override
  NotificationApiServiceProvider getProviderOverride(
    covariant NotificationApiServiceProvider provider,
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
  String? get name => r'notificationApiServiceProvider';
}

/// See also [notificationApiService].
class NotificationApiServiceProvider
    extends AutoDisposeProvider<NotificationApiService> {
  /// See also [notificationApiService].
  NotificationApiServiceProvider(
    String token,
  ) : this._internal(
          (ref) => notificationApiService(
            ref as NotificationApiServiceRef,
            token,
          ),
          from: notificationApiServiceProvider,
          name: r'notificationApiServiceProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$notificationApiServiceHash,
          dependencies: NotificationApiServiceFamily._dependencies,
          allTransitiveDependencies:
              NotificationApiServiceFamily._allTransitiveDependencies,
          token: token,
        );

  NotificationApiServiceProvider._internal(
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
    NotificationApiService Function(NotificationApiServiceRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: NotificationApiServiceProvider._internal(
        (ref) => create(ref as NotificationApiServiceRef),
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
  AutoDisposeProviderElement<NotificationApiService> createElement() {
    return _NotificationApiServiceProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is NotificationApiServiceProvider && other.token == token;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, token.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin NotificationApiServiceRef
    on AutoDisposeProviderRef<NotificationApiService> {
  /// The parameter `token` of this provider.
  String get token;
}

class _NotificationApiServiceProviderElement
    extends AutoDisposeProviderElement<NotificationApiService>
    with NotificationApiServiceRef {
  _NotificationApiServiceProviderElement(super.provider);

  @override
  String get token => (origin as NotificationApiServiceProvider).token;
}

String _$fetchUnreadNotificationsHash() =>
    r'c35facf17fdc2f84beda0962e0347b13b0602c3b';

/// See also [fetchUnreadNotifications].
@ProviderFor(fetchUnreadNotifications)
const fetchUnreadNotificationsProvider = FetchUnreadNotificationsFamily();

/// See also [fetchUnreadNotifications].
class FetchUnreadNotificationsFamily
    extends Family<AsyncValue<List<NotificationModel>>> {
  /// See also [fetchUnreadNotifications].
  const FetchUnreadNotificationsFamily();

  /// See also [fetchUnreadNotifications].
  FetchUnreadNotificationsProvider call(
    String token,
    String userId,
  ) {
    return FetchUnreadNotificationsProvider(
      token,
      userId,
    );
  }

  @override
  FetchUnreadNotificationsProvider getProviderOverride(
    covariant FetchUnreadNotificationsProvider provider,
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
  String? get name => r'fetchUnreadNotificationsProvider';
}

/// See also [fetchUnreadNotifications].
class FetchUnreadNotificationsProvider
    extends AutoDisposeFutureProvider<List<NotificationModel>> {
  /// See also [fetchUnreadNotifications].
  FetchUnreadNotificationsProvider(
    String token,
    String userId,
  ) : this._internal(
          (ref) => fetchUnreadNotifications(
            ref as FetchUnreadNotificationsRef,
            token,
            userId,
          ),
          from: fetchUnreadNotificationsProvider,
          name: r'fetchUnreadNotificationsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$fetchUnreadNotificationsHash,
          dependencies: FetchUnreadNotificationsFamily._dependencies,
          allTransitiveDependencies:
              FetchUnreadNotificationsFamily._allTransitiveDependencies,
          token: token,
          userId: userId,
        );

  FetchUnreadNotificationsProvider._internal(
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
    FutureOr<List<NotificationModel>> Function(
            FetchUnreadNotificationsRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FetchUnreadNotificationsProvider._internal(
        (ref) => create(ref as FetchUnreadNotificationsRef),
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
  AutoDisposeFutureProviderElement<List<NotificationModel>> createElement() {
    return _FetchUnreadNotificationsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FetchUnreadNotificationsProvider &&
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

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FetchUnreadNotificationsRef
    on AutoDisposeFutureProviderRef<List<NotificationModel>> {
  /// The parameter `token` of this provider.
  String get token;

  /// The parameter `userId` of this provider.
  String get userId;
}

class _FetchUnreadNotificationsProviderElement
    extends AutoDisposeFutureProviderElement<List<NotificationModel>>
    with FetchUnreadNotificationsRef {
  _FetchUnreadNotificationsProviderElement(super.provider);

  @override
  String get token => (origin as FetchUnreadNotificationsProvider).token;
  @override
  String get userId => (origin as FetchUnreadNotificationsProvider).userId;
}

String _$fetchReadNotificationsHash() =>
    r'e74057960888b2730705616ba197eb4812cceb1d';

/// See also [fetchReadNotifications].
@ProviderFor(fetchReadNotifications)
const fetchReadNotificationsProvider = FetchReadNotificationsFamily();

/// See also [fetchReadNotifications].
class FetchReadNotificationsFamily
    extends Family<AsyncValue<List<NotificationModel>>> {
  /// See also [fetchReadNotifications].
  const FetchReadNotificationsFamily();

  /// See also [fetchReadNotifications].
  FetchReadNotificationsProvider call(
    String token,
    String userId,
  ) {
    return FetchReadNotificationsProvider(
      token,
      userId,
    );
  }

  @override
  FetchReadNotificationsProvider getProviderOverride(
    covariant FetchReadNotificationsProvider provider,
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
  String? get name => r'fetchReadNotificationsProvider';
}

/// See also [fetchReadNotifications].
class FetchReadNotificationsProvider
    extends AutoDisposeFutureProvider<List<NotificationModel>> {
  /// See also [fetchReadNotifications].
  FetchReadNotificationsProvider(
    String token,
    String userId,
  ) : this._internal(
          (ref) => fetchReadNotifications(
            ref as FetchReadNotificationsRef,
            token,
            userId,
          ),
          from: fetchReadNotificationsProvider,
          name: r'fetchReadNotificationsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$fetchReadNotificationsHash,
          dependencies: FetchReadNotificationsFamily._dependencies,
          allTransitiveDependencies:
              FetchReadNotificationsFamily._allTransitiveDependencies,
          token: token,
          userId: userId,
        );

  FetchReadNotificationsProvider._internal(
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
    FutureOr<List<NotificationModel>> Function(
            FetchReadNotificationsRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FetchReadNotificationsProvider._internal(
        (ref) => create(ref as FetchReadNotificationsRef),
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
  AutoDisposeFutureProviderElement<List<NotificationModel>> createElement() {
    return _FetchReadNotificationsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FetchReadNotificationsProvider &&
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

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FetchReadNotificationsRef
    on AutoDisposeFutureProviderRef<List<NotificationModel>> {
  /// The parameter `token` of this provider.
  String get token;

  /// The parameter `userId` of this provider.
  String get userId;
}

class _FetchReadNotificationsProviderElement
    extends AutoDisposeFutureProviderElement<List<NotificationModel>>
    with FetchReadNotificationsRef {
  _FetchReadNotificationsProviderElement(super.provider);

  @override
  String get token => (origin as FetchReadNotificationsProvider).token;
  @override
  String get userId => (origin as FetchReadNotificationsProvider).userId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
