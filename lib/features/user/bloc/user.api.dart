import 'package:finance_builder/api/NetworkService.dart';
import 'package:finance_builder/features/user/bloc/types.dart';
import 'package:finance_builder/models/JsonMap.dart';

abstract class UserApi {
  const UserApi();

  Future<SignInSuccess> signIn({
    required String username,
    required String password,
  });

  Future<SignInSuccess> signUp({
    required String username,
    required String password,
  });

  void setAuthToken(String token);

  void signOut();
}

class UserNetworkApi extends UserApi {
  UserNetworkApi({required NetworkService networkService})
      : _networkService = networkService;

  final NetworkService _networkService;

  @override
  Future<SignInSuccess> signIn({
    required String username,
    required String password,
  }) async {
    JsonMap json = {"email": username, "password": password};
    var response =
        await _networkService.fetch(endpoint: Endpoint.signIn, data: json);
    var payload = SignInSuccess.fromJson(response, username);

    return payload;
  }

  @override
  Future<SignInSuccess> signUp({
    required String username,
    required String password,
  }) async {
    JsonMap json = {"email": username, "password": password};
    var response =
        await _networkService.fetch(endpoint: Endpoint.signUp, data: json);
    var payload = SignInSuccess.fromJson(response, username);

    return payload;
  }

  @override
  void setAuthToken(String token) {
    _networkService.addHeader(key: 'Authorization', value: 'Bearer $token');
  }

  @override
  void signOut() {
    _networkService.removeHeader(key: 'Authorization');
  }
}
