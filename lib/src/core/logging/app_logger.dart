import 'dart:developer' as developer;

/// Severity levels for application logs.
///
/// Values are ordered by severity and map to [developer.log] level values.
enum LogLevel implements Comparable<LogLevel> {
  debug(500),
  info(800),
  warning(900),
  error(1000),
  fatal(1200);

  const LogLevel(this.value);

  final int value;

  @override
  int compareTo(LogLevel other) => value.compareTo(other.value);
}

/// A pluggable log output target.
///
/// Implement this to add custom log destinations (e.g. Sentry, Crashlytics).
abstract interface class LogOutput {
  void write(LogLevel level, String tag, String message, [Object? error, StackTrace? stackTrace]);
}

/// Default output that delegates to [developer.log].
class DeveloperLogOutput implements LogOutput {
  const DeveloperLogOutput();

  @override
  void write(LogLevel level, String tag, String message, [Object? error, StackTrace? stackTrace]) {
    developer.log(
      message,
      name: tag,
      time: DateTime.now(),
      level: level.value,
      error: error,
      stackTrace: stackTrace,
    );
  }
}

/// Central logging facade for the application.
///
/// All application logging flows through this class. It delegates to a list
/// of [LogOutput] implementations, making it extensible for crash reporting
/// without changing call sites.
abstract final class AppLogger {
  static final List<LogOutput> _outputs = <LogOutput>[const DeveloperLogOutput()];

  /// Replaces all current outputs. Call once at startup before [runApp].
  static void setOutputs(List<LogOutput> outputs) {
    _outputs
      ..clear()
      ..addAll(outputs);
  }

  /// Adds an output without removing existing ones.
  static void addOutput(LogOutput output) {
    _outputs.add(output);
  }

  static void debug(String tag, String message) => _dispatch(LogLevel.debug, tag, message);

  static void info(String tag, String message) => _dispatch(LogLevel.info, tag, message);

  static void warning(String tag, String message, [Object? error, StackTrace? stackTrace]) =>
      _dispatch(LogLevel.warning, tag, message, error, stackTrace);

  static void error(String tag, String message, [Object? error, StackTrace? stackTrace]) =>
      _dispatch(LogLevel.error, tag, message, error, stackTrace);

  static void fatal(String tag, String message, [Object? error, StackTrace? stackTrace]) =>
      _dispatch(LogLevel.fatal, tag, message, error, stackTrace);

  static void _dispatch(
    LogLevel level,
    String tag,
    String message, [
    Object? error,
    StackTrace? stackTrace,
  ]) {
    for (final output in _outputs) {
      output.write(level, tag, message, error, stackTrace);
    }
  }
}
