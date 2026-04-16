import 'package:flutter/material.dart';
import 'package:orb_ui_kit/orb_ui_kit.dart';

class HomeMetricPanel extends StatelessWidget {
  const HomeMetricPanel({required this.label, required this.value, required this.icon, super.key});

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surface.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Icon(icon, size: 18, color: colorScheme.primary),
            const SizedBox(height: 14),
            Text(value, style: context.orbTextTheme.titleMedium),
            const SizedBox(height: 4),
            Text(
              label,
              style: context.orbTextTheme.labelMedium.copyWith(color: colorScheme.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}
