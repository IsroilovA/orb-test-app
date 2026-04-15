import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orb_test_app/src/core/localization/l10n.dart';
import 'package:orb_test_app/src/features/auth/bloc/auth_bloc.dart';

class AuthFailureListener extends StatelessWidget {
  const AuthFailureListener({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (previous, current) => current is AuthFailure,
      listener: (context, state) {
        if (state is! AuthFailure) return;
        final messenger = ScaffoldMessenger.of(context);
        messenger
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(state.error.localize(context.l10n))));
      },
      child: child,
    );
  }
}
