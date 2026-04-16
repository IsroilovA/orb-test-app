import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orb_test_app/src/core/localization/l10n.dart';
import 'package:orb_test_app/src/features/auth/bloc/auth_bloc.dart';
import 'package:orb_ui_kit/orb_ui_kit.dart';

class AuthCredentialsForm extends StatefulWidget {
  const AuthCredentialsForm({
    required this.submitLabel,
    required this.toggleLabel,
    required this.buildSubmitEvent,
    required this.onToggle,
    super.key,
  });

  final String submitLabel;
  final String toggleLabel;
  final AuthEvent Function(String email, String password) buildSubmitEvent;
  final VoidCallback onToggle;

  @override
  State<AuthCredentialsForm> createState() => _AuthCredentialsFormState();
}

class _AuthCredentialsFormState extends State<AuthCredentialsForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    final event = widget.buildSubmitEvent(_emailController.text.trim(), _passwordController.text);
    context.read<AuthBloc>().add(event);
  }

  void _signInWithGoogle() {
    context.read<AuthBloc>().add(const AuthGoogleSignInRequested());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isSubmitting = context.select<AuthBloc, bool>((bloc) => bloc.state.isSubmitting);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          OrbTextField(
            controller: _emailController,
            label: l10n.authEmailLabel,
            enabled: !isSubmitting,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            autocorrect: false,
            enableSuggestions: false,
          ),
          const SizedBox(height: 16),
          OrbTextField(
            controller: _passwordController,
            label: l10n.authPasswordLabel,
            enabled: !isSubmitting,
            obscureText: true,
            textInputAction: TextInputAction.done,
            autocorrect: false,
            enableSuggestions: false,
            onSubmitted: (_) => isSubmitting ? null : _submit(),
          ),
          const SizedBox(height: 24),
          OrbPrimaryButton(onPressed: _submit, label: widget.submitLabel, isLoading: isSubmitting),
          const SizedBox(height: 12),
          OrbSecondaryButton(
            onPressed: isSubmitting ? null : _signInWithGoogle,
            label: l10n.authGoogleCta,
            icon: Icons.account_circle_outlined,
          ),
          const SizedBox(height: 24),
          OrbTextButton(
            onPressed: isSubmitting ? null : widget.onToggle,
            label: widget.toggleLabel,
          ),
        ],
      ),
    );
  }
}
