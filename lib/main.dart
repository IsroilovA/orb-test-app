import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orb_test_app/src/app/orb_app.dart';
import 'package:orb_test_app/src/core/logging/app_bloc_observer.dart';

void main() {
  Bloc.observer = const AppBlocObserver();
  runApp(const OrbApp());
}
