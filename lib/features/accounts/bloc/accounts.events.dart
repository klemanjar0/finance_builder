import 'package:equatable/equatable.dart';
import 'package:finance_builder/components/SortingBottomSheet/SortingBottomSheet.dart';

import 'accounts.models.dart';
import 'types.dart';

sealed class AccountEvent extends Equatable {
  const AccountEvent();

  @override
  List<Object> get props => [];
}

final class AccountEventGetListRequested extends AccountEvent {
  const AccountEventGetListRequested(
      {required this.loadMore, this.autoTriggered});

  final bool loadMore;
  final bool? autoTriggered;

  @override
  List<Object> get props => [loadMore];
}

final class AccountEventGetListReceived extends AccountEvent {
  const AccountEventGetListReceived(
      {required this.accounts, required this.total, required this.loadMore});

  final List<Account> accounts;
  final int total;
  final bool loadMore;

  @override
  List<Object> get props => [accounts.length, total, loadMore];
}

final class AccountEventGetListFailure extends AccountEvent {
  const AccountEventGetListFailure({required this.message});

  final String message;

  @override
  List<Object> get props => [message];
}

final class AccountEventCreateFailure extends AccountEvent {
  const AccountEventCreateFailure({required this.message});

  final String message;

  @override
  List<Object> get props => [message];
}

final class AccountEventResetState extends AccountEvent {
  const AccountEventResetState();

  @override
  List<Object> get props => [];
}

final class AccountEventCreateRequested extends AccountEvent {
  const AccountEventCreateRequested({required this.payload});

  final AccountsCreateRequestPayload payload;

  @override
  List<Object> get props => [payload.budget, payload.description, payload.name];
}

final class AccountEventDeleteRequested extends AccountEvent {
  const AccountEventDeleteRequested({required this.payload});

  final AccountsRemoveRequestPayload payload;

  @override
  List<Object> get props => [payload.id];
}

final class AccountEventDeleteFailure extends AccountEvent {
  const AccountEventDeleteFailure({required this.message});

  final String message;

  @override
  List<Object> get props => [message];
}

final class AccountEventSetSort extends AccountEvent {
  const AccountEventSetSort({required this.sortOption});

  final SortOption sortOption;

  @override
  List<Object> get props => [sortOption.field, sortOption.direction];
}

final class AccountEventGetSingleAccountRequested extends AccountEvent {
  const AccountEventGetSingleAccountRequested({required this.payload});

  final GetSingleAccountRequestPayload payload;

  @override
  List<Object> get props => [payload.id];
}

final class AccountEventGetSingleAccountSuccess extends AccountEvent {
  const AccountEventGetSingleAccountSuccess({required this.payload});

  final GetSingleAccountSuccessPayload payload;

  @override
  List<Object> get props => [payload.account.id];
}

final class AccountEventGetSingleAccountFailed extends AccountEvent {
  const AccountEventGetSingleAccountFailed({required this.errorMessage});

  final String errorMessage;

  @override
  List<Object> get props => [errorMessage];
}

final class AccountEventResetAccountError extends AccountEvent {
  const AccountEventResetAccountError();

  @override
  List<Object> get props => [];
}

final class AccountEventResetSingleAccount extends AccountEvent {
  const AccountEventResetSingleAccount();

  @override
  List<Object> get props => [];
}

final class AccountEventCreateTransactionRequested extends AccountEvent {
  const AccountEventCreateTransactionRequested({required this.payload});

  final AccountsCreateTransactionRequestPayload payload;

  @override
  List<Object> get props => [payload.value, payload.description, payload.type];
}

final class AccountEventSummaryRequested extends AccountEvent {
  const AccountEventSummaryRequested();

  @override
  List<Object> get props => [];
}

final class AccountEventSummarySuccess extends AccountEvent {
  const AccountEventSummarySuccess({required this.summary});

  final Summary summary;

  @override
  List<Object> get props =>
      [summary.totalBudget, summary.totalSpent, summary.totalSpentThisMonth];
}

final class AccountEventSummaryFailed extends AccountEvent {
  const AccountEventSummaryFailed({required this.errorMessage});

  final String errorMessage;

  @override
  List<Object> get props => [errorMessage];
}
