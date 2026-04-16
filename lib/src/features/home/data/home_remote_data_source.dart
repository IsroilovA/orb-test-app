import 'package:orb_test_app/src/features/home/common/model/home_business.dart';

abstract interface class HomeRemoteDataSource {
  Future<List<HomeBusiness>> loadBusinesses({required String userEmail});
}
