import 'package:flutter/material.dart';
import 'package:orb_test_app/src/core/localization/l10n.dart';
import 'package:orb_test_app/src/core/localization/localization_scope.dart';
import 'package:orb_test_app/src/core/theme/theme_scope.dart';
import 'package:orb_test_app/src/core/routing/orb_router.dart';
import 'package:orb_ui_kit/orb_ui_kit.dart';

class OrbApp extends StatefulWidget {
  const OrbApp({super.key});

  static final supportedLanguages = <Locale, String>{
    const Locale('en'): 'English',
    const Locale('uz'): 'Oʻzbek',
    const Locale('ru'): 'Русский',
  };

  static const localizationsDelegates = AppLocalizations.localizationsDelegates;

  @override
  State<OrbApp> createState() => _OrbAppState();
}

class _OrbAppState extends State<OrbApp> with RouterStateMixin<OrbApp> {
  final Key _builderKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      locale: context.localeSetting,
      supportedLocales: OrbApp.supportedLanguages.keys,
      localizationsDelegates: OrbApp.localizationsDelegates,
      themeMode: context.themeModeSetting,
      theme: OrbTheme.light,
      darkTheme: OrbTheme.dark,
      routerConfig: router,
      builder: (context, child) => MediaQuery(
        key: _builderKey,
        data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
        child: child ?? const SizedBox.shrink(),
      ),
    );
  }
}
