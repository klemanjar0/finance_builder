import 'dart:async';

import 'package:finance_builder/features/user/bloc/types.dart';

import 'user.api.dart';

class UserRepository {
  UserRepository({required UserApi userApi}) : _userApi = userApi;

  final UserApi _userApi;

  final _isLoggedInController = StreamController<bool>();

  Stream<bool> get isLoggedIn async* {
    await Future<void>.delayed(const Duration(seconds: 1));
    yield* _isLoggedInController.stream;
  }

  Future<SignInSuccess> signIn({
    required String username,
    required String password,
  }) async {
    var result = await _userApi.signIn(username: username, password: password);
    _userApi.setAuthToken(result.authToken);
    _isLoggedInController.add(true);
    return result;
  }

  Future<SignInSuccess> signUp({
    required String username,
    required String password,
  }) async {
    var result = await _userApi.signUp(username: username, password: password);
    _userApi.setAuthToken(result.authToken);
    _isLoggedInController.add(true);
    return result;
  }

  void signOut({
    required String username,
    required String password,
  }) async {
    _isLoggedInController.add(false);
    _userApi.signOut();
  }

  void dispose() => _isLoggedInController.close();
}
