import 'dart:async';

import 'package:flutter/material.dart';
import 'package:orb_test_app/src/core/init/app_dependencies.dart';
import 'package:orb_test_app/src/core/storage/key_value_storage.dart';
import 'package:orb_test_app/src/core/storage/shared_preferences_key_value_storage.dart';
import 'package:orb_test_app/src/features/auth/data/auth_repository.dart';
import 'package:orb_test_app/src/features/auth/domain/auth_gate.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RootScope extends StatefulWidget {
  const RootScope({required this.child, super.key});

  final Widget child;

  @override
  State<RootScope> createState() => RootScopeState();

  static RootScopeState of(BuildContext context, {bool listen = false}) =>
      _InheritedRootScope.of(context, listen: listen).data;
}

class RootScopeState extends State<RootScope> {
  AppDependencies? _dependencies;

  AppDependencies get dependencies => _require();
  KeyValueStorage get keyValueStorage => _require().keyValueStorage;
  AuthRepository get authRepository => _require().authRepository;
  AuthGate get authGate => _require().authGate;

  AppDependencies _require() {
    final deps = _dependencies;
    if (deps == null) {
      throw StateError('AppDependencies accessed before RootScope finished bootstrapping');
    }
    return deps;
  }

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
    setState(() => _dependencies = dependencies);
  }

  @override
  void dispose() {
    final deps = _dependencies;
    if (deps != null) unawaited(deps.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_dependencies == null) return const _RootScopeSplash();
    return _InheritedRootScope(data: this, child: widget.child);
  }
}

class _RootScopeSplash extends StatelessWidget {
  const _RootScopeSplash();

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(body: Center(child: CircularProgressIndicator())),
    );
  }
}

class _InheritedRootScope extends InheritedWidget {
  const _InheritedRootScope({required this.data, required super.child});

  final RootScopeState data;

  static _InheritedRootScope? maybeOf(BuildContext context, {bool listen = true}) => listen
      ? context.dependOnInheritedWidgetOfExactType<_InheritedRootScope>()
      : context.getInheritedWidgetOfExactType<_InheritedRootScope>();

  static Never _notFoundInheritedWidgetOfExactType() => throw ArgumentError(
    'Out of scope, not found inherited widget a _InheritedRootScope of the exact type',
    'out_of_scope',
  );

  static _InheritedRootScope of(BuildContext context, {bool listen = true}) =>
      maybeOf(context, listen: listen) ?? _notFoundInheritedWidgetOfExactType();

  @override
  bool updateShouldNotify(_InheritedRootScope oldWidget) => false;
}

extension RootScopeContextX on BuildContext {
  KeyValueStorage get keyValueStorage => RootScope.of(this).keyValueStorage;
  AuthRepository get authRepository => RootScope.of(this).authRepository;
  AuthGate get authGate => RootScope.of(this).authGate;
}
