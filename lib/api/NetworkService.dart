import 'dart:convert';

import 'package:finance_builder/models/JsonMap.dart';
import 'package:http/http.dart' as http;

import '../features/navigation/router.dart';
import 'AutoLogoutService.dart';

const String _apiPath =
    'https://finance-builder-api-005dc9562a36.herokuapp.com';

enum RequestType { post, get, put, delete }

enum Endpoint { empty, signUp, signIn }

typedef ApiResponse = http.Response;

class EndpointConfig {
  final String path;
  final RequestType type;

  const EndpointConfig({required this.path, required this.type});
}

const Map<Endpoint, EndpointConfig> _generalEndpoints = {
  Endpoint.empty: EndpointConfig(path: '/', type: RequestType.get),
};

const Map<Endpoint, EndpointConfig> _authEndpoints = {
  Endpoint.signUp:
      EndpointConfig(path: '/auth/register', type: RequestType.post),
  Endpoint.signIn:
      EndpointConfig(path: '/auth/sign_____in', type: RequestType.post)
};

final Map<Endpoint, EndpointConfig> _endpoints = {}
  ..addAll(_generalEndpoints)
  ..addAll(_authEndpoints);

class NetworkException implements Exception {
  final String _message;
  final int _statusCode;

  NetworkException(message, statusCode)
      : _statusCode = statusCode,
        _message = message;

  @override
  String toString() {
    return _message;
  }

  int getStatusCode() {
    return _statusCode;
  }
}

class NetworkService {
  static bool _isInstanceCreated = false;

  NetworkService({required AutoLogoutService autoLogoutService})
      : _autoLogoutService = autoLogoutService {
    var isValid = _init();

    if (!isValid) {
      throw Exception('NetworkService endpoint config broken');
    }

    if (NetworkService._isInstanceCreated) {
      throw Exception('NetworkService already declared');
    }

    NetworkService._isInstanceCreated = true;
  }

  final AutoLogoutService _autoLogoutService;

  Map<String, String> _defaultHeaders = {};

  Map<String, String> get headers {
    return _defaultHeaders;
  }

  void setDefaultHeaders(Map<String, String> headers) {
    _defaultHeaders = headers;
  }

  void addHeader({required String key, required String value}) {
    _defaultHeaders[key] = value;
  }

  void removeHeader({required String key}) {
    _defaultHeaders.remove(key);
  }

  bool _init() {
    bool isValid = true;

    for (Endpoint element in Endpoint.values) {
      if (_endpoints[element]?.path == null) {
        isValid = false;
      }
    }

    return isValid;
  }

  String _buildRequestPath(Endpoint endpoint) {
    var isInvalidPath = _endpoints[endpoint]?.path == null;

    if (isInvalidPath) {
      return _generalEndpoints[Endpoint.empty]!.path;
    }

    return _apiPath + _endpoints[endpoint]!.path;
  }

  Future<ApiResponse> _doRequest(
      {required Endpoint endpoint,
      Object? data,
      Map<dynamic, dynamic>? options}) async {
    var path = _buildRequestPath(endpoint);
    var endpointConfig = _endpoints[endpoint]!;

    switch (endpointConfig.type) {
      case RequestType.post:
        {
          var res = await http
              .post(Uri.parse(path), headers: _defaultHeaders, body: data)
              .timeout(const Duration(seconds: 5));

          return res;
        }
      case RequestType.get:
        {
          return http
              .get(Uri.parse(path), headers: _defaultHeaders)
              .timeout(const Duration(seconds: 5));
        }
      case RequestType.put:
        {
          return http
              .put(Uri.parse(path), headers: _defaultHeaders, body: data)
              .timeout(const Duration(seconds: 5));
        }
      case RequestType.delete:
        {
          return http
              .delete(Uri.parse(path), headers: _defaultHeaders, body: data)
              .timeout(const Duration(seconds: 5));
        }
    }
  }

  Future<JsonMap> fetch(
      {required Endpoint endpoint,
      Object? data,
      Map<dynamic, dynamic>? options}) async {
    var successCodes = [200, 201, 204];
    var response =
        await _doRequest(endpoint: endpoint, data: data, options: options);

    _autoLogoutService.checkStatusCode(response.statusCode);

    if (!successCodes.contains(response.statusCode)) {
      throw NetworkException(
          jsonDecode(response.body)['message'] ?? 'Unknown error',
          response.statusCode);
    }

    return jsonDecode(response.body) as JsonMap;
  }
}
