import 'package:equatable/equatable.dart';
import 'package:finance_builder/models/account/account.model.dart';

sealed class AccountEvent extends Equatable {
  const AccountEvent();

  @override
  List<Object> get props => [];
}

final class AccountEventSubscriptionRequested extends AccountEvent {
  const AccountEventSubscriptionRequested();
}

final class AccountEventCreated extends AccountEvent {
  const AccountEventCreated(this.account);

  final Account account;

  @override
  List<Object> get props => [account];
}

final class AccountEventDeleted extends AccountEvent {
  const AccountEventDeleted(this.id);

  final String id;

  @override
  List<Object> get props => [id];
}
