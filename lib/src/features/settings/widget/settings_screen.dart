import 'package:flutter/material.dart';
import 'package:orb_test_app/src/core/localization/l10n.dart';
import 'package:orb_ui_kit/orb_ui_kit.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.settingsTitle)),
      body: Center(child: Text(context.l10n.settingsTitle, style: context.orbTextTheme.headlineMedium)),
    );
  }
}
