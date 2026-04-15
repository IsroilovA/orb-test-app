import 'package:meta/meta.dart';

import 'package:orb_test_app/src/core/api_client/api_client.dart';
import 'package:orb_test_app/src/core/logging/app_logger.dart';

typedef Logger = void Function(String msg);

typedef ErrorLogger = void Function(String msg, Object? error, StackTrace stackTrace);

void _defaultLogger(String msg) => AppLogger.info('http', msg);

void _defaultErrorLogger(String msg, Object? error, StackTrace stackTrace) =>
    AppLogger.error('http', msg, error, stackTrace);

@immutable
class ApiClientLoggerMiddleware implements ApiClientMiddleware {
  const ApiClientLoggerMiddleware({
    Logger? onRequest,
    Logger? onResponse,
    ErrorLogger? onError,
    this.logRequest = false,
    this.logResponse = true,
    this.logError = true,
  }) : _onRequest = onRequest ?? _defaultLogger,
       _onResponse = onResponse ?? _defaultLogger,
       _onError = onError ?? _defaultErrorLogger;

  final Logger _onRequest;
  final Logger _onResponse;
  final ErrorLogger _onError;

  final bool logRequest;
  final bool logResponse;
  final bool logError;

  @override
  ApiClientHandler call(ApiClientHandler innerHandler) => (request, context) async {
    final stopwatch = Stopwatch()..start();
    try {
      if (logRequest) {
        _onRequest('[${request.method}] ${request.url.path}');
      }
      final response = await innerHandler(request, context);
      if (logResponse) {
        _onResponse('[${request.method}] ${request.url.path} -> ok | ${stopwatch.elapsedMilliseconds}ms');
      }
      return response;
    } on ApiClientException catch (error, stackTrace) {
      if (logError) {
        final body = error.data != null ? '\nResponse body: ${error.data}' : '';
        _onError(
          '[${request.method}] ${request.url.path} -> failed with ${error.statusCode} code | ${stopwatch.elapsedMilliseconds}ms$body',
          error,
          stackTrace,
        );
      }
      rethrow;
    } finally {
      stopwatch.stop();
    }
  };
}
