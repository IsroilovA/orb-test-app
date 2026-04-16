import 'package:flutter/material.dart';
import 'package:orb_test_app/src/core/localization/l10n.dart';
import 'package:orb_test_app/src/features/home/common/model/home_business.dart';
import 'package:orb_test_app/src/features/home/widget/home_business_tile.dart';
import 'package:orb_ui_kit/orb_ui_kit.dart';

class HomeBusinessesSection extends StatelessWidget {
  const HomeBusinessesSection({required this.businesses, super.key});

  final List<HomeBusiness> businesses;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(context.l10n.homeBusinessesTitle, style: context.orbTextTheme.headlineSmall),
        const SizedBox(height: 12),
        ...businesses.map(
          (HomeBusiness business) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: HomeBusinessTile(business: business),
          ),
        ),
      ],
    );
  }
}
