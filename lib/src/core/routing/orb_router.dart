import 'package:flutter/material.dart';
import 'package:helm/helm.dart';
import 'package:orb_test_app/src/core/init/app_dependencies_scope.dart';
import 'package:orb_test_app/src/core/routing/orb_routes.dart';
import 'package:orb_test_app/src/features/auth/domain/auth_gate.dart';

mixin RouterStateMixin<T extends StatefulWidget> on State<T> {
  late final HelmRouter router;

  @override
  void initState() {
    super.initState();
    final authGate = AppDependenciesScope.of(context).dependencies.authGate;
    router = HelmRouter(routes: OrbRoutes.values, refresh: authGate, guards: <NavigationGuard>[_authGuard(authGate)]);
  }
}

NavigationGuard _authGuard(AuthGate authGate) {
  return (pages) {
    final isAuthenticated = authGate.isAuthenticated;

    if (!isAuthenticated) {
      final sanitized = pages.where(_isAuthPage).toList();
      if (sanitized.isEmpty) return <Page<Object?>>[OrbRoutes.login.page()];
      return sanitized;
    }

    final sanitized = pages.where((page) => !_isAuthPage(page)).toList();
    if (sanitized.isEmpty) return <Page<Object?>>[OrbRoutes.home.page()];
    return sanitized;
  };
}

bool _isAuthPage(Page<Object?> page) {
  final route = page.meta?.route;
  return route is OrbRoutes && route.isAuthRoute;
}
