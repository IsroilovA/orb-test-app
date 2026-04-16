import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:orb_test_app/src/features/auth/common/model/auth_user.dart';
import 'package:orb_test_app/src/features/home/bloc/home_bloc.dart';
import 'package:orb_test_app/src/features/home/common/model/home_business.dart';
import 'package:orb_test_app/src/features/home/common/model/home_error.dart';
import 'package:orb_test_app/src/features/home/common/model/home_overview.dart';
import 'package:orb_test_app/src/features/home/data/home_repository.dart';

class _MockHomeRepository extends Mock implements HomeRepository {}

void main() {
  const overview = HomeOverview(
    user: AuthUser(email: 'owner@test.com', displayName: 'Owner'),
    businesses: <HomeBusiness>[
      HomeBusiness(
        id: 'north_star',
        name: 'North Star Logistics',
        description: 'Shipment monitoring across three regional warehouses.',
        revenue: 1824500,
        employeeCount: 84,
      ),
    ],
  );

  late _MockHomeRepository homeRepository;

  setUp(() {
    homeRepository = _MockHomeRepository();
  });

  blocTest<HomeBloc, HomeState>(
    'emits loading then success on start',
    setUp: () {
      when(homeRepository.loadOverview).thenAnswer((_) async => overview);
    },
    build: () => HomeBloc(homeRepository: homeRepository),
    act: (bloc) => bloc.add(const HomeStarted()),
    expect: () => <HomeState>[
      const HomeState(isLoading: true),
      const HomeState(overview: overview),
    ],
  );

  blocTest<HomeBloc, HomeState>(
    'emits loading then failure on repository error',
    setUp: () {
      when(homeRepository.loadOverview).thenThrow(const HomeLoadFailedError(cause: 'boom'));
    },
    build: () => HomeBloc(homeRepository: homeRepository),
    act: (bloc) => bloc.add(const HomeStarted()),
    expect: () => <Matcher>[
      isA<HomeState>().having((HomeState state) => state.isLoading, 'isLoading', true),
      isA<HomeState>().having(
        (HomeState state) => state.error,
        'error',
        isA<HomeLoadFailedError>(),
      ),
    ],
  );

  blocTest<HomeBloc, HomeState>(
    'retries after failure',
    setUp: () {
      var callCount = 0;
      when(homeRepository.loadOverview).thenAnswer((_) async {
        callCount += 1;
        if (callCount == 1) {
          throw const HomeLoadFailedError(cause: 'boom');
        }
        return overview;
      });
    },
    build: () => HomeBloc(homeRepository: homeRepository),
    act: (bloc) {
      bloc.add(const HomeStarted());
      bloc.add(const HomeRetried());
    },
    expect: () => <Matcher>[
      isA<HomeState>().having((HomeState state) => state.isLoading, 'isLoading', true),
      isA<HomeState>().having(
        (HomeState state) => state.error,
        'error',
        isA<HomeLoadFailedError>(),
      ),
      isA<HomeState>().having((HomeState state) => state.isLoading, 'isLoading', true),
      isA<HomeState>().having((HomeState state) => state.overview, 'overview', overview),
    ],
  );
}
