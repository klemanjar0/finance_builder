import 'package:equatable/equatable.dart';
import 'package:finance_builder/components/SortingBottomSheet/SortingBottomSheet.dart';
import 'accounts.models.dart';

class AccountState extends Equatable {
  const AccountState(
      {required this.accounts,
      required this.total,
      required this.fetching,
      required this.isLoaded,
      required this.sortOption,
      this.error});

  final List<Account> accounts;
  final int total;
  final bool fetching;
  final bool isLoaded;
  final String? error;
  final SortOption sortOption;

  factory AccountState.empty() {
    return const AccountState(
        accounts: <Account>[],
        total: 0,
        fetching: false,
        isLoaded: false,
        sortOption: SortOption(field: 'name', direction: SortDirection.asc),
        error: null);
  }

  AccountState loaded({required List<Account> accounts, required int total}) {
    return AccountState(
        accounts: accounts,
        total: total,
        fetching: false,
        isLoaded: true,
        error: null,
        sortOption: sortOption);
  }

  AccountState failure(String message) {
    return AccountState(
        accounts: const <Account>[],
        total: 0,
        fetching: false,
        isLoaded: false,
        error: message,
        sortOption: sortOption);
  }

  AccountState setFetching(bool flag) {
    return AccountState(
        accounts: accounts,
        total: total,
        fetching: flag,
        isLoaded: isLoaded,
        error: error,
        sortOption: sortOption);
  }

  AccountState resetError() {
    return AccountState(
        accounts: accounts,
        total: total,
        fetching: fetching,
        isLoaded: isLoaded,
        error: null,
        sortOption: sortOption);
  }

  AccountState resetData() {
    return AccountState(
        accounts: <Account>[],
        total: 0,
        fetching: fetching,
        isLoaded: isLoaded,
        error: error,
        sortOption: sortOption);
  }

  AccountState setSort(SortOption sortOption) {
    return AccountState(
        accounts: accounts,
        total: total,
        fetching: fetching,
        isLoaded: isLoaded,
        error: error,
        sortOption: sortOption);
  }

  @override
  List<Object> get props => [
        accounts,
        total,
        fetching,
        isLoaded,
        error.toString(),
        sortOption.direction,
        sortOption.field
      ];
}
