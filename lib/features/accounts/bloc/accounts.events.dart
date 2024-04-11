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
  const AccountEventGetListRequested({required this.loadMore});

  final bool loadMore;

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
  List<Object> get props => [accounts, total, loadMore];
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
