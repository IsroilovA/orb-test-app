import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
final class AuthUser extends Equatable {
  const AuthUser({required this.email, required this.displayName});

  factory AuthUser.fromJson(Map<String, Object?> json) =>
      AuthUser(email: json['email']! as String, displayName: json['displayName']! as String);

  final String email;
  final String displayName;

  Map<String, Object?> toJson() => <String, Object?>{'email': email, 'displayName': displayName};

  @override
  List<Object?> get props => <Object?>[email, displayName];

  @override
  String toString() => 'AuthUser(email: $email, displayName: $displayName)';
}
