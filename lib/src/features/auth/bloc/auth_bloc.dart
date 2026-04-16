import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orb_test_app/src/features/auth/common/model/auth_error.dart';
import 'package:orb_test_app/src/features/auth/common/model/auth_user.dart';
import 'package:orb_test_app/src/features/auth/data/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

final class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({required AuthRepository authRepository})
    : _authRepository = authRepository,
      super(const AuthIdle()) {
    on<AuthEvent>(
      (event, emit) => switch (event) {
        AuthLoginSubmitted() => _onLoginSubmitted(event, emit),
        AuthSignupSubmitted() => _onSignupSubmitted(event, emit),
        AuthGoogleSignInRequested() => _onGoogleSignInRequested(event, emit),
      },
      transformer: sequential(),
    );
  }

  final AuthRepository _authRepository;

  Future<void> _onLoginSubmitted(AuthLoginSubmitted event, Emitter<AuthState> emit) async {
    emit(const AuthSubmitting());
    try {
      final session = await _authRepository.login(email: event.email, password: event.password);
      emit(AuthSuccess(user: session.user));
    } on AuthError catch (error) {
      emit(AuthFailure(error: error));
    } on Object catch (error) {
      emit(AuthFailure(error: AuthUnknownError(cause: error)));
    }
  }

  Future<void> _onSignupSubmitted(AuthSignupSubmitted event, Emitter<AuthState> emit) async {
    emit(const AuthSubmitting());
    try {
      final session = await _authRepository.signup(email: event.email, password: event.password);
      emit(AuthSuccess(user: session.user));
    } on AuthError catch (error) {
      emit(AuthFailure(error: error));
    } on Object catch (error) {
      emit(AuthFailure(error: AuthUnknownError(cause: error)));
    }
  }

  Future<void> _onGoogleSignInRequested(
    AuthGoogleSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthSubmitting());
    try {
      final session = await _authRepository.signInWithGoogle();
      emit(AuthSuccess(user: session.user));
    } on AuthError catch (error) {
      emit(AuthFailure(error: error));
    } on Object catch (error) {
      emit(AuthFailure(error: AuthUnknownError(cause: error)));
    }
  }
}
