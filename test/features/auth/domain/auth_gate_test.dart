import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:orb_test_app/src/features/auth/common/model/auth_user.dart';
import 'package:orb_test_app/src/features/auth/common/model/session.dart';
import 'package:orb_test_app/src/features/auth/data/auth_repository.dart';
import 'package:orb_test_app/src/features/auth/domain/auth_gate.dart';

const _session = Session(
  accessToken: 'token',
  user: AuthUser(email: 'test@test.com', displayName: 'test'),
);

final class _TestAuthRepository implements AuthRepository {
  _TestAuthRepository({required Session? currentSession}) : _currentSession = currentSession;

  final StreamController<Session?> _controller = StreamController<Session?>.broadcast();
  Session? _currentSession;

  @override
  Session? get currentSession => _currentSession;

  @override
  Stream<Session?> get sessionStream => _controller.stream;

  void emit(Session? session) {
    _currentSession = session;
    _controller.add(session);
  }

  @override
  Future<void> dispose() async {
    await _controller.close();
  }

  @override
  Future<void> initialize() async {}

  @override
  Future<Session> login({required String email, required String password}) =>
      throw UnimplementedError();

  @override
  Future<Session> signInWithGoogle() => throw UnimplementedError();

  @override
  Future<void> signOut() => throw UnimplementedError();

  @override
  Future<Session> signup({required String email, required String password}) =>
      throw UnimplementedError();
}

void main() {
  group('AuthGate', () {
    test('starts authenticated when repository already has a session', () {
      final repository = _TestAuthRepository(currentSession: _session);
      addTearDown(repository.dispose);

      final gate = AuthGate(authRepository: repository);
      addTearDown(gate.dispose);

      expect(gate.isAuthenticated, isTrue);
    });

    test('starts unauthenticated when repository has no session', () {
      final repository = _TestAuthRepository(currentSession: null);
      addTearDown(repository.dispose);

      final gate = AuthGate(authRepository: repository);
      addTearDown(gate.dispose);

      expect(gate.isAuthenticated, isFalse);
    });

    test('notifies listeners only when auth state changes', () async {
      final repository = _TestAuthRepository(currentSession: null);
      addTearDown(repository.dispose);

      final gate = AuthGate(authRepository: repository);
      addTearDown(gate.dispose);

      var notificationCount = 0;
      gate.addListener(() {
        notificationCount += 1;
      });

      repository.emit(null);
      await Future<void>.delayed(Duration.zero);
      repository.emit(_session);
      await Future<void>.delayed(Duration.zero);
      repository.emit(_session);
      await Future<void>.delayed(Duration.zero);
      repository.emit(null);
      await Future<void>.delayed(Duration.zero);

      expect(notificationCount, 2);
      expect(gate.isAuthenticated, isFalse);
    });
  });
}
