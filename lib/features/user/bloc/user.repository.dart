import 'user.api.dart';

class UserRepository {
  UserRepository({required UserApi userApi}) : _userApi = userApi;

  final UserApi _userApi;
}
