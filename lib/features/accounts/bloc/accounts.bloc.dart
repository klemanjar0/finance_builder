import 'package:bloc/bloc.dart';
import 'package:finance_builder/features/accounts/bloc/accounts.models.dart';
import 'package:finance_builder/utils/utility.dart';

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
    on<AccountEventCreateRequested>(_onAccountEventCreateRequested);
    on<AccountEventCreateFailure>(_onAccountEventCreateFailure);
    on<AccountEventDeleteRequested>(_onAccountEventDeleteRequested);
    on<AccountEventDeleteFailure>(_onAccountEventDeleteFailure);
    on<AccountEventSetSort>(_onAccountEventSetSort);
    on<AccountEventGetSingleAccountRequested>(
        _onAccountEventGetSingleAccountRequested);
    on<AccountEventGetSingleAccountSuccess>(
        _onAccountEventGetSingleAccountSuccess);
    on<AccountEventGetSingleAccountFailed>(
        _onAccountEventGetSingleAccountFailed);
    on<AccountEventResetAccountError>(_onAccountEventResetAccountError);
    on<AccountEventResetSingleAccount>(_onAccountEventResetSingleAccount);
  }

  final AccountsRepository _accountsRepository;
  final int _limit = 15;

  void initOnLoadMore(void Function(void Function()) cb) {
    cb(() {
      add(const AccountEventGetListRequested(loadMore: true));
    });
  }

  void _onAccountEventSetSort(
      AccountEventSetSort event, Emitter<AccountState> emit) {
    emit(state.setSort(event.sortOption));

    add(const AccountEventGetListRequested(loadMore: false));
  }

  void _onAccountEventResetSingleAccount(
      AccountEventResetSingleAccount event, Emitter<AccountState> emit) {
    emit(state.setSingle(null));
  }

  void _onAccountEventResetAccountError(event, emit) {
    emit(state.resetSingleError());
  }

  void _onAccountEventGetSingleAccountFailed(
      AccountEventGetSingleAccountFailed event, Emitter<AccountState> emit) {
    emit(state.setSingleError(event.errorMessage));
  }

  void _onAccountEventGetSingleAccountSuccess(
      AccountEventGetSingleAccountSuccess event, Emitter<AccountState> emit) {
    emit(state.setSingle(event.payload.account));
  }

  void _onAccountEventGetSingleAccountRequested(
      AccountEventGetSingleAccountRequested event,
      Emitter<AccountState> emit) async {
    if (state.single != null) {
      return;
    }

    emit(state.resetSingleError());
    emit(state.setSingleFetching(true));

    try {
      var account = await _accountsRepository.getAccount(event.payload);

      add(AccountEventGetSingleAccountSuccess(
          payload: GetSingleAccountSuccessPayload(account: account)));
    } on Exception catch (e) {
      showToast('Failed to open account: ${e.toString()}');
    } finally {
      emit(state.setSingleFetching(false));
    }
  }

  void _onAccountEventDeleteRequested(
      AccountEventDeleteRequested event, Emitter<AccountState> emit) async {
    emit(state.setFetching(true));

    try {
      await _accountsRepository.removeAccount(event.payload);

      add(const AccountEventGetListRequested(loadMore: false));
    } on Exception catch (e) {
      showToast('Failed to delete account: ${e.toString()}');
    } finally {
      emit(state.setFetching(false));
    }
  }

  void _onAccountEventResetState(
      AccountEventResetState event, Emitter<AccountState> emit) {
    emit(AccountState.empty());
  }

  void _onAccountEventDeleteFailure(
      AccountEventDeleteFailure event, Emitter<AccountState> emit) {
    emit(state.failure(event.message));
  }

  void _onAccountEventCreateFailure(
      AccountEventCreateFailure event, Emitter<AccountState> emit) {
    emit(state.failure(event.message));
  }

  void _onAccountEventCreateRequested(
      AccountEventCreateRequested event, Emitter<AccountState> emit) async {
    emit(state.setFetching(true));

    try {
      await _accountsRepository.createAccount(event.payload);

      add(const AccountEventGetListRequested(loadMore: false));
    } on Exception catch (e) {
      add(AccountEventCreateFailure(message: e.toString()));
      showToast('Failed to create account: ${e.toString()}');
    } finally {
      emit(state.setFetching(false));
    }
  }

  void _onAccountEventGetListRequested(
      AccountEventGetListRequested event, Emitter<AccountState> emit) async {
    if (state.isLoaded && event.autoTriggered == true) {
      return;
    }

    if (!event.loadMore) {
      emit(state.resetData());
    }

    if (event.loadMore && state.total == state.accounts.length) {
      return;
    }

    emit(state.resetError());
    emit(state.setFetching(true));

    try {
      var dataLength = state.accounts.length;
      var response = await _accountsRepository.getAccounts(
          AccountsRequestPayload(
              limit: _limit,
              offset: event.loadMore ? dataLength : 0,
              sortOption: state.sortOption));

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
    emit(state.loaded(accounts: data, total: event.total));
  }

  void _onAccountEventGetListFailure(
      AccountEventGetListFailure event, Emitter<AccountState> emit) {
    emit(state.failure(event.message));
  }
}
