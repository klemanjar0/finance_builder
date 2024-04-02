import 'package:finance_builder/features/user/bloc/types.dart';

abstract class UserApi {
  const UserApi();

  Future<SignInSuccess> signIn({
    required String username,
    required String password,
  });

  Future<SignInSuccess> register({
    required String username,
    required String password,
  });
}

class UserNetworkApi extends UserApi {
  const UserNetworkApi();

  @override
  Future<SignInSuccess> signIn({
    required String username,
    required String password,
  }) {
    return Future(() => const SignInSuccess(authToken: 'asd', username: 'asd'));
  }

  @override
  Future<SignInSuccess> register({
    required String username,
    required String password,
  }) {
    return Future(() => const SignInSuccess(authToken: 'asd', username: 'asd'));
  }
}
