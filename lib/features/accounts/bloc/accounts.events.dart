import 'package:equatable/equatable.dart';

import 'accounts.models.dart';

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

final class AccountEventResetState extends AccountEvent {
  const AccountEventResetState();

  @override
  List<Object> get props => [];
}
