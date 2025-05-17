import 'apinion_logger.dart';

class ApinionConfig {
  static String base = '';
  static String? key; // Nullable API key
  static Duration timeout = const Duration(seconds: 15);

  static void init({
    required String baseUrl,
    String? apiKey,
    Duration? customTimeout,
  }) {
    base = baseUrl;
    key = apiKey; // Nullable, can be null
    if (customTimeout != null) {
      timeout = customTimeout;
    }
    ApinionLogger.info('🚀 Apinion initialized with baseUrl=$baseUrl');
  }
}