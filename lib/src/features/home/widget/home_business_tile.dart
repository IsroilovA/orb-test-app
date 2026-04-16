import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:orb_test_app/src/core/localization/l10n.dart';
import 'package:orb_test_app/src/features/home/common/model/home_business.dart';
import 'package:orb_ui_kit/orb_ui_kit.dart';

class HomeBusinessTile extends StatelessWidget {
  const HomeBusinessTile({required this.business, super.key});

  final HomeBusiness business;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toLanguageTag();
    final currencyFormatter = NumberFormat.compactCurrency(locale: locale, symbol: r'$');
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final employeeFormatter = NumberFormat.compact(locale: locale);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.8)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(child: Text(business.name, style: context.orbTextTheme.titleLarge)),
                const SizedBox(width: 16),
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: colorScheme.tertiaryContainer,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(Icons.domain_rounded, color: colorScheme.onTertiaryContainer),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(business.description, style: theme.textTheme.bodyMedium),
            const SizedBox(height: 18),
            Row(
              children: <Widget>[
                Expanded(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            currencyFormatter.format(business.revenue),
                            style: context.orbTextTheme.titleMedium,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            context.l10n.homeRevenueLabel,
                            style: context.orbTextTheme.labelMedium.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            employeeFormatter.format(business.employeeCount),
                            style: context.orbTextTheme.titleMedium,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            context.l10n.homeTeamLabel,
                            style: context.orbTextTheme.labelMedium.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              context.l10n.homeBusinessRevenueLabel(currencyFormatter.format(business.revenue)),
              style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 4),
            Text(
              context.l10n.homeBusinessEmployeesLabel(business.employeeCount),
              style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}
