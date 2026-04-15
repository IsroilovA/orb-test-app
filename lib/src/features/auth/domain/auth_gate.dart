import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:orb_test_app/src/features/auth/common/model/session.dart';
import 'package:orb_test_app/src/features/auth/data/auth_repository.dart';

final class AuthGate extends ChangeNotifier {
  AuthGate({required AuthRepository authRepository}) : _authRepository = authRepository {
    _isAuthenticated = _authRepository.currentSession != null;
    _subscription = _authRepository.sessionStream.listen(_onSessionChanged);
  }

  final AuthRepository _authRepository;
  late StreamSubscription<Session?> _subscription;
  late bool _isAuthenticated;

  bool get isAuthenticated => _isAuthenticated;

  void _onSessionChanged(Session? session) {
    final next = session != null;
    if (next == _isAuthenticated) return;
    _isAuthenticated = next;
    notifyListeners();
  }

  @override
  void dispose() {
    unawaited(_subscription.cancel());
    super.dispose();
  }
}
