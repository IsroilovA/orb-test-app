import 'package:orb_test_app/src/core/logging/app_logger.dart';

/// Mixin that provides a tagged [ScopedLogger] for ergonomic logging.
///
/// Classes that mix this in must override [logTag] to provide a domain tag.
///
/// ```dart
/// class FooRepositoryImpl with Loggable implements FooRepository {
///   @override
///   String get logTag => 'orb.foo';
///
///   void doWork() {
///     log.info('starting work');
///   }
/// }
/// ```
mixin Loggable {
  /// The tag used for all log messages from this class.
  ///
  /// Convention: `'orb.<domain>'` for feature code, `'http'` / `'http_cache'`
  /// for infrastructure.
  String get logTag;

  /// A pre-configured logger that automatically applies [logTag].
  ScopedLogger get log => ScopedLogger(logTag);
}

/// A logger instance bound to a specific [tag].
///
/// Trivially cheap to construct (no allocation beyond the string reference).
class ScopedLogger {
  const ScopedLogger(this.tag);

  final String tag;

  void debug(String message) => AppLogger.debug(tag, message);

  void info(String message) => AppLogger.info(tag, message);

  void warning(String message, [Object? error, StackTrace? stackTrace]) =>
      AppLogger.warning(tag, message, error, stackTrace);

  void error(String message, [Object? error, StackTrace? stackTrace]) =>
      AppLogger.error(tag, message, error, stackTrace);

  void fatal(String message, [Object? error, StackTrace? stackTrace]) =>
      AppLogger.fatal(tag, message, error, stackTrace);
}
