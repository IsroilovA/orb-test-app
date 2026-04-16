import 'dart:async';

import 'package:meta/meta.dart';
import 'package:orb_test_app/src/core/api_client/api_client.dart';

/// A function that asynchronously retrieves an authentication token.
/// It should return `null` if no token is available.
typedef TokenProvider = Future<String?> Function();

/// Called when a request fails with `401 Unauthorized`.
typedef OnUnauthorized = Future<void> Function();

/// A function that builds the authorization header map from a given token.
typedef AuthHeaderBuilder = Map<String, String> Function(String token);

/// The default implementation for building an authorization header.
/// Creates a `{'Authorization': 'Bearer <token>'}` map.
Map<String, String> _defaultHeaderBuilder(String token) => {'Authorization': 'Bearer $token'};

/// A middleware that injects an authentication token into requests.
@immutable
class ApiClientAuthMiddleware implements ApiClientMiddleware {
  /// Creates a new [ApiClientAuthMiddleware].
  ///
  /// - [tokenProvider]: A required function to get the current auth token.
  /// - [onUnauthorized]: Called when a request returns 401.
  /// - [headerBuilder]: An optional function to customize the auth header.
  const ApiClientAuthMiddleware({
    required this.tokenProvider,
    this.onUnauthorized,
    AuthHeaderBuilder? headerBuilder,
  }) : _headerBuilder = headerBuilder ?? _defaultHeaderBuilder;

  /// The function that provides the current access token.
  final TokenProvider tokenProvider;

  /// Called when a request returns 401.
  final OnUnauthorized? onUnauthorized;

  /// The function that builds the authorization header.
  final AuthHeaderBuilder _headerBuilder;

  /// Context key used to bypass auth header injection.
  static const skipAuthKey = 'skipAuth';

  @override
  ApiClientHandler call(ApiClientHandler innerHandler) => (request, context) async {
    if (context[skipAuthKey] == true) return innerHandler(request, context);

    final initialToken = await tokenProvider();
    var authorizedRequest = request;
    if (initialToken != null) {
      final authHeaders = _headerBuilder(initialToken);
      authorizedRequest = ApiClientRequest(cloneBaseRequest(request)..headers.addAll(authHeaders));
    }

    try {
      return await innerHandler(authorizedRequest, context);
    } on ApiClientAuthorizationException {
      await onUnauthorized?.call();
      rethrow;
    }
  };
}
