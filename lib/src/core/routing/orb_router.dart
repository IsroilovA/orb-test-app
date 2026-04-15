import 'package:flutter/material.dart';
import 'package:helm/helm.dart';
import 'package:orb_test_app/src/core/routing/orb_routes.dart';

mixin RouterStateMixin<T extends StatefulWidget> on State<T> {
  late final HelmRouter router;

  @override
  void initState() {
    super.initState();
    router = HelmRouter(routes: OrbRoutes.values);
  }
}
