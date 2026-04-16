import 'dart:async';

import 'package:flutter/material.dart';
import 'package:orb_test_app/src/core/api_client/api_client.dart';
import 'package:orb_test_app/src/core/init/app_dependencies.dart';
import 'package:orb_test_app/src/core/storage/key_value_storage.dart';
import 'package:orb_test_app/src/core/storage/shared_preferences_key_value_storage.dart';
import 'package:orb_test_app/src/features/auth/data/auth_repository.dart';
import 'package:orb_test_app/src/features/auth/domain/auth_gate.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppDependenciesScope extends StatefulWidget {
  const AppDependenciesScope({required this.child, super.key});

  final Widget child;

  static AppScopeData of(BuildContext context, {bool listen = false}) =>
      _InheritedAppDependenciesScope.of(context, listen: listen).data;

  @override
  State<AppDependenciesScope> createState() => _AppDependenciesScopeState();
}

class _AppDependenciesScopeState extends State<AppDependenciesScope> {
  AppScopeData? _data;

  @override
  void initState() {
    super.initState();
    unawaited(_bootstrap());
  }

  Future<void> _bootstrap() async {
    final prefs = await SharedPreferences.getInstance();
    final keyValueStorage = SharedPreferencesKeyValueStorage(prefs);
    final dependencies = AppDependencies(keyValueStorage: keyValueStorage);
    await dependencies.initialize();

    if (!mounted) {
      await dependencies.dispose();
      return;
    }

    setState(() {
      _data = AppScopeData(dependencies: dependencies);
    });
  }

  @override
  void dispose() {
    final data = _data;
    if (data != null) {
      unawaited(data.dependencies.dispose());
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final data = _data;
    if (data == null) {
      return const _AppDependenciesSplash();
    }

    return _InheritedAppDependenciesScope(data: data, child: widget.child);
  }
}

final class AppScopeData {
  const AppScopeData({required this.dependencies});

  final AppDependencies dependencies;
}

class _AppDependenciesSplash extends StatelessWidget {
  const _AppDependenciesSplash();

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(body: Center(child: CircularProgressIndicator())),
    );
  }
}

class _InheritedAppDependenciesScope extends InheritedWidget {
  const _InheritedAppDependenciesScope({required this.data, required super.child});

  final AppScopeData data;

  static _InheritedAppDependenciesScope? maybeOf(BuildContext context, {bool listen = true}) =>
      listen
      ? context.dependOnInheritedWidgetOfExactType<_InheritedAppDependenciesScope>()
      : context.getInheritedWidgetOfExactType<_InheritedAppDependenciesScope>();

  static Never _notFoundInheritedWidgetOfExactType() => throw ArgumentError(
    'Out of scope, not found inherited widget a _InheritedAppDependenciesScope of the exact type',
    'out_of_scope',
  );

  static _InheritedAppDependenciesScope of(BuildContext context, {bool listen = true}) =>
      maybeOf(context, listen: listen) ?? _notFoundInheritedWidgetOfExactType();

  @override
  bool updateShouldNotify(_InheritedAppDependenciesScope oldWidget) => false;
}

extension AppDependenciesScopeContextX on BuildContext {
  AppDependencies get dependencies => AppDependenciesScope.of(this).dependencies;
  ApiClient get apiClient => AppDependenciesScope.of(this).dependencies.apiClient;
  KeyValueStorage get keyValueStorage => AppDependenciesScope.of(this).dependencies.keyValueStorage;
  AuthRepository get authRepository => AppDependenciesScope.of(this).dependencies.authRepository;
  AuthGate get authGate => AppDependenciesScope.of(this).dependencies.authGate;
}
