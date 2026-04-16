import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
final class HomeBusiness extends Equatable {
  const HomeBusiness({
    required this.id,
    required this.name,
    required this.description,
    required this.revenue,
    required this.employeeCount,
  });

  final String id;
  final String name;
  final String description;
  final double revenue;
  final int employeeCount;

  @override
  List<Object?> get props => <Object?>[id, name, description, revenue, employeeCount];

  @override
  String toString() => 'HomeBusiness(id: $id, name: $name, revenue: $revenue, employeeCount: $employeeCount)';
}
