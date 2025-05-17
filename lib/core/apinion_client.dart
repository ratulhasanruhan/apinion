import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/response_data.dart';
import '../utils/logger.dart';
import 'apinion_config.dart';

class ApinionClient {
  static final _timeout = ApinionConfig.timeout;

  static Map<String, String> _headers({String? token}) {
    final headers = {
      'Content-Type': 'application/json',
      if (ApinionConfig.apiKey != null) 'Authorization': ApinionConfig.apiKey!,
      if (token != null) 'Authorization': token,
    };
    return headers;
  }

  static Uri _makeUrl(String endpoint) => Uri.parse('${ApinionConfig.baseUrl}$endpoint');

  static Future<ResponseData> _handleRequest(
      Future<http.Response> Function() request,
      ) async {
    try {
      final response = await request().timeout(_timeout);
      logger.i('Response: ${response.statusCode} → ${response.body}');
      final decoded = json.decode(response.body);
      return ResponseData(
        isSuccess: response.statusCode >= 200 && response.statusCode < 300,
        statusCode: response.statusCode,
        data: decoded,
        error: decoded['message'] ?? '',
      );
    } catch (e) {
      logger.e('Error: $e');
      return ResponseData(
        isSuccess: false,
        statusCode: 500,
        data: '',
        error: e.toString(),
      );
    }
  }

  static Future<ResponseData> get(String endpoint, {String? token}) {
    return _handleRequest(() => http.get(_makeUrl(endpoint), headers: _headers(token: token)));
  }

  static Future<ResponseData> post(String endpoint, {Map<String, dynamic>? body, String? token}) {
    return _handleRequest(() => http.post(
      _makeUrl(endpoint),
      headers: _headers(token: token),
      body: jsonEncode(body),
    ));
  }

  static Future<ResponseData> put(String endpoint, {Map<String, dynamic>? body, String? token}) {
    return _handleRequest(() => http.put(
      _makeUrl(endpoint),
      headers: _headers(token: token),
      body: jsonEncode(body),
    ));
  }

  static Future<ResponseData> patch(String endpoint, {Map<String, dynamic>? body, String? token}) {
    return _handleRequest(() => http.patch(
      _makeUrl(endpoint),
      headers: _headers(token: token),
      body: jsonEncode(body),
    ));
  }

  static Future<ResponseData> delete(String endpoint, {Map<String, dynamic>? body, String? token}) {
    return _handleRequest(() => http.delete(
      _makeUrl(endpoint),
      headers: _headers(token: token),
      body: jsonEncode(body),
    ));
  }

  static Future<ResponseData> uploadImage(
      String endpoint,
      File file, {
        String? token,
        String fieldName = 'file',
      }) async {
    final uri = _makeUrl(endpoint);
    final request = http.MultipartRequest('POST', uri);
    if (token != null) request.headers['Authorization'] = token;
    if (ApinionConfig.apiKey != null) request.headers['Authorization'] = ApinionConfig.apiKey!;

    request.files.add(await http.MultipartFile.fromPath(fieldName, file.path));

    try {
      final streamed = await request.send().timeout(_timeout);
      final response = await http.Response.fromStream(streamed);
      logger.i('Upload Response: ${response.statusCode} → ${response.body}');
      final decoded = json.decode(response.body);

      return ResponseData(
        isSuccess: response.statusCode >= 200 && response.statusCode < 300,
        statusCode: response.statusCode,
        data: decoded,
        error: decoded['message'] ?? '',
      );
    } catch (e) {
      logger.e('Upload Error: $e');
      return ResponseData(
        isSuccess: false,
        statusCode: 500,
        data: '',
        error: e.toString(),
      );
    }
  }
}
