import 'package:finance_builder/features/accounts/bloc/accounts.models.dart';

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

  Future<void> removeAccount(AccountsRemoveRequestPayload payload) async {
    return _accountApi.removeAccount(payload);
  }

  Future<Account> getAccount(GetSingleAccountRequestPayload payload) async {
    return _accountApi.getAccount(payload);
  }
}
