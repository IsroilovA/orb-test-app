import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:orb_test_app/src/core/localization/l10n.dart';
import 'package:orb_test_app/src/features/home/common/model/home_business.dart';
import 'package:orb_test_app/src/features/home/widget/home_business_tile.dart';
import 'package:orb_ui_kit/orb_ui_kit.dart';

class HomeBusinessesSection extends StatelessWidget {
  const HomeBusinessesSection({required this.businesses, super.key});

  final List<HomeBusiness> businesses;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final countFormatter = NumberFormat.compact(locale: locale);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(context.l10n.homeBusinessesTitle, style: context.orbTextTheme.headlineSmall),
                  const SizedBox(height: 6),
                  Text(
                    context.l10n.homeBusinessesSubtitle,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Text(
                countFormatter.format(businesses.length),
                style: context.orbTextTheme.titleSmall.copyWith(
                  color: colorScheme.onSecondaryContainer,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...businesses.map(
          (HomeBusiness business) => Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: HomeBusinessTile(business: business),
          ),
        ),
      ],
    );
  }
}
