import 'package:flutter/material.dart';
import 'package:orb_test_app/src/core/localization/l10n.dart';
import 'package:orb_test_app/src/features/auth/common/model/auth_user.dart';
import 'package:orb_ui_kit/orb_ui_kit.dart';

class HomeUserSection extends StatelessWidget {
  const HomeUserSection({required this.user, super.key});

  final AuthUser user;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(context.l10n.homeActiveUserTitle, style: context.orbTextTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(user.displayName, style: theme.textTheme.titleLarge),
            const SizedBox(height: 4),
            Text(user.email, style: theme.textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}
