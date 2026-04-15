import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helm/helm.dart';
import 'package:orb_test_app/src/app/root_scope.dart';
import 'package:orb_test_app/src/core/localization/l10n.dart';
import 'package:orb_test_app/src/core/routing/orb_routes.dart';
import 'package:orb_test_app/src/features/auth/bloc/auth_bloc.dart';
import 'package:orb_test_app/src/features/auth/widget/auth_credentials_form.dart';
import 'package:orb_test_app/src/features/auth/widget/auth_failure_listener.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocProvider<AuthBloc>(
      create: (context) => AuthBloc(authRepository: context.authRepository),
      child: AuthFailureListener(
        child: Scaffold(
          appBar: AppBar(title: Text(l10n.authLoginTitle)),
          body: SafeArea(
            child: AuthCredentialsForm(
              submitLabel: l10n.authLoginCta,
              toggleLabel: l10n.authToggleToSignup,
              buildSubmitEvent: (email, password) => AuthLoginSubmitted(email: email, password: password),
              onToggle: () => HelmRouter.push(context, OrbRoutes.signup),
            ),
          ),
        ),
      ),
    );
  }
}
