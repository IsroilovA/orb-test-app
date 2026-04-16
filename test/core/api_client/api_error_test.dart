import 'package:flutter_test/flutter_test.dart';
import 'package:orb_test_app/src/core/api_client/api_client.dart';

void main() {
  group('ApiError.fromApiException', () {
    test('maps 401 to ApiUnauthorizedError', () {
      final error = ApiError.fromApiException(
        const ApiClientAuthorizationException(
          code: 'unauthorized',
          message: 'Unauthorized',
          statusCode: 401,
        ),
      );

      expect(error, isA<ApiUnauthorizedError>());
    });

    test('maps 403 to ApiForbiddenError', () {
      final error = ApiError.fromApiException(
        const ApiClientClientException(code: 'forbidden', message: 'Forbidden', statusCode: 403),
      );

      expect(error, isA<ApiForbiddenError>());
    });

    test('maps 404 to ApiNotFoundError', () {
      final error = ApiError.fromApiException(
        const ApiClientClientException(code: 'not_found', message: 'Not found', statusCode: 404),
      );

      expect(error, isA<ApiNotFoundError>());
    });

    test('maps 409 to ApiConflictError', () {
      final error = ApiError.fromApiException(
        const ApiClientClientException(code: 'conflict', message: 'Conflict', statusCode: 409),
      );

      expect(error, isA<ApiConflictError>());
    });

    test('maps 422 to ApiValidationError with server message', () {
      final error = ApiError.fromApiException(
        const ApiClientClientException(
          code: 'validation',
          message: 'Validation',
          statusCode: 422,
          data: <String, Object?>{
            'error': <String, Object?>{'message': 'Invalid payload'},
          },
        ),
      );

      expect(
        error,
        isA<ApiValidationError>().having(
          (ApiValidationError value) => value.message,
          'message',
          'Invalid payload',
        ),
      );
    });

    test('maps VALIDATION_ERROR code to ApiValidationError', () {
      final error = ApiError.fromApiException(
        const ApiClientClientException(
          code: 'bad_request',
          message: 'Bad request',
          statusCode: 400,
          data: <String, Object?>{
            'error': <String, Object?>{'code': 'VALIDATION_ERROR'},
          },
        ),
      );

      expect(error, isA<ApiValidationError>());
    });

    test('maps 429 to ApiRateLimitedError with retryAfter', () {
      final error = ApiError.fromApiException(
        const ApiClientClientException(
          code: 'rate_limited',
          message: 'Rate limited',
          statusCode: 429,
          responseHeaders: <String, String>{'retry-after': '12'},
        ),
      );

      expect(
        error,
        isA<ApiRateLimitedError>().having(
          (ApiRateLimitedError value) => value.retryAfter,
          'retryAfter',
          const Duration(seconds: 12),
        ),
      );
    });

    test('maps 5xx network exceptions to ApiInternalError', () {
      final error = ApiError.fromApiException(
        const ApiClientNetworkException(
          code: 'server_error',
          message: 'Server error',
          statusCode: 500,
        ),
      );

      expect(error, isA<ApiInternalError>());
    });

    test('maps non-5xx network exceptions to ApiNetworkError', () {
      final error = ApiError.fromApiException(
        const ApiClientNetworkException(
          code: 'network_error',
          message: 'Network error',
          statusCode: 0,
        ),
      );

      expect(error, isA<ApiNetworkError>());
    });
  });
}
