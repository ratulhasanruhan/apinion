import 'package:apinion/apinion.dart';

void main() async {
  // Initialize with base URL and timeout
  ApinionConfig.init(
    base: 'https://jsonplaceholder.typicode.com',
    customTimeout: const Duration(seconds: 10),
  );

  // ✅ Test GET request
  final res = await ApinionClient.get('/posts/1');
  print('\n✅ GET /posts/1:\nSuccess: ${res.isSuccess}\nData: ${res.data}');

  // ✅ Test POST request
  final postRes = await ApinionClient.post('/posts', body: {
    'title': 'apinion test',
    'body': 'this is a test post',
    'userId': 1,
  });
  print('\n✅ POST /posts:\nSuccess: ${postRes.isSuccess}\nData: ${postRes.data}');

}
