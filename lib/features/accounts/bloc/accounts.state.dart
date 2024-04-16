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
      this.error,
      this.single,
      required this.singleFetching,
      this.singleError,
      this.summary,
      this.summaryError,
      required this.summaryFetching});

  final List<Account> accounts;
  final int total;
  final bool fetching;
  final bool isLoaded;
  final String? error;
  final SortOption sortOption;

  final bool singleFetching;
  final Account? single;
  final String? singleError;

  final bool summaryFetching;
  final Summary? summary;
  final String? summaryError;

  factory AccountState.empty() {
    return const AccountState(
        accounts: <Account>[],
        total: 0,
        fetching: false,
        isLoaded: false,
        sortOption: SortOption(field: 'name', direction: SortDirection.asc),
        error: null,
        singleFetching: false,
        single: null,
        summaryFetching: false);
  }

  AccountState loaded({required List<Account> accounts, required int total}) {
    return AccountState(
      accounts: accounts,
      total: total,
      fetching: false,
      isLoaded: true,
      error: null,
      sortOption: sortOption,
      singleFetching: singleFetching,
      single: single,
      summaryFetching: summaryFetching,
      summary: summary,
      summaryError: summaryError,
    );
  }

  AccountState failure(String message) {
    return AccountState(
      accounts: const <Account>[],
      total: 0,
      fetching: false,
      isLoaded: false,
      error: message,
      sortOption: sortOption,
      singleFetching: singleFetching,
      single: single,
      summaryFetching: summaryFetching,
      summary: summary,
      summaryError: summaryError,
    );
  }

  AccountState setFetching(bool flag) {
    return AccountState(
      accounts: accounts,
      total: total,
      fetching: flag,
      isLoaded: isLoaded,
      error: error,
      sortOption: sortOption,
      singleFetching: singleFetching,
      single: single,
      summaryFetching: summaryFetching,
      summary: summary,
      summaryError: summaryError,
    );
  }

  AccountState resetError() {
    return AccountState(
      accounts: accounts,
      total: total,
      fetching: fetching,
      isLoaded: isLoaded,
      error: null,
      sortOption: sortOption,
      singleFetching: singleFetching,
      single: single,
      summaryFetching: summaryFetching,
      summary: summary,
      summaryError: summaryError,
    );
  }

  AccountState resetData() {
    return AccountState(
      accounts: <Account>[],
      total: 0,
      fetching: fetching,
      isLoaded: isLoaded,
      error: error,
      sortOption: sortOption,
      singleFetching: singleFetching,
      single: single,
      summaryFetching: summaryFetching,
      summary: summary,
      summaryError: summaryError,
    );
  }

  AccountState setSort(SortOption sortOption) {
    return AccountState(
      accounts: accounts,
      total: total,
      fetching: fetching,
      isLoaded: isLoaded,
      error: error,
      sortOption: sortOption,
      singleFetching: singleFetching,
      single: single,
      summaryFetching: summaryFetching,
      summary: summary,
      summaryError: summaryError,
    );
  }

  AccountState setSingleFetching(bool flag) {
    return AccountState(
      accounts: accounts,
      total: total,
      fetching: fetching,
      isLoaded: isLoaded,
      error: error,
      sortOption: sortOption,
      singleFetching: flag,
      single: single,
      summaryFetching: summaryFetching,
      summary: summary,
      summaryError: summaryError,
    );
  }

  AccountState setSingle(Account? single) {
    return AccountState(
      accounts: accounts,
      total: total,
      fetching: fetching,
      isLoaded: isLoaded,
      error: error,
      sortOption: sortOption,
      singleFetching: singleFetching,
      single: single,
      summaryFetching: summaryFetching,
      summary: summary,
      summaryError: summaryError,
    );
  }

  AccountState setSingleError(String errorMessage) {
    return AccountState(
      accounts: accounts,
      total: total,
      fetching: fetching,
      isLoaded: isLoaded,
      error: error,
      sortOption: sortOption,
      singleFetching: singleFetching,
      single: single,
      singleError: errorMessage,
      summaryFetching: summaryFetching,
      summary: summary,
      summaryError: summaryError,
    );
  }

  AccountState resetSingleError() {
    return AccountState(
      accounts: accounts,
      total: total,
      fetching: fetching,
      isLoaded: isLoaded,
      error: error,
      sortOption: sortOption,
      singleFetching: singleFetching,
      single: single,
      singleError: null,
      summaryFetching: summaryFetching,
      summary: summary,
      summaryError: summaryError,
    );
  }

  AccountState copyWithSummary({
    bool? summaryFetching,
    Summary? summary,
    String? summaryError,
  }) {
    return AccountState(
      accounts: accounts,
      total: total,
      fetching: fetching,
      isLoaded: isLoaded,
      error: error,
      sortOption: sortOption,
      singleFetching: singleFetching,
      single: single,
      singleError: singleError,
      summaryFetching: summaryFetching ?? this.summaryFetching,
      summary: summary ?? this.summary,
      summaryError: summaryError ?? this.summaryError,
    );
  }

  @override
  List<Object?> get props => [
        accounts,
        total,
        fetching,
        isLoaded,
        error,
        sortOption.direction,
        sortOption.field,
        singleFetching,
        single?.id,
        singleError,
        summary,
        summaryError,
        summaryFetching
      ];
}
