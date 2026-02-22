import 'package:dio/dio.dart';

class TDioHelper {
  static const String _baseUrl = 'https://your-api-base-url.com'; // Replace with your API base URL

  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: Duration(seconds: 10),
      receiveTimeout: Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  );

  // GET request
  static Future<Map<String, dynamic>> get(String endpoint) async {
    try {
      final response = await _dio.get(endpoint);
      return _handleResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  // POST request
  static Future<Map<String, dynamic>> post(String endpoint, dynamic data) async {
    try {
      final response = await _dio.post(
        endpoint,
        data: data,
      );
      return _handleResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  // PUT request
  static Future<Map<String, dynamic>> put(String endpoint, dynamic data) async {
    try {
      final response = await _dio.put(
        endpoint,
        data: data,
      );
      return _handleResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  // DELETE request
  static Future<Map<String, dynamic>> delete(String endpoint) async {
    try {
      final response = await _dio.delete(endpoint);
      return _handleResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  // Handle Dio response
  static Map<String, dynamic> _handleResponse(Response response) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.data is Map<String, dynamic>
          ? response.data
          : {'data': response.data};
    } else {
      throw Exception(
          'Failed to load data: ${response.statusCode} — ${response.statusMessage}');
    }
  }
}
