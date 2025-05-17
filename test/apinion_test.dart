import 'package:flutter_test/flutter_test.dart';

import 'package:apinion/apinion.dart';

void main() {
  group('ApinionConfig', () {
    test('Initialization with base URL and timeout', () {
      ApinionConfig.init(
        baseUrl: 'https://jsonplaceholder.typicode.com',
        customTimeout: const Duration(seconds: 10),
      );

      expect(ApinionConfig.base, 'https://jsonplaceholder.typicode.com');
      expect(ApinionConfig.timeout, const Duration(seconds: 10));
    });

  });
}
