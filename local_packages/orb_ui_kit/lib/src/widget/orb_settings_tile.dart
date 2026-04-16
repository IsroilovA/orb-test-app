import 'package:flutter/material.dart';
import 'package:orb_ui_kit/src/theme/orb_theme.dart';

class OrbSettingsTile extends StatelessWidget {
  const OrbSettingsTile({
    required this.title,
    required this.value,
    required this.icon,
    required this.onTap,
    super.key,
  });

  final String title;
  final String value;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final orbColors = context.orbColorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          child: Row(
            children: <Widget>[
              DecoratedBox(
                decoration: BoxDecoration(
                  color: orbColors.primary.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Icon(icon, color: orbColors.primary),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(title, style: context.orbTextTheme.titleMedium),
                    const SizedBox(height: 4),
                    Text(
                      value,
                      style: context.orbTextTheme.bodyMedium.copyWith(
                        color: orbColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Icon(Icons.chevron_right_rounded, color: orbColors.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }
}
