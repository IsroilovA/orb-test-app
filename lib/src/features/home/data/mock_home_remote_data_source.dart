import 'package:orb_test_app/src/features/home/common/model/home_business.dart';
import 'package:orb_test_app/src/features/home/data/home_remote_data_source.dart';

const Duration _kMockLatency = Duration(milliseconds: 250);

final class MockHomeRemoteDataSource implements HomeRemoteDataSource {
  const MockHomeRemoteDataSource();

  @override
  Future<List<HomeBusiness>> loadBusinesses({required String userEmail}) async {
    await Future<void>.delayed(_kMockLatency);

    final businessPrefix = userEmail.split('@').first;

    return <HomeBusiness>[
      HomeBusiness(
        id: '${businessPrefix}_north_star',
        name: 'North Star Logistics',
        description: 'Shipment monitoring across three regional warehouses.',
        revenue: 1824500,
        employeeCount: 84,
      ),
      HomeBusiness(
        id: '${businessPrefix}_green_farm',
        name: 'Green Farm Foods',
        description: 'Fresh produce distribution with daily cold-chain tracking.',
        revenue: 964000,
        employeeCount: 31,
      ),
      HomeBusiness(
        id: '${businessPrefix}_luma_health',
        name: 'Luma Health Lab',
        description: 'Diagnostic operations dashboard for clinic partners.',
        revenue: 2378000,
        employeeCount: 116,
      ),
    ];
  }
}
