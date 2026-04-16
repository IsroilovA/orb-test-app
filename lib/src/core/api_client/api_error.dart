part of 'api_client.dart';

/// Centralized typed API errors mapped from [ApiClientException].
///
/// Each subclass corresponds to a specific HTTP status code or server error code.
sealed class ApiError implements Exception, Localizable {
  const ApiError();

  /// Converts an [ApiClientException] into the most specific [ApiError] subclass.
  factory ApiError.fromApiException(ApiClientException e) {
    return switch (e) {
      ApiClientAuthorizationException() => const ApiUnauthorizedError(),
      ApiClientNetworkException(:final statusCode) when statusCode >= 500 =>
        const ApiInternalError(),
      ApiClientNetworkException() => const ApiNetworkError(),
      ApiClientClientException(:final statusCode, :final data, :final responseHeaders) => () {
        final code = _serverErrorCode(data);

        if (statusCode == 403) return const ApiForbiddenError();
        if (statusCode == 404) return const ApiNotFoundError();
        if (statusCode == 409) return const ApiConflictError();
        if (statusCode == 422 || code == 'VALIDATION_ERROR') {
          return ApiValidationError(message: _serverMessage(data));
        }
        if (statusCode == 429) {
          return ApiRateLimitedError(retryAfter: _parseRetryAfter(responseHeaders));
        }
        return ApiUnknownError(e);
      }(),
    };
  }

  static String? _serverErrorCode(Object? data) {
    if (data is! Map<String, Object?>) return null;
    final error = data['error'];
    if (error is! Map<String, Object?>) return null;
    return error['code'] as String?;
  }

  static String? _serverMessage(Object? data) {
    if (data is! Map<String, Object?>) return null;
    final error = data['error'];
    if (error is! Map<String, Object?>) return null;
    return error['message'] as String?;
  }

  static Duration? _parseRetryAfter(Map<String, String> headers) {
    final value = headers['retry-after'];
    if (value == null) return null;
    final seconds = int.tryParse(value);
    if (seconds == null) return null;
    return Duration(seconds: seconds);
  }
}

final class ApiUnauthorizedError extends ApiError {
  const ApiUnauthorizedError();

  @override
  String localize(AppLocalizations localizations) => localizations.apiErrorUnauthorized;

  @override
  String toString() => 'ApiUnauthorizedError';
}

final class ApiForbiddenError extends ApiError {
  const ApiForbiddenError();

  @override
  String localize(AppLocalizations localizations) => localizations.apiErrorForbidden;

  @override
  String toString() => 'ApiForbiddenError';
}

final class ApiNotFoundError extends ApiError {
  const ApiNotFoundError();

  @override
  String localize(AppLocalizations localizations) => localizations.apiErrorNotFound;

  @override
  String toString() => 'ApiNotFoundError';
}

final class ApiConflictError extends ApiError {
  const ApiConflictError();

  @override
  String localize(AppLocalizations localizations) => localizations.apiErrorConflict;

  @override
  String toString() => 'ApiConflictError';
}

final class ApiValidationError extends ApiError {
  const ApiValidationError({this.message});

  final String? message;

  @override
  String localize(AppLocalizations localizations) => message ?? localizations.apiErrorValidation;

  @override
  String toString() => 'ApiValidationError(message: $message)';
}

final class ApiRateLimitedError extends ApiError {
  const ApiRateLimitedError({this.retryAfter});

  final Duration? retryAfter;

  @override
  String localize(AppLocalizations localizations) => localizations.apiErrorRateLimited;

  @override
  String toString() => 'ApiRateLimitedError(retryAfter: $retryAfter)';
}

final class ApiInternalError extends ApiError {
  const ApiInternalError();

  @override
  String localize(AppLocalizations localizations) => localizations.apiErrorInternal;

  @override
  String toString() => 'ApiInternalError';
}

final class ApiNetworkError extends ApiError {
  const ApiNetworkError();

  @override
  String localize(AppLocalizations localizations) => localizations.apiErrorNetwork;

  @override
  String toString() => 'ApiNetworkError';
}

final class ApiUnknownError extends ApiError {
  const ApiUnknownError([this.cause]);

  final Object? cause;

  @override
  String localize(AppLocalizations localizations) => localizations.apiErrorUnknown;

  @override
  String toString() => 'ApiUnknownError(cause: $cause)';
}
