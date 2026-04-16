import 'package:flutter/material.dart';
import 'package:orb_test_app/src/app/orb_app.dart';
import 'package:orb_test_app/src/core/init/app_dependencies_scope.dart';
import 'package:orb_test_app/src/core/localization/l10n.dart';
import 'package:orb_test_app/src/core/localization/localization_scope.dart';
import 'package:orb_test_app/src/core/theme/theme_scope.dart';
import 'package:orb_test_app/src/features/settings/widget/settings_selection_sheet.dart';
import 'package:orb_ui_kit/orb_ui_kit.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Future<void> _selectTheme(BuildContext context) async {
    final selectedThemeMode = await showModalBottomSheet<ThemeMode>(
      context: context,
      showDragHandle: true,
      builder: (BuildContext bottomSheetContext) => SettingsSelectionSheet<ThemeMode>(
        title: context.l10n.settingsThemeSheetTitle,
        selectedValue: context.themeModeSetting,
        options: <SettingsOption<ThemeMode>>[
          SettingsOption<ThemeMode>(
            value: ThemeMode.system,
            label: context.l10n.settingsThemeSystem,
          ),
          SettingsOption<ThemeMode>(value: ThemeMode.light, label: context.l10n.settingsThemeLight),
          SettingsOption<ThemeMode>(value: ThemeMode.dark, label: context.l10n.settingsThemeDark),
        ],
      ),
    );

    if (selectedThemeMode == null || !context.mounted) {
      return;
    }

    await context.themeModeController.setThemeMode(selectedThemeMode);
  }

  Future<void> _selectLanguage(BuildContext context) async {
    final selectedLocale = await showModalBottomSheet<Locale>(
      context: context,
      showDragHandle: true,
      builder: (BuildContext bottomSheetContext) => SettingsSelectionSheet<Locale>(
        title: context.l10n.settingsLanguageSheetTitle,
        selectedValue: _effectiveLocale(context),
        options: OrbApp.supportedLanguages.keys
            .map(
              (Locale locale) =>
                  SettingsOption<Locale>(value: locale, label: OrbApp.supportedLanguages[locale]!),
            )
            .toList(growable: false),
      ),
    );

    if (selectedLocale == null || !context.mounted) {
      return;
    }

    await context.localizationController.setLocale(selectedLocale);
  }

  Locale _effectiveLocale(BuildContext context) {
    final locale = context.localeSetting;
    if (locale != null) {
      return locale;
    }

    final activeLanguageCode = Localizations.localeOf(context).languageCode;
    return OrbApp.supportedLanguages.keys.firstWhere(
      (Locale supportedLocale) => supportedLocale.languageCode == activeLanguageCode,
      orElse: () => OrbApp.supportedLanguages.keys.first,
    );
  }

  String _themeModeLabel(BuildContext context) {
    return switch (context.themeModeSetting) {
      ThemeMode.system => context.l10n.settingsThemeSystem,
      ThemeMode.light => context.l10n.settingsThemeLight,
      ThemeMode.dark => context.l10n.settingsThemeDark,
    };
  }

  String _languageLabel(BuildContext context) {
    final locale = _effectiveLocale(context);
    return OrbApp.supportedLanguages[locale] ?? OrbApp.supportedLanguages.values.first;
  }

  Future<void> _signOut(BuildContext context) async {
    await context.authRepository.signOut();
  }

  @override
  Widget build(BuildContext context) {
    final orbColors = context.orbColorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.settingsTitle)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  context.l10n.settingsPreferencesLabel,
                  style: context.orbTextTheme.labelLarge.copyWith(
                    color: orbColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Card(
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: <Widget>[
                OrbSettingsTile(
                  title: context.l10n.settingsLanguageTitle,
                  value: _languageLabel(context),
                  icon: Icons.language_rounded,
                  onTap: () => _selectLanguage(context),
                ),
                Divider(height: 1, indent: 18, endIndent: 18, color: orbColors.outlineVariant),
                OrbSettingsTile(
                  title: context.l10n.settingsThemeTitle,
                  value: _themeModeLabel(context),
                  icon: Icons.palette_outlined,
                  onTap: () => _selectTheme(context),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () => _signOut(context),
            icon: const Icon(Icons.logout_rounded),
            label: Text(context.l10n.authSignOutCta),
          ),
        ],
      ),
    );
  }
}
