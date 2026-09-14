import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:pebblexpense/core/constants/api_endpoints.dart';

final apiClientProvider = Provider<ApiClient>((ref) => ApiClient());

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  @override
  String toString() => message;
}

/// Sentinel for "no explicit baseUrl passed" so the client can auto-probe
/// the candidate hosts (emulator alias first, then device loopback).
const String _autoBaseUrl = '__auto__';

class ApiClient {
  /// Base URL for the PebbleScore Pulse API.
  ///
  /// Defaults to auto-probing, which tries these in order and caches the
  /// first host that answers:
  /// - Android Emulator: http://10.0.2.2:3000
  /// - Local Mock: http://127.0.0.1:3000 (physical devices need
  ///   `adb reverse tcp:3000 tcp:3000`)
  ///
  /// You can also pin one explicitly:
  /// - Live Dev: https://pebblescore-api.dev.pebblescore.com
  final String baseUrl;

  /// The isolated bucket name. Defaults to 'amaka'.
  final String bucket;

  /// Optional test headers
  final String? forceError;
  final int? delayMs;

  /// Resolved base URL after probing. Null until the first successful probe.
  String? get resolvedBaseUrl => _resolvedBaseUrl;

  String? _resolvedBaseUrl;

  /// Guards so concurrent requests share one probe instead of each
  /// opening their own doomed connections.
  Future<String>? _probeFuture;

  ApiClient({
    this.baseUrl = _autoBaseUrl,
    this.bucket = ApiEndpoints.defaultBucket,
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

  /// Returns the base URL to use for a request.
  ///
  /// An explicit baseUrl short-circuits probing entirely. Otherwise probes
  /// each candidate by hitting the bucket's expense list endpoint (cheap,
  /// no side effects) and caches the first one that responds. On Android an
  /// unreachable host fails fast with "Connection refused", so probing adds
  /// no meaningful latency on the happy path.
  Future<String> _resolveBaseUrl() async {
    if (baseUrl != _autoBaseUrl) {
      return baseUrl;
    }
    if (_resolvedBaseUrl != null) {
      return _resolvedBaseUrl!;
    }
    return _probeFuture ??= _probeBaseUrls();
  }

  Future<String> _probeBaseUrls() async {
    Object? lastError;
    for (final candidate in ApiEndpoints.candidateBaseUrls) {
      try {
        final uri = Uri.parse(
          '$candidate${ApiEndpoints.expenses(bucket)}',
        );
        final response = await http
            .get(uri, headers: _buildHeaders())
            .timeout(const Duration(seconds: 3));
        if (response.statusCode < 500) {
          _resolvedBaseUrl = candidate;
          return candidate;
        }
        lastError = ApiException(
          'Server error: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      } catch (e) {
        lastError = e;
      }
    }
    // Nothing answered; don't cache so the next request retries the probe.
    _probeFuture = null;
    throw ApiException('Failed to connect to the server: $lastError');
  }

  Future<dynamic> get(String endpoint, {Map<String, String>? headers}) async {
    try {
      final base = await _resolveBaseUrl();
      final uri = Uri.parse('$base$endpoint');
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
      final base = await _resolveBaseUrl();
      final uri = Uri.parse('$base$endpoint');
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
      final base = await _resolveBaseUrl();
      final uri = Uri.parse('$base$endpoint');
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
