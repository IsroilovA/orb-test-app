import 'package:orb_test_app/src/features/auth/data/auth_repository.dart';
import 'package:orb_test_app/src/features/home/common/model/home_error.dart';
import 'package:orb_test_app/src/features/home/common/model/home_overview.dart';
import 'package:orb_test_app/src/features/home/data/home_remote_data_source.dart';

abstract interface class HomeRepository {
  Future<HomeOverview> loadOverview();
}

final class HomeRepositoryImpl implements HomeRepository {
  const HomeRepositoryImpl({
    required AuthRepository authRepository,
    required HomeRemoteDataSource remoteDataSource,
  }) : _authRepository = authRepository,
       _remoteDataSource = remoteDataSource;

  final AuthRepository _authRepository;
  final HomeRemoteDataSource _remoteDataSource;

  @override
  Future<HomeOverview> loadOverview() async {
    final session = _authRepository.currentSession;
    if (session == null) {
      throw const HomeUnauthenticatedError();
    }

    try {
      final businesses = await _remoteDataSource.loadBusinesses(userEmail: session.user.email);
      return HomeOverview(user: session.user, businesses: businesses);
    } on HomeError {
      rethrow;
    } on Object catch (error) {
      throw HomeLoadFailedError(cause: error);
    }
  }
}
