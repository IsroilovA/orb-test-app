import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:orb_test_app/src/core/storage/key_value_storage.dart';
import 'package:orb_test_app/src/features/auth/data/auth_remote_data_source.dart';
import 'package:orb_test_app/src/features/auth/data/auth_repository.dart';
import 'package:orb_test_app/src/features/auth/data/auth_session_storage.dart';
import 'package:orb_test_app/src/features/auth/data/mock_auth_remote_data_source.dart';
import 'package:orb_test_app/src/features/auth/domain/auth_gate.dart';

final class AppDependencies {
  AppDependencies({required this.keyValueStorage}) {
    const secureStorage = FlutterSecureStorage();
    final AuthSessionStorage sessionStorage = SecureAuthSessionStorage(secureStorage: secureStorage);
    final AuthRemoteDataSource remoteDataSource = MockAuthRemoteDataSource();
    authRepository = AuthRepositoryImpl(remoteDataSource: remoteDataSource, sessionStorage: sessionStorage);
    authGate = AuthGate(authRepository: authRepository);
  }

  final KeyValueStorage keyValueStorage;
  late final AuthRepository authRepository;
  late final AuthGate authGate;

  Future<void> initialize() async {
    await authRepository.initialize();
  }

  Future<void> dispose() async {
    authGate.dispose();
    await authRepository.dispose();
  }
}
