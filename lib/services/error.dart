import 'package:sentry/sentry.dart';

class ErrorService {
  static final _sentry = SentryClient(
    dsn: 'https://c67cfc459f304dac8f043c3bad519336@sentry.io/1898336',
  );

  static bool get isInDebugMode {
    // Assume you're in production mode.
    bool inDebugMode = false;

    // Assert expressions are only evaluated during development. They are ignored
    // in production. Therefore, this code only sets `inDebugMode` to true
    // in a development environment.
    assert(inDebugMode = true);

    return inDebugMode;
  }

  static void report(Object e, StackTrace s) {
    try {
      if (isInDebugMode) {
        print(e);
      } else {
        _sentry.captureException(
          exception: e,
          stackTrace: s,
        );
      }
    } catch (sentryError) {
      print('Sending report to sentry.io failed: $sentryError');
      print('Original error: $e');
    }
  }
}
