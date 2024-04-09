import 'package:bloc/bloc.dart';

import 'accounts.events.dart';
import 'accounts.repository.dart';
import 'accounts.state.dart';

class AccountsBloc extends Bloc<AccountEvent, AccountState> {
  AccountsBloc({required AccountsRepository accountsRepository})
      : _accountsRepository = accountsRepository,
        super(AccountState.empty()) {
    on<AccountEventResetState>(_onAccountEventResetState);
  }

  final AccountsRepository _accountsRepository;

  void _onAccountEventResetState(
      AccountEventResetState event, Emitter<AccountState> emit) {
    emit(AccountState.empty());
  }
}
