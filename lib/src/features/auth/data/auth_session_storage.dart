import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:orb_test_app/src/features/auth/common/model/auth_error.dart';
import 'package:orb_test_app/src/features/auth/common/model/session.dart';

abstract interface class AuthSessionStorage {
  Future<Session?> read();

  Future<void> write(Session session);

  Future<void> clear();
}

const String _kSessionKey = 'auth.session';

final class SecureAuthSessionStorage implements AuthSessionStorage {
  SecureAuthSessionStorage({required FlutterSecureStorage secureStorage})
    : _secureStorage = secureStorage;

  final FlutterSecureStorage _secureStorage;

  @override
  Future<Session?> read() async {
    try {
      final raw = await _secureStorage.read(key: _kSessionKey);
      if (raw == null || raw.isEmpty) return null;
      final json = jsonDecode(raw) as Map<String, Object?>;
      return Session.fromJson(json);
    } on Object catch (error) {
      throw AuthStorageError(cause: error);
    }
  }

  @override
  Future<void> write(Session session) async {
    try {
      await _secureStorage.write(key: _kSessionKey, value: jsonEncode(session.toJson()));
    } on Object catch (error) {
      throw AuthStorageError(cause: error);
    }
  }

  @override
  Future<void> clear() async {
    try {
      await _secureStorage.delete(key: _kSessionKey);
    } on Object catch (error) {
      throw AuthStorageError(cause: error);
    }
  }
}
