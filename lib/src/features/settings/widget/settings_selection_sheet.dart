import 'package:flutter/material.dart';
import 'package:orb_ui_kit/orb_ui_kit.dart';

@immutable
class SettingsOption<T> {
  const SettingsOption({required this.value, required this.label});

  final T value;
  final String label;
}

class SettingsSelectionSheet<T> extends StatelessWidget {
  const SettingsSelectionSheet({
    required this.title,
    required this.options,
    required this.selectedValue,
    super.key,
  });

  final String title;
  final List<SettingsOption<T>> options;
  final T selectedValue;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(title, style: context.orbTextTheme.titleLarge),
            const SizedBox(height: 16),
            DecoratedBox(
              decoration: BoxDecoration(
                color: context.colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: context.colorScheme.outlineVariant.withValues(alpha: 0.8),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: List<Widget>.generate(options.length, (int index) {
                  final option = options[index];
                  final isSelected = option.value == selectedValue;

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
                        title: Text(option.label, style: context.orbTextTheme.titleSmall),
                        trailing: isSelected
                            ? Icon(Icons.check_rounded, color: context.orbColorScheme.primary)
                            : null,
                        onTap: () => Navigator.of(context).pop(option.value),
                      ),
                      if (index < options.length - 1)
                        Divider(
                          height: 1,
                          color: context.colorScheme.outlineVariant.withValues(alpha: 0.6),
                        ),
                    ],
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
