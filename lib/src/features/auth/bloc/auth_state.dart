part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  bool get isSubmitting => this is AuthSubmitting;

  @override
  List<Object?> get props => const <Object?>[];
}

final class AuthIdle extends AuthState {
  const AuthIdle();
}

final class AuthSubmitting extends AuthState {
  const AuthSubmitting();
}

final class AuthSuccess extends AuthState {
  const AuthSuccess({required this.user});

  final AuthUser user;

  @override
  List<Object?> get props => <Object?>[user];
}

final class AuthFailure extends AuthState {
  const AuthFailure({required this.error});

  final AuthError error;

  @override
  List<Object?> get props => <Object?>[error];
}
