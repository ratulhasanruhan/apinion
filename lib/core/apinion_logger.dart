import 'package:logger/logger.dart';

class ApinionLogger {
  static Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 1,
      errorMethodCount: 5,
      lineLength: 120,
      colors: true,
      printEmojis: true,
      printTime: true,
    ),
  );

  static void info(String message) => _logger.i(message);
  static void error(String message) => _logger.e(message);
  static void warn(String message) => _logger.w(message);
  static void debug(String message) => _logger.d(message);

  static void setLevel(Level level) {
    _logger = Logger(
      level: level,
      printer: PrettyPrinter(
        methodCount: 1,
        errorMethodCount: 5,
        lineLength: 120,
        colors: true,
        printEmojis: true,
        printTime: true,
      ),
    );
  }
}
