import 'package:flutter/material.dart';
import 'package:orb_ui_kit/src/widget/orb_button_loading_indicator.dart';

class OrbPrimaryButton extends StatelessWidget {
  const OrbPrimaryButton({
    required this.onPressed,
    required this.label,
    this.icon,
    this.isLoading = false,
    super.key,
  });

  final VoidCallback? onPressed;
  final String label;
  final IconData? icon;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      final disabledForegroundColor = Theme.of(context).filledButtonTheme.style?.foregroundColor
          ?.resolve(const <WidgetState>{WidgetState.disabled});

      return FilledButton(
        onPressed: null,
        child: OrbButtonLoadingIndicator(color: disabledForegroundColor),
      );
    }
    final icon = this.icon;
    if (icon != null) {
      return FilledButton.icon(onPressed: onPressed, icon: Icon(icon), label: Text(label));
    }
    return FilledButton(onPressed: onPressed, child: Text(label));
  }
}
