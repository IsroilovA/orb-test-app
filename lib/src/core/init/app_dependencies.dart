import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:orb_test_app/src/core/api_client/api_client.dart';
import 'package:orb_test_app/src/core/api_client/middleware/auth_mw.dart';
import 'package:orb_test_app/src/core/api_client/middleware/logger_mw.dart';
import 'package:orb_test_app/src/core/api_client/middleware/retry_mw.dart';
import 'package:orb_test_app/src/core/storage/key_value_storage.dart';
import 'package:orb_test_app/src/features/auth/data/auth_remote_data_source.dart';
import 'package:orb_test_app/src/features/auth/data/auth_repository.dart';
import 'package:orb_test_app/src/features/auth/data/auth_session_storage.dart';
import 'package:orb_test_app/src/features/auth/data/mock_auth_remote_data_source.dart';
import 'package:orb_test_app/src/features/auth/domain/auth_gate.dart';

const String _kApiBaseUrl = 'https://example.invalid';

final class AppDependencies {
  AppDependencies({required this.keyValueStorage}) {
    const secureStorage = FlutterSecureStorage();
    final AuthSessionStorage sessionStorage = SecureAuthSessionStorage(
      secureStorage: secureStorage,
    );
    final AuthRemoteDataSource remoteDataSource = MockAuthRemoteDataSource();
    authRepository = AuthRepositoryImpl(
      remoteDataSource: remoteDataSource,
      sessionStorage: sessionStorage,
    );
    apiClient = ApiClient(
      baseUrl: _kApiBaseUrl,
      middlewares: <ApiClientMiddleware>[
        const ApiClientLoggerMiddleware(),
        ApiClientAuthMiddleware(
          tokenProvider: () async => authRepository.currentSession?.accessToken,
          onUnauthorized: authRepository.signOut,
        ),
        const ApiClientRetryMiddleware(),
      ],
    );
    authGate = AuthGate(authRepository: authRepository);
  }

  final KeyValueStorage keyValueStorage;
  late final ApiClient apiClient;
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
