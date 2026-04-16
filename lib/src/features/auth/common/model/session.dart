import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:orb_test_app/src/features/auth/common/model/auth_user.dart';

@immutable
final class Session extends Equatable {
  const Session({required this.accessToken, required this.user});

  factory Session.fromJson(Map<String, Object?> json) => Session(
    accessToken: json['accessToken']! as String,
    user: AuthUser.fromJson(json['user']! as Map<String, Object?>),
  );

  final String accessToken;
  final AuthUser user;

  Map<String, Object?> toJson() => <String, Object?>{
    'accessToken': accessToken,
    'user': user.toJson(),
  };

  @override
  List<Object?> get props => <Object?>[accessToken, user];

  @override
  String toString() => 'Session(user: $user)';
}
