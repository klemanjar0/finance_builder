import 'dart:convert';

import 'package:finance_builder/models/JsonMap.dart';
import 'package:finance_builder/utils/utility.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import '../features/navigation/router.dart';
import 'AutoLogoutService.dart';

const String _apiPath =
    'https://finance-builder-api-005dc9562a36.herokuapp.com';

enum RequestType { post, get, put, delete }

enum Endpoint {
  empty,
  signUp,
  signIn,
  getAccounts,
  createAccount,
  updateAccount,
  deleteAccount
}

typedef ApiResponse = http.Response;

class EndpointConfig {
  final String path;
  final RequestType type;
  final Map<String, String>? headers;

  const EndpointConfig({required this.path, required this.type, this.headers});
}

Map<Endpoint, EndpointConfig Function(Map<String, String>?)> _generalEndpoints =
    {
  Endpoint.empty: (_) => const EndpointConfig(path: '/', type: RequestType.get),
};

Map<Endpoint, EndpointConfig Function(Map<String, String>?)> _authEndpoints = {
  Endpoint.signUp: (_) =>
      const EndpointConfig(path: '/auth/register', type: RequestType.post),
  Endpoint.signIn: (_) =>
      const EndpointConfig(path: '/auth/sign_in', type: RequestType.post)
};

Map<Endpoint, EndpointConfig Function(Map<String, String>?)> _accountEndpoints =
    {
  Endpoint.getAccounts: (_) =>
      const EndpointConfig(path: '/accounts', type: RequestType.get),
  Endpoint.createAccount: (_) =>
      const EndpointConfig(path: '/accounts', type: RequestType.post),
  Endpoint.updateAccount: (extra) =>
      EndpointConfig(path: '/accounts/${extra?['id']}', type: RequestType.put),
  Endpoint.deleteAccount: (extra) {
    var id = extra?['id'];
    print('ID $id');
    return EndpointConfig(path: '/accounts/$id', type: RequestType.delete);
  },
};

final Map<Endpoint, EndpointConfig Function(Map<String, String>?)> _endpoints =
    {}
      ..addAll(_generalEndpoints)
      ..addAll(_authEndpoints)
      ..addAll(_accountEndpoints);

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
  static int timeoutSecondsDuration = 10;
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

  Map<String, String> _defaultHeaders = {"Content-Type": "application/json"};

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
      if (_endpoints[element] == null) {
        isValid = false;
      }
    }

    return isValid;
  }

  String _buildRequestPath(Endpoint endpoint, [dynamic extra]) {
    var isInvalidPath = _endpoints[endpoint] == null;

    if (isInvalidPath) {
      return _apiPath + _generalEndpoints[Endpoint.empty]!(extra).path;
    }

    return _apiPath + _endpoints[endpoint]!(extra).path;
  }

  String _buildQueryParams(Map<String, String>? queryParams) {
    String value = '';

    if (queryParams == null) {
      return value;
    }

    value = queryParams.keys.map((key) => '$key=${queryParams[key]}').join('&');

    return '?$value';
  }

  Future<ApiResponse> _doRequest(
      {required Endpoint endpoint,
      Object? data,
      Map<dynamic, dynamic>? options,
      Map<String, String>? queryParams,
      Map<String, String>? extra}) async {
    var query = _buildQueryParams(queryParams);
    var path = _buildRequestPath(endpoint);
    var endpointConfig = _endpoints[endpoint]!(extra);
    var uri = Uri.parse('$path$query');
    var headers = _defaultHeaders..addAll(endpointConfig.headers ?? {});
    print(uri);
    switch (endpointConfig.type) {
      case RequestType.post:
        {
          var res = await http
              .post(uri, headers: headers, body: jsonEncode(data))
              .timeout(Duration(seconds: timeoutSecondsDuration));

          return res;
        }
      case RequestType.get:
        {
          return http
              .get(uri, headers: headers)
              .timeout(Duration(seconds: timeoutSecondsDuration));
        }
      case RequestType.put:
        {
          return http
              .put(uri, headers: headers, body: jsonEncode(data))
              .timeout(Duration(seconds: timeoutSecondsDuration));
        }
      case RequestType.delete:
        {
          return http
              .delete(uri, headers: headers, body: jsonEncode(data))
              .timeout(Duration(seconds: timeoutSecondsDuration));
        }
    }
  }

  Future<JsonMap> fetch(
      {required Endpoint endpoint,
      Object? data,
      Map<dynamic, dynamic>? options,
      Map<String, String>? queryParams,
      Map<String, String>? extra}) async {
    var successCodes = [200, 201, 204];
    var response = await _doRequest(
        endpoint: endpoint,
        data: data,
        options: options,
        queryParams: queryParams,
        extra: extra);

    _autoLogoutService.checkStatusCode(response.statusCode);

    if (!successCodes.contains(response.statusCode)) {
      var data = jsonDecode(response.body)['message'];
      var errorMessage = data is List ? data[0] : data;

      throw NetworkException(
          errorMessage ?? 'Unknown error', response.statusCode);
    }

    return jsonDecode(response.body) as JsonMap;
  }
}
