import 'dart:async';

import 'package:finance_builder/features/user/bloc/types.dart';
import 'package:finance_builder/features/user/bloc/user.state.dart';

import 'user.api.dart';

class UserRepository {
  UserRepository({required UserApi userApi}) : _userApi = userApi;

  final UserApi _userApi;

  final _controller = StreamController<AuthenticationStatus>();

  Stream<AuthenticationStatus> get status async* {
    await Future<void>.delayed(const Duration(seconds: 1));
    yield AuthenticationStatus.unauthenticated;
    yield* _controller.stream;
  }

  Future<SignInSuccess> signIn({
    required String username,
    required String password,
  }) async {
    var result = await _userApi.signIn(username: username, password: password);
    _userApi.setAuthToken(result.authToken);
    _controller.add(AuthenticationStatus.authenticated);
    return result;
  }

  Future<SignInSuccess> signUp({
    required String username,
    required String password,
  }) async {
    var result = await _userApi.signUp(username: username, password: password);
    _userApi.setAuthToken(result.authToken);
    _controller.add(AuthenticationStatus.authenticated);
    return result;
  }

  void signOut() async {
    _controller.add(AuthenticationStatus.unauthenticated);
    _userApi.signOut();
  }

  void dispose() => _controller.close();
}
