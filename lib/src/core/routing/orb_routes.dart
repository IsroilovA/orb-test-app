import 'package:flutter/material.dart';
import 'package:helm/helm.dart';
import 'package:orb_test_app/src/features/auth/widget/login_screen.dart';
import 'package:orb_test_app/src/features/auth/widget/signup_screen.dart';
import 'package:orb_test_app/src/features/home/widget/home_screen.dart';
import 'package:orb_test_app/src/features/settings/widget/settings_screen.dart';

enum OrbRoutes with Routable {
  home,
  settings,
  login,
  signup;

  @override
  String get path => switch (this) {
    OrbRoutes.home => '/',
    OrbRoutes.settings => '/settings',
    OrbRoutes.login => '/login',
    OrbRoutes.signup => '/signup',
  };

  @override
  PageType get pageType => switch (this) {
    OrbRoutes.home ||
    OrbRoutes.settings ||
    OrbRoutes.login ||
    OrbRoutes.signup => PageType.material,
  };

  @override
  Widget builder(Map<String, String> pathParams, Map<String, String> queryParams) => switch (this) {
    OrbRoutes.home => const HomeScreen(),
    OrbRoutes.settings => const SettingsScreen(),
    OrbRoutes.login => const LoginScreen(),
    OrbRoutes.signup => const SignupScreen(),
  };

  bool get isAuthRoute => this == OrbRoutes.login || this == OrbRoutes.signup;
}
