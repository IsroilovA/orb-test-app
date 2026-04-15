import 'package:flutter/material.dart';
import 'package:helm/helm.dart';
import 'package:orb_test_app/src/features/auth/widget/auth_screen.dart';
import 'package:orb_test_app/src/features/home/widget/home_screen.dart';
import 'package:orb_test_app/src/features/settings/widget/settings_screen.dart';

enum OrbRoutes with Routable {
  home,
  settings,
  auth;

  @override
  String get path => switch (this) {
    OrbRoutes.home => '/',
    OrbRoutes.settings => '/settings',
    OrbRoutes.auth => '/auth',
  };

  @override
  PageType get pageType => switch (this) {
    OrbRoutes.home || OrbRoutes.settings || OrbRoutes.auth => PageType.material,
  };

  @override
  Widget builder(Map<String, String> pathParams, Map<String, String> queryParams) => switch (this) {
    OrbRoutes.home => const HomeScreen(),
    OrbRoutes.settings => const SettingsScreen(),
    OrbRoutes.auth => const AuthScreen(),
  };
}
