import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiException implements Exception {
  final String message;
  ApiException(this.message);
  @override
  String toString() => message;
}

class ApiClient {
  // Using localhost for json-server. Depending on platform (web vs desktop vs emulator),
  // this might need adjustment, but 127.0.0.1 is standard for desktop/web local development.
  // For Android emulator, it usually needs 10.0.2.2.
  static const String baseUrl = 'http://127.0.0.1:3000';

  Future<dynamic> get(String endpoint) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl$endpoint'));
      return _handleResponse(response);
    } catch (e) {
      throw ApiException('Failed to connect to the server: $e');
    }
  }

  Future<dynamic> post(String endpoint, Map<String, dynamic> body) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      );
      return _handleResponse(response);
    } catch (e) {
      throw ApiException('Failed to connect to the server: $e');
    }
  }

  Future<dynamic> delete(String endpoint) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl$endpoint'));
      return _handleResponse(response);
    } catch (e) {
      throw ApiException('Failed to connect to the server: $e');
    }
  }

  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isNotEmpty) {
        return json.decode(response.body);
      }
      return null;
    } else {
      throw ApiException('Server error: ${response.statusCode} - ${response.body}');
    }
  }
}
