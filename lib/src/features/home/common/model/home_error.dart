import 'package:orb_test_app/src/core/localization/l10n.dart';

sealed class HomeError implements Exception, Localizable {
  const HomeError();
}

final class HomeUnauthenticatedError extends HomeError {
  const HomeUnauthenticatedError();

  @override
  String localize(AppLocalizations localizations) => localizations.homeLoadError;
}

final class HomeLoadFailedError extends HomeError {
  const HomeLoadFailedError({required this.cause});

  final Object cause;

  @override
  String localize(AppLocalizations localizations) => localizations.homeLoadError;
}
