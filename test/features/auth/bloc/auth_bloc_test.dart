import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:orb_test_app/src/features/auth/bloc/auth_bloc.dart';
import 'package:orb_test_app/src/features/auth/common/model/auth_error.dart';
import 'package:orb_test_app/src/features/auth/common/model/auth_user.dart';
import 'package:orb_test_app/src/features/auth/common/model/session.dart';
import 'package:orb_test_app/src/features/auth/data/auth_repository.dart';

import '../../../helpers/register_fallback_values.dart';

class _MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  setUpAll(registerTestFallbackValues);

  const session = Session(
    accessToken: 'mock-test@test.com',
    user: AuthUser(email: 'test@test.com', displayName: 'test'),
  );
  const googleSession = Session(
    accessToken: 'mock-google@example.com',
    user: AuthUser(email: 'google@example.com', displayName: 'google'),
  );

  late _MockAuthRepository authRepository;

  setUp(() {
    authRepository = _MockAuthRepository();
  });

  group('AuthBloc login', () {
    blocTest<AuthBloc, AuthState>(
      'emits submitting then success on valid credentials',
      setUp: () {
        when(
          () => authRepository.login(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => session);
      },
      build: () => AuthBloc(authRepository: authRepository),
      act: (bloc) =>
          bloc.add(const AuthLoginSubmitted(email: 'test@test.com', password: 'password')),
      expect: () => <Matcher>[isA<AuthSubmitting>(), isA<AuthSuccess>()],
      verify: (_) => verify(
        () => authRepository.login(email: 'test@test.com', password: 'password'),
      ).called(1),
    );

    blocTest<AuthBloc, AuthState>(
      'emits submitting then failure on invalid credentials',
      setUp: () {
        when(
          () => authRepository.login(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenThrow(const AuthInvalidCredentialsError());
      },
      build: () => AuthBloc(authRepository: authRepository),
      act: (bloc) => bloc.add(const AuthLoginSubmitted(email: 'test@test.com', password: 'wrong!')),
      expect: () => <Matcher>[
        isA<AuthSubmitting>(),
        predicate<AuthState>(
          (state) => state is AuthFailure && state.error is AuthInvalidCredentialsError,
        ),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits unknown failure on unexpected login error',
      setUp: () {
        when(
          () => authRepository.login(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenThrow(Exception('boom'));
      },
      build: () => AuthBloc(authRepository: authRepository),
      act: (bloc) =>
          bloc.add(const AuthLoginSubmitted(email: 'test@test.com', password: 'password')),
      expect: () => <Matcher>[
        isA<AuthSubmitting>(),
        predicate<AuthState>((state) => state is AuthFailure && state.error is AuthUnknownError),
      ],
    );
  });

  group('AuthBloc signup', () {
    blocTest<AuthBloc, AuthState>(
      'emits success on new email',
      setUp: () {
        when(
          () => authRepository.signup(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => session);
      },
      build: () => AuthBloc(authRepository: authRepository),
      act: (bloc) =>
          bloc.add(const AuthSignupSubmitted(email: 'new@test.com', password: 'password')),
      expect: () => <Matcher>[isA<AuthSubmitting>(), isA<AuthSuccess>()],
    );

    blocTest<AuthBloc, AuthState>(
      'emits failure on existing email',
      setUp: () {
        when(
          () => authRepository.signup(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenThrow(const AuthEmailAlreadyExistsError());
      },
      build: () => AuthBloc(authRepository: authRepository),
      act: (bloc) =>
          bloc.add(const AuthSignupSubmitted(email: 'test@test.com', password: 'password')),
      expect: () => <Matcher>[
        isA<AuthSubmitting>(),
        predicate<AuthState>(
          (state) => state is AuthFailure && state.error is AuthEmailAlreadyExistsError,
        ),
      ],
    );
  });

  group('AuthBloc google', () {
    blocTest<AuthBloc, AuthState>(
      'emits success on Google sign-in',
      setUp: () {
        when(authRepository.signInWithGoogle).thenAnswer((_) async => googleSession);
      },
      build: () => AuthBloc(authRepository: authRepository),
      act: (bloc) => bloc.add(const AuthGoogleSignInRequested()),
      expect: () => <Matcher>[isA<AuthSubmitting>(), isA<AuthSuccess>()],
    );

    blocTest<AuthBloc, AuthState>(
      'emits unknown failure on unexpected Google sign-in error',
      setUp: () {
        when(authRepository.signInWithGoogle).thenThrow(Exception('boom'));
      },
      build: () => AuthBloc(authRepository: authRepository),
      act: (bloc) => bloc.add(const AuthGoogleSignInRequested()),
      expect: () => <Matcher>[
        isA<AuthSubmitting>(),
        predicate<AuthState>((state) => state is AuthFailure && state.error is AuthUnknownError),
      ],
    );
  });
}
