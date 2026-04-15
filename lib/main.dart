import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orb_test_app/src/app/orb_app.dart';
import 'package:orb_test_app/src/app/root_scope.dart';
import 'package:orb_test_app/src/core/localization/localization_scope.dart';
import 'package:orb_test_app/src/core/logging/app_bloc_observer.dart';
import 'package:orb_test_app/src/core/logging/app_logger.dart';
import 'package:orb_test_app/src/core/theme/theme_scope.dart';

void main() {
  runZonedGuarded(() {
    WidgetsFlutterBinding.ensureInitialized();
    Bloc.observer = const AppBlocObserver();
    runApp(
      const RootScope(
        child: LocalizationScope(child: ThemeScope(child: OrbApp())),
      ),
    );
  }, (error, stack) => AppLogger.fatal('orb.bootstrap', 'Uncaught zone error', error, stack));
}
