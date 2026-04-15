import 'package:mocktail/mocktail.dart';
import 'package:orb_test_app/src/features/auth/common/model/auth_user.dart';
import 'package:orb_test_app/src/features/auth/common/model/session.dart';

void registerTestFallbackValues() {
  registerFallbackValue(
    const Session(
      accessToken: '',
      user: AuthUser(email: '', displayName: ''),
    ),
  );
}
