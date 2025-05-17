![apinion_logo](https://github.com/user-attachments/assets/1b8f5449-69f6-4410-8c5c-ded7fce55c0b)


**Apinion** is a lightweight, developer-friendly Dart package that simplifies REST API calls in your Flutter or Dart apps.

- 🔐 Optional API key support  
- 🌐 Base URL set once  
- ⏱ Customizable timeout duration  
- 🪄 One-liner HTTP calls: GET, POST, PUT, PATCH, DELETE  
- 🖼️ File/image upload support  
- 🪵 Built-in pretty logger using `logger` package  

---
<p align="center">
  <a href="https://ratulhasan.gitbook.io/apinion/" target="_blank">
    <img src="https://img.shields.io/badge/View-Documentation-blue?style=for-the-badge&logo=readthedocs" alt="Documentation Button"/>
  </a>
</p>

---

## 🔍 Example
```
import 'package:apinion/apinion.dart';

void main() async {
  ApinionConfig.init(
    baseUrl: 'https://jsonplaceholder.typicode.com',
  );

  // GET request
  final getResponse = await ApinionClient.get('/posts/1');
  if (getResponse.isSuccess) {
    print('Title: ${getResponse.responseData['title']}');
  } else {
    print('Error: ${getResponse.errorMessage}');
  }

  // POST request
  final postResponse = await ApinionClient.post('/posts', body: {
    'title': 'foo',
    'body': 'bar',
    'userId': 1,
  });
  if (postResponse.isSuccess) {
    print('New Post ID: ${postResponse.responseData['id']}');
  }
}
```
