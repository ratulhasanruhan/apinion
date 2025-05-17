class ApinionConfig {
  static String baseUrl = '';
  static String? apiKey;
  static Duration timeout = const Duration(seconds: 15); // default

  static void init({
    required String base,
    String? key,
    Duration? customTimeout,
  }) {
    baseUrl = base;
    apiKey = key;
    if (customTimeout != null) timeout = customTimeout;
  }
}
