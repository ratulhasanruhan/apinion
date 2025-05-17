import 'dart:convert';
import 'package:apinion/core/apinion_client.dart';
import 'package:apinion/core/apinion_config.dart';
import 'package:flutter/material.dart';

void main() {
  ApinionConfig.init(
    baseUrl: 'https://jsonplaceholder.typicode.com',
    customTimeout: Duration(seconds: 10),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Apinion Demo',
      home: Scaffold(
        appBar: AppBar(title: const Text('Apinion API Demo')),
        body: const Center(child: ApiTestWidget()),
      ),
    );
  }
}

class ApiTestWidget extends StatefulWidget {
  const ApiTestWidget({super.key});

  @override
  State<ApiTestWidget> createState() => _ApiTestWidgetState();
}

class _ApiTestWidgetState extends State<ApiTestWidget> {
  String _result = 'Press a button to test API calls';

  Future<void> _testGet() async {
    final response = await ApinionClient.get('/posts/1');
    setState(() {
      _result = response.isSuccess
          ? jsonEncode(response.responseData)
          : 'Error: ${response.errorMessage}';
    });
  }

  Future<void> _testPost() async {
    final response = await ApinionClient.post('/posts', body: {
      'title': 'foo',
      'body': 'bar',
      'userId': 1,
    });
    setState(() {
      _result = response.isSuccess
          ? jsonEncode(response.responseData)
          : 'Error: ${response.errorMessage}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        ElevatedButton(onPressed: _testGet, child: const Text('Test GET')),
        const SizedBox(height: 10),
        ElevatedButton(onPressed: _testPost, child: const Text('Test POST')),
        const SizedBox(height: 20),
        Expanded(
          child: SingleChildScrollView(
            child: Text(
              _result,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        )
      ]),
    );
  }
}
