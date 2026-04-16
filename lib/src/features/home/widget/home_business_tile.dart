import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:orb_test_app/src/core/localization/l10n.dart';
import 'package:orb_test_app/src/features/home/common/model/home_business.dart';

class HomeBusinessTile extends StatelessWidget {
  const HomeBusinessTile({required this.business, super.key});

  final HomeBusiness business;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toLanguageTag();
    final currencyFormatter = NumberFormat.compactCurrency(locale: locale, symbol: r'$');
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(business.name, style: theme.textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(business.id, style: theme.textTheme.labelMedium),
            const SizedBox(height: 12),
            Text(business.description, style: theme.textTheme.bodyMedium),
            const SizedBox(height: 12),
            Text(
              context.l10n.homeBusinessRevenueLabel(currencyFormatter.format(business.revenue)),
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 4),
            Text(
              context.l10n.homeBusinessEmployeesLabel(business.employeeCount),
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
