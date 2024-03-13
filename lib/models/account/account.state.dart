import 'package:equatable/equatable.dart';
import 'package:finance_builder/models/account/account.model.dart';

enum AccountStateStatus { initial, loading, success, failure }

final class AccountsState extends Equatable {
  const AccountsState({
    this.status = AccountStateStatus.initial,
    this.accounts = const [],
    this.lastDeletedAccount,
  });

  final AccountStateStatus status;
  final List<Account> accounts;
  final Account? lastDeletedAccount;

  AccountsState copyWith({
    AccountStateStatus Function()? status,
    List<Account> Function()? accounts,
    Account? Function()? lastDeletedAccount,
  }) {
    return AccountsState(
      status: status != null ? status() : this.status,
      accounts: accounts != null ? accounts() : this.accounts,
      lastDeletedAccount: lastDeletedAccount != null
          ? lastDeletedAccount()
          : this.lastDeletedAccount,
    );
  }

  @override
  List<Object?> get props => [
        status,
        accounts,
        lastDeletedAccount,
      ];
}
