import 'dart:async';

import 'package:orb_test_app/src/core/logging/app_logger.dart';
import 'package:orb_test_app/src/features/auth/common/model/auth_error.dart';
import 'package:orb_test_app/src/features/auth/common/model/session.dart';
import 'package:orb_test_app/src/features/auth/data/auth_remote_data_source.dart';
import 'package:orb_test_app/src/features/auth/data/auth_session_storage.dart';
import 'package:rxdart/rxdart.dart';

abstract interface class AuthRepository {
  Session? get currentSession;

  Stream<Session?> get sessionStream;

  Future<void> initialize();

  Future<Session> login({required String email, required String password});

  Future<Session> signup({required String email, required String password});

  Future<Session> signInWithGoogle();

  Future<void> signOut();

  Future<void> dispose();
}

const String _kLogTag = 'orb.auth';
final RegExp _kEmailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
const int _kMinPasswordLength = 6;

final class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required AuthSessionStorage sessionStorage,
  }) : _remoteDataSource = remoteDataSource,
       _sessionStorage = sessionStorage;

  final AuthRemoteDataSource _remoteDataSource;
  final AuthSessionStorage _sessionStorage;
  final BehaviorSubject<Session?> _sessionSubject = BehaviorSubject<Session?>.seeded(null);

  @override
  Session? get currentSession => _sessionSubject.value;

  @override
  Stream<Session?> get sessionStream => _sessionSubject.stream;

  @override
  Future<void> initialize() async {
    try {
      final stored = await _sessionStorage.read();
      _sessionSubject.add(stored);
    } on AuthStorageError catch (error, stack) {
      AppLogger.error(_kLogTag, 'Failed to restore session', error, stack);
      _sessionSubject.add(null);
    }
  }

  @override
  Future<Session> login({required String email, required String password}) async {
    _validate(email: email, password: password);
    final session = await _remoteDataSource.login(email: email, password: password);
    await _persist(session);
    return session;
  }

  @override
  Future<Session> signup({required String email, required String password}) async {
    _validate(email: email, password: password);
    final session = await _remoteDataSource.signup(email: email, password: password);
    await _persist(session);
    return session;
  }

  @override
  Future<Session> signInWithGoogle() async {
    final session = await _remoteDataSource.signInWithGoogle();
    await _persist(session);
    return session;
  }

  @override
  Future<void> signOut() async {
    try {
      await _remoteDataSource.logout();
    } on Object catch (error, stack) {
      AppLogger.warning(
        _kLogTag,
        'Remote logout failed; clearing local session anyway',
        error,
        stack,
      );
    }
    await _sessionStorage.clear();
    _sessionSubject.add(null);
  }

  @override
  Future<void> dispose() async {
    await _sessionSubject.close();
  }

  Future<void> _persist(Session session) async {
    await _sessionStorage.write(session);
    _sessionSubject.add(session);
  }

  void _validate({required String email, required String password}) {
    if (!_kEmailRegex.hasMatch(email)) {
      throw const AuthValidationError(field: AuthValidationField.email);
    }
    if (password.length < _kMinPasswordLength) {
      throw const AuthValidationError(field: AuthValidationField.password);
    }
  }
}
