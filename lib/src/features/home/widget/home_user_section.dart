import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:orb_test_app/src/core/localization/l10n.dart';
import 'package:orb_test_app/src/features/auth/common/model/auth_user.dart';
import 'package:orb_test_app/src/features/home/common/model/home_business.dart';
import 'package:orb_test_app/src/features/home/widget/home_metric_panel.dart';
import 'package:orb_ui_kit/orb_ui_kit.dart';

class HomeUserSection extends StatelessWidget {
  const HomeUserSection({required this.user, required this.businesses, super.key});

  final AuthUser user;
  final List<HomeBusiness> businesses;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final revenueFormatter = NumberFormat.compactCurrency(locale: locale, symbol: r'$');
    final countFormatter = NumberFormat.compact(locale: locale);
    final totalRevenue = businesses.fold<double>(0, (sum, business) => sum + business.revenue);
    final totalEmployees = businesses.fold<int>(0, (sum, business) => sum + business.employeeCount);
    final initials = user.displayName
        .split(' ')
        .where((part) => part.isNotEmpty)
        .take(2)
        .map((part) => part.characters.first.toUpperCase())
        .join();

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[colorScheme.primaryContainer, colorScheme.surfaceContainerHigh],
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.7)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                CircleAvatar(
                  radius: 28,
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  child: Text(initials.isEmpty ? '?' : initials, style: context.orbTextTheme.titleLarge),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        context.l10n.homeActiveUserTitle,
                        style: context.orbTextTheme.labelLarge.copyWith(color: colorScheme.onSurfaceVariant),
                      ),
                      const SizedBox(height: 6),
                      Text(user.displayName, style: context.orbTextTheme.headlineMedium),
                      const SizedBox(height: 4),
                      Text(user.email, style: theme.textTheme.bodyLarge),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(context.l10n.homeHeroGreeting, style: context.orbTextTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(
              context.l10n.homeHeroSubtitle,
              style: theme.textTheme.bodyLarge?.copyWith(color: colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 24),
            Row(
              children: <Widget>[
                Expanded(
                  child: HomeMetricPanel(
                    label: context.l10n.homePortfolioLabel,
                    value: countFormatter.format(businesses.length),
                    icon: Icons.apartment_rounded,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: HomeMetricPanel(
                    label: context.l10n.homeTeamLabel,
                    value: countFormatter.format(totalEmployees),
                    icon: Icons.groups_rounded,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: HomeMetricPanel(
                    label: context.l10n.homeRevenueLabel,
                    value: revenueFormatter.format(totalRevenue),
                    icon: Icons.auto_graph_rounded,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
