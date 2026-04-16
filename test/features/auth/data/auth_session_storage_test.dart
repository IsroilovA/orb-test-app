import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:orb_test_app/src/features/auth/common/model/auth_error.dart';
import 'package:orb_test_app/src/features/auth/common/model/auth_user.dart';
import 'package:orb_test_app/src/features/auth/common/model/session.dart';
import 'package:orb_test_app/src/features/auth/data/auth_session_storage.dart';

class _MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  const session = Session(
    accessToken: 'token',
    user: AuthUser(email: 'test@test.com', displayName: 'test'),
  );

  late _MockFlutterSecureStorage secureStorage;
  late SecureAuthSessionStorage storage;

  setUp(() {
    secureStorage = _MockFlutterSecureStorage();
    storage = SecureAuthSessionStorage(secureStorage: secureStorage);
  });

  test('read returns null when no session is stored', () async {
    when(() => secureStorage.read(key: any(named: 'key'))).thenAnswer((_) async => null);

    expect(await storage.read(), isNull);
  });

  test('read decodes stored session json', () async {
    when(
      () => secureStorage.read(key: any(named: 'key')),
    ).thenAnswer((_) async => jsonEncode(session.toJson()));

    expect(await storage.read(), session);
  });

  test('write stores encoded session json', () async {
    when(
      () => secureStorage.write(
        key: any(named: 'key'),
        value: any(named: 'value'),
      ),
    ).thenAnswer((_) async {});

    await storage.write(session);

    verify(
      () => secureStorage.write(key: 'auth.session', value: jsonEncode(session.toJson())),
    ).called(1);
  });

  test('clear deletes stored session', () async {
    when(() => secureStorage.delete(key: any(named: 'key'))).thenAnswer((_) async {});

    await storage.clear();

    verify(() => secureStorage.delete(key: 'auth.session')).called(1);
  });

  test('storage failures are mapped to AuthStorageError', () async {
    when(() => secureStorage.read(key: any(named: 'key'))).thenThrow(Exception('boom'));

    await expectLater(storage.read(), throwsA(isA<AuthStorageError>()));
  });
}
