import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:orb_test_app/src/features/auth/common/model/auth_user.dart';
import 'package:orb_test_app/src/features/auth/common/model/session.dart';
import 'package:orb_test_app/src/features/auth/data/auth_repository.dart';
import 'package:orb_test_app/src/features/home/common/model/home_business.dart';
import 'package:orb_test_app/src/features/home/common/model/home_error.dart';
import 'package:orb_test_app/src/features/home/data/home_remote_data_source.dart';
import 'package:orb_test_app/src/features/home/data/home_repository.dart';

class _MockAuthRepository extends Mock implements AuthRepository {}

class _MockHomeRemoteDataSource extends Mock implements HomeRemoteDataSource {}

void main() {
  const session = Session(
    accessToken: 'mock-access-token',
    user: AuthUser(email: 'owner@test.com', displayName: 'Owner'),
  );
  const businesses = <HomeBusiness>[
    HomeBusiness(
      id: 'north_star',
      name: 'North Star Logistics',
      description: 'Shipment monitoring across three regional warehouses.',
      revenue: 1824500,
      employeeCount: 84,
    ),
  ];

  late _MockAuthRepository authRepository;
  late _MockHomeRemoteDataSource remoteDataSource;
  late HomeRepository repository;

  setUp(() {
    authRepository = _MockAuthRepository();
    remoteDataSource = _MockHomeRemoteDataSource();
    repository = HomeRepositoryImpl(
      authRepository: authRepository,
      remoteDataSource: remoteDataSource,
    );
  });

  test('returns overview for active session', () async {
    when(() => authRepository.currentSession).thenReturn(session);
    when(
      () => remoteDataSource.loadBusinesses(userEmail: session.user.email),
    ).thenAnswer((_) async => businesses);

    final overview = await repository.loadOverview();

    expect(overview.user, session.user);
    expect(overview.businesses, businesses);
    verify(() => remoteDataSource.loadBusinesses(userEmail: session.user.email)).called(1);
  });

  test('throws unauthenticated error when session is missing', () async {
    when(() => authRepository.currentSession).thenReturn(null);

    await expectLater(repository.loadOverview(), throwsA(isA<HomeUnauthenticatedError>()));
    verifyNever(() => remoteDataSource.loadBusinesses(userEmail: any(named: 'userEmail')));
  });

  test('wraps unexpected remote errors in HomeLoadFailedError', () async {
    when(() => authRepository.currentSession).thenReturn(session);
    when(
      () => remoteDataSource.loadBusinesses(userEmail: session.user.email),
    ).thenThrow(Exception('boom'));

    await expectLater(
      repository.loadOverview(),
      throwsA(
        isA<HomeLoadFailedError>().having(
          (HomeLoadFailedError error) => error.cause,
          'cause',
          isA<Exception>(),
        ),
      ),
    );
  });

  test('rethrows existing HomeError values unchanged', () async {
    const error = HomeLoadFailedError(cause: 'boom');
    when(() => authRepository.currentSession).thenReturn(session);
    when(() => remoteDataSource.loadBusinesses(userEmail: session.user.email)).thenThrow(error);

    await expectLater(repository.loadOverview(), throwsA(same(error)));
  });
}
