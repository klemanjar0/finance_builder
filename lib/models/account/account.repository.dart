import 'package:finance_builder/models/account/account.api.dart';
import 'package:finance_builder/models/account/account.localStorageApi.dart';
import 'package:finance_builder/models/account/account.model.dart';

class AccountRepository {
  final AccountApi _accountApi;

  const AccountRepository({
    required AccountApi accountApi,
  }) : _accountApi = accountApi;

  Stream<List<Account>> getAccounts() => _accountApi.getAccounts();
  Future<void> createAccount(Account account) =>
      _accountApi.createAccount(account);
  Future<void> updateAccount(Account account) =>
      _accountApi.updateAccount(account);
  Future<void> deleteAccount(String id) => _accountApi.deleteAccount(id);
  Future<Account> getAccountById(String id) => _accountApi.getAccountById(id);
  Stream<bool> isOnlyOneLeft() => _accountApi.isOnlyOneLeft();
}
