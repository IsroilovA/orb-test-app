import 'package:flutter/material.dart';

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
      return const FilledButton(
        onPressed: null,
        child: SizedBox.square(dimension: 20, child: CircularProgressIndicator(strokeWidth: 2)),
      );
    }
    final icon = this.icon;
    if (icon != null) {
      return FilledButton.icon(onPressed: onPressed, icon: Icon(icon), label: Text(label));
    }
    return FilledButton(onPressed: onPressed, child: Text(label));
  }
}
