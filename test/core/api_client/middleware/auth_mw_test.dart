import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:orb_test_app/src/core/api_client/api_client.dart';
import 'package:orb_test_app/src/core/api_client/middleware/auth_mw.dart';

void main() {
  group('ApiClientAuthMiddleware', () {
    test('injects bearer token when available', () async {
      final middleware = ApiClientAuthMiddleware(tokenProvider: () async => 'token');
      late ApiClientRequest receivedRequest;

      final response =
          await middleware((request, context) async {
            receivedRequest = request;
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
      expect(receivedRequest.headers['Authorization'], 'Bearer token');
    });

    test('skips auth injection when skipAuth is enabled', () async {
      final middleware = ApiClientAuthMiddleware(tokenProvider: () async => 'token');
      late ApiClientRequest receivedRequest;

      await middleware((request, context) async {
        receivedRequest = request;
        return ApiClientResponse.json(
          <String, Object?>{},
          statusCode: 200,
          headers: const <String, String>{},
          contentLength: 0,
          persistentConnection: false,
          request: request,
        );
      })(ApiClientRequest(Request('GET', Uri.parse('https://example.com/home'))), <String, Object?>{
        ApiClientAuthMiddleware.skipAuthKey: true,
      });

      expect(receivedRequest.headers.containsKey('Authorization'), isFalse);
    });

    test('calls onUnauthorized and rethrows on 401', () async {
      var unauthorizedCount = 0;
      final middleware = ApiClientAuthMiddleware(
        tokenProvider: () async => 'token',
        onUnauthorized: () async {
          unauthorizedCount += 1;
        },
      );

      final future =
          middleware((request, context) async {
            throw const ApiClientAuthorizationException(
              code: 'unauthorized',
              message: 'Unauthorized',
              statusCode: 401,
            );
          })(
            ApiClientRequest(Request('GET', Uri.parse('https://example.com/home'))),
            <String, Object?>{},
          );

      await expectLater(future, throwsA(isA<ApiClientAuthorizationException>()));
      expect(unauthorizedCount, 1);
    });
  });
}
