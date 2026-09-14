import 'dart:async';
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
  /// An explicit baseUrl short-circuits probing entirely. Otherwise races
  /// all candidate hosts in parallel and caches the first one that answers
  /// (capped at 2s). Racing matters: on a physical phone `10.0.2.2` never
  /// refuses the connection (packets just vanish), so a serial probe would
  /// burn the whole timeout before trying the next host.
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
    final candidates = ApiEndpoints.candidateBaseUrls;
    final completer = Completer<String>();
    var settled = false;
    var pending = candidates.length;

    void onCandidateFailure(Object error) {
      pending--;
      if (pending == 0 && !settled && !completer.isCompleted) {
        settled = true;
        _probeFuture = null; // Uncached so the next request re-probes.
        completer.completeError(
          ApiException(
            'Could not reach the mock API on any known host. Make sure the '
            'server is running (cd server && npm start) and, if you are on a '
            'physical device over USB, run: adb reverse tcp:3000 tcp:3000. '
            'Last error: $error',
          ),
        );
      }
    }

    for (final candidate in candidates) {
      final uri = Uri.parse('$candidate${ApiEndpoints.expenses(bucket)}');
      unawaited(() async {
        try {
          final response = await http
              .get(uri, headers: _buildHeaders())
              .timeout(const Duration(seconds: 2));
          if (settled) {
            return;
          }
          if (response.statusCode < 500) {
            settled = true;
            _resolvedBaseUrl = candidate;
            if (!completer.isCompleted) {
              completer.complete(candidate);
            }
          } else {
            onCandidateFailure(
              ApiException(
                'Server error: ${response.statusCode}',
                statusCode: response.statusCode,
              ),
            );
          }
        } catch (e) {
          onCandidateFailure(e);
        }
      }());
    }

    return completer.future;
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
