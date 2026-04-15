import 'package:orb_test_app/src/features/auth/common/model/session.dart';

abstract interface class AuthRemoteDataSource {
  Future<Session> login({required String email, required String password});

  Future<Session> signup({required String email, required String password});

  Future<Session> signInWithGoogle();

  Future<void> logout();
}
