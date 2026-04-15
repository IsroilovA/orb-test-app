import 'package:orb_test_app/src/features/auth/common/model/auth_error.dart';
import 'package:orb_test_app/src/features/auth/common/model/auth_user.dart';
import 'package:orb_test_app/src/features/auth/common/model/session.dart';
import 'package:orb_test_app/src/features/auth/data/auth_remote_data_source.dart';

const Duration _kMockLatency = Duration(milliseconds: 300);
const String _kGoogleEmail = 'google@example.com';

final class MockAuthRemoteDataSource implements AuthRemoteDataSource {
  MockAuthRemoteDataSource();

  final Map<String, String> _accounts = <String, String>{'test@test.com': 'password'};

  @override
  Future<Session> login({required String email, required String password}) async {
    await Future<void>.delayed(_kMockLatency);
    final stored = _accounts[email];
    if (stored == null || stored != password) {
      throw const AuthInvalidCredentialsError();
    }
    return _buildSession(email);
  }

  @override
  Future<Session> signup({required String email, required String password}) async {
    await Future<void>.delayed(_kMockLatency);
    if (_accounts.containsKey(email)) {
      throw const AuthEmailAlreadyExistsError();
    }
    _accounts[email] = password;
    return _buildSession(email);
  }

  @override
  Future<Session> signInWithGoogle() async {
    await Future<void>.delayed(_kMockLatency);
    _accounts.putIfAbsent(_kGoogleEmail, () => '__google__');
    return _buildSession(_kGoogleEmail);
  }

  @override
  Future<void> logout() async {
    await Future<void>.delayed(_kMockLatency);
  }

  Session _buildSession(String email) {
    final displayName = email.split('@').first;
    return Session(
      accessToken: 'mock-$email',
      user: AuthUser(email: email, displayName: displayName),
    );
  }
}
