import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  @override
  String toString() => message;
}

class ApiClient {
  /// Base URL for the PebbleScore Pulse API.
  /// Defaults to local mock server. You can also use:
  /// - Live Dev: https://pebblescore-api.dev.pebblescore.com
  /// - Android Emulator: http://10.0.2.2:3000
  /// - Local Mock: http://127.0.0.1:3000
  final String baseUrl;

  /// The isolated bucket name. Defaults to 'amaka'.
  final String bucket;

  /// Optional test headers
  final String? forceError;
  final int? delayMs;

  ApiClient({
    this.baseUrl = 'http://127.0.0.1:3000',
    this.bucket = 'amaka',
    this.forceError,
    this.delayMs,
  });

  Map<String, String> _buildHeaders([Map<String, String>? extraHeaders]) {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (forceError != null) {
      headers['X-Force-Error'] = forceError!;
    }
    if (delayMs != null) {
      headers['X-Delay'] = delayMs.toString();
    }
    if (extraHeaders != null) {
      headers.addAll(extraHeaders);
    }
    return headers;
  }

  Future<dynamic> get(String endpoint, {Map<String, String>? headers}) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');
      final response = await http.get(uri, headers: _buildHeaders(headers));
      return _handleResponse(response);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Failed to connect to the server: $e');
    }
  }

  Future<dynamic> post(
    String endpoint,
    Map<String, dynamic> body, {
    Map<String, String>? headers,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');
      final response = await http.post(
        uri,
        headers: _buildHeaders(headers),
        body: json.encode(body),
      );
      return _handleResponse(response);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Failed to connect to the server: $e');
    }
  }

  Future<dynamic> delete(String endpoint, {Map<String, String>? headers}) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');
      final response = await http.delete(uri, headers: _buildHeaders(headers));
      return _handleResponse(response);
    } on ApiException {
      rethrow;
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
    }

    // Try extracting structured error JSON: { "error": "..." }
    String errorMessage = 'Server error: ${response.statusCode}';
    if (response.body.isNotEmpty) {
      try {
        final decoded = json.decode(response.body);
        if (decoded is Map<String, dynamic> && decoded.containsKey('error')) {
          errorMessage = decoded['error'] as String;
        } else {
          errorMessage = response.body;
        }
      } catch (_) {
        errorMessage = response.body;
      }
    }

    throw ApiException(errorMessage, statusCode: response.statusCode);
  }
}
