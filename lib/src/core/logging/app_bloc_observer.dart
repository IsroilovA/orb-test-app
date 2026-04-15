import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:orb_test_app/src/core/logging/app_logger.dart';

/// Global [BlocObserver] that routes BLoC lifecycle events to [AppLogger].
class AppBlocObserver extends BlocObserver {
  const AppBlocObserver();

  static const String _tag = 'bloc';

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    AppLogger.error(_tag, '${bloc.runtimeType}', error, stackTrace);
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onTransition(Bloc<dynamic, dynamic> bloc, Transition<dynamic, dynamic> transition) {
    if (kDebugMode) {
      AppLogger.debug(
        _tag,
        '${bloc.runtimeType} ${transition.event.runtimeType}: '
        '${transition.currentState.runtimeType} -> ${transition.nextState.runtimeType}',
      );
    }
    super.onTransition(bloc, transition);
  }
}
