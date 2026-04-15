import 'package:flutter/material.dart';

class OrbTextField extends StatelessWidget {
  const OrbTextField({
    required this.controller,
    required this.label,
    this.enabled = true,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.autocorrect = true,
    this.enableSuggestions = true,
    this.onSubmitted,
    super.key,
  });

  final TextEditingController controller;
  final String label;
  final bool enabled;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool autocorrect;
  final bool enableSuggestions;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      enabled: enabled,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      autocorrect: autocorrect,
      enableSuggestions: enableSuggestions,
      onSubmitted: onSubmitted,
      decoration: InputDecoration(labelText: label),
    );
  }
}
