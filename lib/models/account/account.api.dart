import 'package:finance_builder/models/account/account.model.dart';

abstract class AccountApi {
  const AccountApi();

  Stream<List<Account>> getAccounts();

  Future<Account> getAccountById(String id);

  Future<void> createAccount(Account account);

  Future<void> updateAccount(Account account);

  Future<void> deleteAccount(String id);

  Stream<bool> isOnlyOneLeft();
}

class AccountNotFoundException implements Exception {}
