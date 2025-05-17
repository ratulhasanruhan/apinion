import 'package:apinion/apinion.dart';

void main() async {
  // Initialize Apinion with base URL and optional API key
  ApinionConfig.init(
    baseUrl: 'https://jsonplaceholder.typicode.com',
    customTimeout: Duration(seconds: 10), // optional
  );

  print('--- GET Request Example ---');
  final getResponse = await ApinionClient.get('/posts/1');
  if (getResponse.isSuccess) {
    print('Title: ${getResponse.responseData['title']}');
  } else {
    print('Error: ${getResponse.errorMessage}');
  }

  print('\n--- POST Request Example ---');
  final postResponse = await ApinionClient.post('/posts', body: {
    'title': 'foo',
    'body': 'bar',
    'userId': 1,
  });
  if (postResponse.isSuccess) {
    print('Created Post ID: ${postResponse.responseData['id']}');
  } else {
    print('Error: ${postResponse.errorMessage}');
  }
}
