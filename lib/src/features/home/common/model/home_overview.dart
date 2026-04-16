import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:orb_test_app/src/features/auth/common/model/auth_user.dart';
import 'package:orb_test_app/src/features/home/common/model/home_business.dart';

@immutable
final class HomeOverview extends Equatable {
  const HomeOverview({required this.user, required this.businesses});

  final AuthUser user;
  final List<HomeBusiness> businesses;

  @override
  List<Object?> get props => <Object?>[user, businesses];

  @override
  String toString() => 'HomeOverview(user: $user, businesses: ${businesses.length})';
}
