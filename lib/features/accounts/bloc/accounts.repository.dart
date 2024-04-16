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
    var account = await _accountApi.getAccount(payload);
    var transactions = await _accountApi.getTransactions(payload);
    return account.copyWith(transactions: transactions);
  }

  Future<void> createTransaction(
      AccountsCreateTransactionRequestPayload payload) async {
    return _accountApi.createTransaction(payload);
  }

  Future<Summary> getSummary() async {
    return _accountApi.getSummary();
  }
}
