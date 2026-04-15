import 'package:flutter/material.dart';
import 'package:orb_test_app/src/app/root_scope.dart';
import 'package:orb_test_app/src/core/localization/l10n.dart';
import 'package:orb_ui_kit/orb_ui_kit.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final session = context.authRepository.currentSession;
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.homeTitle)),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(context.l10n.appTitle, style: context.orbTextTheme.headlineMedium),
            if (session != null) ...<Widget>[
              const SizedBox(height: 16),
              Text(session.user.email, style: context.orbTextTheme.bodyLarge),
            ],
            const SizedBox(height: 32),
            OrbPrimaryButton(onPressed: () => context.authRepository.signOut(), label: context.l10n.authSignOutCta),
          ],
        ),
      ),
    );
  }
}
