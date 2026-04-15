import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orb_test_app/src/app/orb_app.dart';
import 'package:orb_test_app/src/app/root_scope.dart';
import 'package:orb_test_app/src/core/localization/localization_scope.dart';
import 'package:orb_test_app/src/core/logging/app_bloc_observer.dart';
import 'package:orb_test_app/src/core/logging/app_logger.dart';
import 'package:orb_test_app/src/core/storage/shared_preferences_key_value_storage.dart';
import 'package:orb_test_app/src/core/theme/theme_scope.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      Bloc.observer = const AppBlocObserver();
      final prefs = await SharedPreferences.getInstance();
      final keyValueStorage = SharedPreferencesKeyValueStorage(prefs);
      runApp(
        RootScope(
          keyValueStorage: keyValueStorage,
          child: const LocalizationScope(
            child: ThemeScope(child: OrbApp()),
          ),
        ),
      );
    },
    (error, stack) => AppLogger.fatal('orb.bootstrap', 'Uncaught zone error', error, stack),
  );
}
