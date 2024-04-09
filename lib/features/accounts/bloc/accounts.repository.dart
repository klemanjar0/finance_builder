import 'accounts.api.dart';
import 'types.dart';

class AccountsRepository {
  AccountsRepository({required AccountApi accountApi})
      : _accountApi = accountApi;

  final AccountApi _accountApi;

  Future<AccountsResponse> getAccounts(AccountsRequestPayload payload) async {
    return _accountApi.getAccounts(payload);
  }

  Future<void> createAccount(AccountsCreateRequestPayload payload) async {
    return _accountApi.createAccount(payload);
  }
}
