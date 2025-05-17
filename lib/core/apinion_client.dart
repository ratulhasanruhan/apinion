import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/response_data.dart';
import 'apinion_config.dart';
import 'apinion_logger.dart';

class ApinionClient {
  static Uri _getUri(String endpoint) {
    final url = endpoint.startsWith('http')
        ? endpoint
        : '${ApinionConfig.base}$endpoint';
    return Uri.parse(url);
  }

  static Map<String, String> _getHeaders({Map<String, String>? extraHeaders}) {
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };
    if (ApinionConfig.key != null) {
      headers['Authorization'] = ApinionConfig.key!;
    }
    if (extraHeaders != null) {
      headers.addAll(extraHeaders);
    }
    return headers;
  }

  static Future<ResponseData> _request(
    String method,
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    final uri = _getUri(endpoint);
    final requestHeaders = _getHeaders(extraHeaders: headers);

    ApinionLogger.info('➡️ $method $uri');
    if (body != null) {
      ApinionLogger.debug('📦 Body: ${jsonEncode(body)}');
    }
    ApinionLogger.debug('🧾 Headers: $requestHeaders');

    try {
      late http.Response response;

      switch (method) {
        case 'GET':
          response = await http
              .get(uri, headers: requestHeaders)
              .timeout(ApinionConfig.timeout);
          break;
        case 'POST':
          response = await http
              .post(uri, headers: requestHeaders, body: jsonEncode(body))
              .timeout(ApinionConfig.timeout);
          break;
        case 'PUT':
          response = await http
              .put(uri, headers: requestHeaders, body: jsonEncode(body))
              .timeout(ApinionConfig.timeout);
          break;
        case 'DELETE':
          response = await http
              .delete(uri, headers: requestHeaders, body: jsonEncode(body))
              .timeout(ApinionConfig.timeout);
          break;
        case 'PATCH':
          response = await http
              .patch(uri, headers: requestHeaders, body: jsonEncode(body))
              .timeout(ApinionConfig.timeout);
          break;
        default:
          throw UnsupportedError('Unsupported HTTP method: $method');
      }

      ApinionLogger.debug('📨 Response: ${response.body}');
      return _handleResponse(response);
    } on TimeoutException {
      ApinionLogger.error(
          '⏰ Request timed out after ${ApinionConfig.timeout.inSeconds} seconds.');
      return ResponseData(
        isSuccess: false,
        statusCode: 408,
        responseData: null,
        errorMessage: 'Request timeout. Please try again later.',
      );
    } catch (e) {
      ApinionLogger.error('💥 Request error: $e');
      return ResponseData(
        isSuccess: false,
        statusCode: 500,
        responseData: null,
        errorMessage: 'Unexpected error: $e',
      );
    }
  }

  static ResponseData _handleResponse(http.Response response) {
    final statusCode = response.statusCode;
    dynamic data;
    try {
      data = jsonDecode(response.body);
    } catch (e) {
      ApinionLogger.warn('⚠️ Failed to parse JSON: $e');
      data = response.body;
    }

    if (statusCode >= 200 && statusCode < 300) {
      ApinionLogger.info('✅ Success [$statusCode]');
      return ResponseData(
        isSuccess: true,
        statusCode: statusCode,
        responseData: data,
        errorMessage: '',
      );
    } else {
      ApinionLogger.error('❌ Failed [$statusCode]: $data');
      return ResponseData(
        isSuccess: false,
        statusCode: statusCode,
        responseData: data,
        errorMessage: data is Map && data['message'] != null
            ? data['message']
            : 'An error occurred',
      );
    }
  }

  static Future<ResponseData> get(String endpoint,
          {Map<String, String>? headers}) =>
      _request('GET', endpoint, headers: headers);

  static Future<ResponseData> post(String endpoint,
          {Map<String, dynamic>? body, Map<String, String>? headers}) =>
      _request('POST', endpoint, body: body, headers: headers);

  static Future<ResponseData> put(String endpoint,
          {Map<String, dynamic>? body, Map<String, String>? headers}) =>
      _request('PUT', endpoint, body: body, headers: headers);

  static Future<ResponseData> delete(String endpoint,
          {Map<String, dynamic>? body, Map<String, String>? headers}) =>
      _request('DELETE', endpoint, body: body, headers: headers);

  static Future<ResponseData> patch(String endpoint,
          {Map<String, dynamic>? body, Map<String, String>? headers}) =>
      _request('PATCH', endpoint, body: body, headers: headers);

  static Future<ResponseData> uploadImage(
    String endpoint, {
    required List<int> imageBytes,
    required String fileName,
    Map<String, String>? fields,
    Map<String, String>? headers,
  }) async {
    final uri = _getUri(endpoint);
    final requestHeaders = <String, String>{};
    if (ApinionConfig.key != null) {
      requestHeaders['Authorization'] = ApinionConfig.key!;
    }
    if (headers != null) {
      requestHeaders.addAll(headers);
    }

    ApinionLogger.info('📤 Uploading image to $uri');
    try {
      var request = http.MultipartRequest('POST', uri);
      request.headers.addAll(requestHeaders);

      if (fields != null) {
        request.fields.addAll(fields);
      }

      request.files.add(
          http.MultipartFile.fromBytes('file', imageBytes, filename: fileName));

      final streamedResponse =
          await request.send().timeout(ApinionConfig.timeout);
      final response = await http.Response.fromStream(streamedResponse);

      ApinionLogger.debug('📨 Response: ${response.body}');

      return _handleResponse(response);
    } on TimeoutException {
      ApinionLogger.error(
          '⏰ Upload timed out after ${ApinionConfig.timeout.inSeconds} seconds.');
      return ResponseData(
        isSuccess: false,
        statusCode: 408,
        responseData: null,
        errorMessage: 'Upload timeout. Please try again later.',
      );
    } catch (e) {
      ApinionLogger.error('💥 Upload error: $e');
      return ResponseData(
        isSuccess: false,
        statusCode: 500,
        responseData: null,
        errorMessage: 'Unexpected upload error: $e',
      );
    }
  }
}
