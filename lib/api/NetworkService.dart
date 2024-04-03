import 'dart:convert';

import 'package:finance_builder/models/JsonMap.dart';
import 'package:http/http.dart' as http;

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
  Endpoint.signIn: EndpointConfig(path: '/auth/sign_in', type: RequestType.post)
};

final Map<Endpoint, EndpointConfig> _endpoints = {}
  ..addAll(_generalEndpoints)
  ..addAll(_authEndpoints);

class NetworkService {
  static bool _isInstanceCreated = false;

  NetworkService() {
    var isValid = _init();

    if (!isValid) {
      throw Exception('NetworkService endpoint config broken');
    }

    if (NetworkService._isInstanceCreated) {
      throw Exception('NetworkService already declared');
    }

    NetworkService._isInstanceCreated = true;
  }

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
      Map<dynamic, dynamic>? options}) {
    var path = _buildRequestPath(endpoint);
    var endpointConfig = _endpoints[endpoint]!;

    switch (endpointConfig.type) {
      case RequestType.post:
        {
          return http.post(Uri.parse(path),
              headers: _defaultHeaders, body: data);
        }
      case RequestType.get:
        {
          return http.get(Uri.parse(path), headers: _defaultHeaders);
        }
      case RequestType.put:
        {
          return http.put(Uri.parse(path),
              headers: _defaultHeaders, body: data);
        }
      case RequestType.delete:
        {
          return http.delete(Uri.parse(path),
              headers: _defaultHeaders, body: data);
        }
    }
  }

  Future<JsonMap> fetch(
      {required Endpoint endpoint,
      Object? data,
      Map<dynamic, dynamic>? options}) async {
    var response =
        await _doRequest(endpoint: endpoint, data: data, options: options);

    return jsonDecode(response.body) as JsonMap;
  }
}
