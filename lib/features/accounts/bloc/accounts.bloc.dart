import 'package:bloc/bloc.dart';
import 'package:finance_builder/features/accounts/bloc/accounts.models.dart';

import 'accounts.events.dart';
import 'accounts.repository.dart';
import 'accounts.state.dart';
import 'types.dart';

class AccountsBloc extends Bloc<AccountEvent, AccountState> {
  AccountsBloc({required AccountsRepository accountsRepository})
      : _accountsRepository = accountsRepository,
        super(AccountState.empty()) {
    on<AccountEventResetState>(_onAccountEventResetState);
    on<AccountEventGetListRequested>(_onAccountEventGetListRequested);
    on<AccountEventGetListReceived>(_onAccountEventGetListReceived);
    on<AccountEventGetListFailure>(_onAccountEventGetListFailure);
  }

  final AccountsRepository _accountsRepository;
  final int _limit = 15;

  void _onAccountEventResetState(
      AccountEventResetState event, Emitter<AccountState> emit) {
    emit(AccountState.empty());
  }

  void _onAccountEventGetListRequested(
      AccountEventGetListRequested event, Emitter<AccountState> emit) async {
    emit(state.resetError());
    emit(state.setFetching(true));

    try {
      var dataLength = state.accounts.length;
      var response = await _accountsRepository.getAccounts(
          AccountsRequestPayload(
              limit: _limit, offset: event.loadMore ? dataLength : 0));

      add(AccountEventGetListReceived(
          accounts: response.data,
          total: response.total,
          loadMore: event.loadMore));
    } on Exception catch (e) {
      add(AccountEventGetListFailure(message: e.toString()));
    } finally {
      emit(state.setFetching(false));
    }
  }

  void _onAccountEventGetListReceived(
      AccountEventGetListReceived event, Emitter<AccountState> emit) {
    final data = event.loadMore
        ? <Account>[...state.accounts, ...event.accounts]
        : event.accounts;

    emit(AccountState.loaded(accounts: data, total: event.total));
  }

  void _onAccountEventGetListFailure(
      AccountEventGetListFailure event, Emitter<AccountState> emit) {
    emit(AccountState.failure(event.message));
  }
}
