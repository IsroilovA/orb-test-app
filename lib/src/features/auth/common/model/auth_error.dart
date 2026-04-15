import 'package:orb_test_app/src/core/localization/l10n.dart';

sealed class AuthError implements Exception, Localizable {
  const AuthError();
}

final class AuthInvalidCredentialsError extends AuthError {
  const AuthInvalidCredentialsError();

  @override
  String localize(AppLocalizations localizations) => localizations.authErrorInvalidCredentials;

  @override
  String toString() => 'AuthInvalidCredentialsError';
}

final class AuthEmailAlreadyExistsError extends AuthError {
  const AuthEmailAlreadyExistsError();

  @override
  String localize(AppLocalizations localizations) => localizations.authErrorEmailAlreadyExists;

  @override
  String toString() => 'AuthEmailAlreadyExistsError';
}

enum AuthValidationField { email, password }

final class AuthValidationError extends AuthError {
  const AuthValidationError({required this.field});

  final AuthValidationField field;

  @override
  String localize(AppLocalizations localizations) => switch (field) {
    AuthValidationField.email => localizations.authErrorInvalidEmail,
    AuthValidationField.password => localizations.authErrorWeakPassword,
  };

  @override
  String toString() => 'AuthValidationError(field: $field)';
}

final class AuthStorageError extends AuthError {
  const AuthStorageError({required this.cause});

  final Object cause;

  @override
  String localize(AppLocalizations localizations) => localizations.authErrorStorage;

  @override
  String toString() => 'AuthStorageError(cause: $cause)';
}

final class AuthUnknownError extends AuthError {
  const AuthUnknownError({this.cause});

  final Object? cause;

  @override
  String localize(AppLocalizations localizations) => localizations.authErrorUnknown;

  @override
  String toString() => 'AuthUnknownError(cause: $cause)';
}
