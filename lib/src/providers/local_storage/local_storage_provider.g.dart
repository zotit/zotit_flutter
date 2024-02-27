// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_storage_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$localStorageHash() => r'14b9f7e594a630551e7204c454160d9732b0f729';

/// See also [LocalStorage].
@ProviderFor(LocalStorage)
final localStorageProvider =
    AutoDisposeAsyncNotifierProvider<LocalStorage, SharedPreferences>.internal(
  LocalStorage.new,
  name: r'localStorageProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$localStorageHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$LocalStorage = AutoDisposeAsyncNotifier<SharedPreferences>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
