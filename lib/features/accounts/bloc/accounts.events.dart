import 'package:equatable/equatable.dart';

import 'accounts.models.dart';

sealed class AccountEvent extends Equatable {
  const AccountEvent();

  @override
  List<Object> get props => [];
}

final class AccountEventGetListRequested extends AccountEvent {
  const AccountEventGetListRequested(
      {required this.limit, required this.offset});

  final int limit;
  final int offset;

  @override
  List<Object> get props => [limit, offset];
}

final class AccountEventGetListReceived extends AccountEvent {
  const AccountEventGetListReceived(
      {required this.accounts, required this.total});

  final List<Account> accounts;
  final int total;

  @override
  List<Object> get props => [accounts];
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
