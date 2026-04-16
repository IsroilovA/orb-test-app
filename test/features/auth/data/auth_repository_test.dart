import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:orb_test_app/src/features/auth/common/model/auth_error.dart';
import 'package:orb_test_app/src/features/auth/common/model/auth_user.dart';
import 'package:orb_test_app/src/features/auth/common/model/session.dart';
import 'package:orb_test_app/src/features/auth/data/auth_remote_data_source.dart';
import 'package:orb_test_app/src/features/auth/data/auth_repository.dart';
import 'package:orb_test_app/src/features/auth/data/auth_session_storage.dart';

import '../../../helpers/register_fallback_values.dart';

class _MockRemoteDataSource extends Mock implements AuthRemoteDataSource {}

class _MockSessionStorage extends Mock implements AuthSessionStorage {}

void main() {
  setUpAll(registerTestFallbackValues);

  const session = Session(
    accessToken: 'mock-test@test.com',
    user: AuthUser(email: 'test@test.com', displayName: 'test'),
  );

  late _MockRemoteDataSource remote;
  late _MockSessionStorage storage;
  late AuthRepositoryImpl repository;

  setUp(() {
    remote = _MockRemoteDataSource();
    storage = _MockSessionStorage();
    when(() => storage.write(any())).thenAnswer((_) async {});
    when(storage.clear).thenAnswer((_) async {});
    when(remote.logout).thenAnswer((_) async {});
    repository = AuthRepositoryImpl(remoteDataSource: remote, sessionStorage: storage);
  });

  tearDown(() async {
    await repository.dispose();
  });

  test('initialize restores session from storage', () async {
    when(storage.read).thenAnswer((_) async => session);
    await repository.initialize();
    expect(repository.currentSession, session);
  });

  test('initialize swallows storage failures and seeds null', () async {
    when(storage.read).thenThrow(const AuthStorageError(cause: 'boom'));
    await repository.initialize();
    expect(repository.currentSession, isNull);
  });

  test('login persists session and emits on stream', () async {
    when(
      () => remote.login(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    ).thenAnswer((_) async => session);

    final result = await repository.login(email: 'test@test.com', password: 'password');

    expect(result, session);
    expect(repository.currentSession, session);
    verify(() => storage.write(session)).called(1);
  });

  test('signup persists session and emits on stream', () async {
    when(
      () => remote.signup(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    ).thenAnswer((_) async => session);

    final result = await repository.signup(email: 'test@test.com', password: 'password');

    expect(result, session);
    expect(repository.currentSession, session);
    verify(() => storage.write(session)).called(1);
  });

  test('signInWithGoogle persists session and emits on stream', () async {
    when(remote.signInWithGoogle).thenAnswer((_) async => session);

    final result = await repository.signInWithGoogle();

    expect(result, session);
    expect(repository.currentSession, session);
    verify(() => storage.write(session)).called(1);
  });

  test('login rejects malformed email with validation error', () async {
    await expectLater(
      repository.login(email: 'not-an-email', password: 'password'),
      throwsA(isA<AuthValidationError>()),
    );
    verifyNever(
      () => remote.login(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    );
  });

  test('login rejects short password with validation error', () async {
    await expectLater(
      repository.login(email: 'test@test.com', password: '123'),
      throwsA(isA<AuthValidationError>()),
    );
  });

  test('signOut clears storage and emits null', () async {
    when(storage.read).thenAnswer((_) async => session);
    await repository.initialize();
    expect(repository.currentSession, session);

    await repository.signOut();

    expect(repository.currentSession, isNull);
    verify(storage.clear).called(1);
  });

  test('signOut clears local session when remote logout fails', () async {
    when(storage.read).thenAnswer((_) async => session);
    when(remote.logout).thenThrow(Exception('network down'));

    await repository.initialize();
    await repository.signOut();

    expect(repository.currentSession, isNull);
    verify(storage.clear).called(1);
  });
}
