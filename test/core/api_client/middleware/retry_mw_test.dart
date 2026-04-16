import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:orb_test_app/src/core/api_client/api_client.dart';
import 'package:orb_test_app/src/core/api_client/middleware/retry_mw.dart';

void main() {
  group('ApiClientRetryMiddleware', () {
    test('retries retryable errors until success', () async {
      var callCount = 0;
      final middleware = ApiClientRetryMiddleware(maxRetries: 2, delay: (_) => Duration.zero);

      final response =
          await middleware((request, context) async {
            callCount += 1;
            if (callCount < 3) {
              throw const ApiClientNetworkException(
                code: 'network_error',
                message: 'Network error',
                statusCode: 0,
              );
            }

            return ApiClientResponse.json(
              <String, Object?>{},
              statusCode: 200,
              headers: const <String, String>{},
              contentLength: 0,
              persistentConnection: false,
              request: request,
            );
          })(
            ApiClientRequest(Request('GET', Uri.parse('https://example.com/home'))),
            <String, Object?>{},
          );

      expect(response.statusCode, 200);
      expect(callCount, 3);
    });

    test('stops after max retries', () async {
      var callCount = 0;
      final middleware = ApiClientRetryMiddleware(maxRetries: 2, delay: (_) => Duration.zero);

      final future =
          middleware((request, context) async {
            callCount += 1;
            throw const ApiClientNetworkException(
              code: 'network_error',
              message: 'Network error',
              statusCode: 0,
            );
          })(
            ApiClientRequest(Request('GET', Uri.parse('https://example.com/home'))),
            <String, Object?>{},
          );

      await expectLater(future, throwsA(isA<ApiClientNetworkException>()));
      expect(callCount, 3);
    });

    test('does not retry non-retryable errors', () async {
      var callCount = 0;
      final middleware = ApiClientRetryMiddleware(maxRetries: 2, delay: (_) => Duration.zero);

      final future =
          middleware((request, context) async {
            callCount += 1;
            throw const ApiClientClientException(
              code: 'bad_request',
              message: 'Bad request',
              statusCode: 400,
            );
          })(
            ApiClientRequest(Request('GET', Uri.parse('https://example.com/home'))),
            <String, Object?>{},
          );

      await expectLater(future, throwsA(isA<ApiClientClientException>()));
      expect(callCount, 1);
    });
  });
}
