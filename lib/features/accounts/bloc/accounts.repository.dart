import 'accounts.api.dart';

class AccountsRepository {
  AccountsRepository({required AccountApi accountApi})
      : _accountApi = accountApi;

  final AccountApi _accountApi;
}
