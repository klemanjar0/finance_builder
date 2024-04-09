import 'package:equatable/equatable.dart';
import 'accounts.models.dart';

class AccountState extends Equatable {
  const AccountState(
      {required this.accounts,
      required this.total,
      required this.fetching,
      required this.isLoaded,
      this.error});

  final List<Account> accounts;
  final int total;
  final bool fetching;
  final bool isLoaded;
  final String? error;

  factory AccountState.empty() {
    return const AccountState(
        accounts: <Account>[],
        total: 0,
        fetching: false,
        isLoaded: false,
        error: null);
  }

  factory AccountState.loaded(
      {required List<Account> accounts, required int total}) {
    return AccountState(
        accounts: accounts,
        total: total,
        fetching: false,
        isLoaded: true,
        error: null);
  }

  factory AccountState.failure(String message) {
    return AccountState(
        accounts: const <Account>[],
        total: 0,
        fetching: false,
        isLoaded: false,
        error: message);
  }

  AccountState setFetching(bool flag) {
    return AccountState(
        accounts: accounts,
        total: total,
        fetching: flag,
        isLoaded: isLoaded,
        error: error);
  }

  AccountState resetError() {
    return AccountState(
        accounts: accounts,
        total: total,
        fetching: fetching,
        isLoaded: isLoaded,
        error: null);
  }

  @override
  List<Object> get props =>
      [accounts, total, fetching, isLoaded, error.toString()];
}
