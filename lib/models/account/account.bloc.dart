import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:finance_builder/models/account/account.events.dart';
import 'package:finance_builder/models/account/account.model.dart';
import 'package:finance_builder/models/account/account.repository.dart';
import 'package:finance_builder/models/account/account.state.dart';

class AccountsBloc extends Bloc<AccountEvent, AccountsState> {
  AccountsBloc({
    required AccountRepository accountRepository,
  })  : _accountRepository = accountRepository,
        super(const AccountsState()) {
    on<AccountEventSubscriptionRequested>(_onSubscriptionRequested);
    on<AccountEventCreated>(_onAccountCreated);
    on<AccountEventDeleted>(_onAccountDeleted);
  }

  final AccountRepository _accountRepository;

  Future<void> _onSubscriptionRequested(
    AccountEventSubscriptionRequested event,
    Emitter<AccountsState> emit,
  ) async {
    emit(state.copyWith(status: () => AccountStateStatus.loading));

    await emit.forEach<List<Account>>(
      _accountRepository.getAccounts(),
      onData: (accounts) => state.copyWith(
        status: () => AccountStateStatus.success,
        accounts: () => accounts,
      ),
      onError: (_, __) => state.copyWith(
        status: () => AccountStateStatus.failure,
      ),
    );
  }

  Future<void> _onAccountCreated(
    AccountEventCreated event,
    Emitter<AccountsState> emit,
  ) async {
    emit(state.copyWith(accounts: () => [...state.accounts, event.account]));
    await _accountRepository.createAccount(event.account);
  }

  Future<void> _onAccountDeleted(
    AccountEventDeleted event,
    Emitter<AccountsState> emit,
  ) async {
    final lastDeleted = state.accounts
        .firstWhere((it) => it.id == event.id, orElse: () => Account.empty);

    final newList =
        state.accounts.where((element) => element.id != event.id).toList();

    emit(state.copyWith(
        accounts: () => newList,
        lastDeletedAccount: () => Account.copyWith(lastDeleted)));
    await _accountRepository.deleteAccount(event.id);
  }
}
