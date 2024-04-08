import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:finance_builder/api/NetworkService.dart';
import 'package:finance_builder/features/user/bloc/user.repository.dart';
import 'package:finance_builder/features/user/bloc/user.state.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

sealed class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

final class UserEventSignInRequested extends UserEvent {
  const UserEventSignInRequested(
      {required this.username, required this.password});

  final String username;
  final String password;

  @override
  List<Object> get props => [username, password];
}

final class UserEventSignUpRequested extends UserEvent {
  const UserEventSignUpRequested(
      {required this.username, required this.password});

  final String username;
  final String password;

  @override
  List<Object> get props => [username, password];
}

final class UserEventSignInSubmitted extends UserEvent {
  const UserEventSignInSubmitted(
      {required this.username, required this.authToken});

  final String username;
  final String authToken;

  @override
  List<Object> get props => [username, authToken];
}

final class UserEventSignInSubmittedFailed extends UserEvent {
  const UserEventSignInSubmittedFailed({required this.message});

  final String message;

  @override
  List<Object> get props => [message];
}

final class UserEventSetFetching extends UserEvent {
  const UserEventSetFetching({required this.flag});

  final bool flag;

  @override
  List<Object> get props => [flag];
}

final class UserEventResetError extends UserEvent {
  const UserEventResetError();

  @override
  List<Object> get props => [];
}

final class UserEventSignOutRequested extends UserEvent {
  const UserEventSignOutRequested();

  @override
  List<Object> get props => [];
}

final class UserEventCheckAuthRequested extends UserEvent {
  const UserEventCheckAuthRequested();

  @override
  List<Object> get props => [];
}

final class UserEventStatusChanged extends UserEvent {
  const UserEventStatusChanged(this.status);

  final AuthenticationStatus status;

  @override
  List<Object> get props => [status];
}

final class UserEventInvokeBuild extends UserEvent {
  const UserEventInvokeBuild();

  @override
  List<Object> get props => [];
}

class UserBloc extends HydratedBloc<UserEvent, UserState> {
  UserBloc({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(UserState.unknown()) {
    on<UserEventSignInRequested>(_onUserEventSignInRequested);
    on<UserEventStatusChanged>(_UserEventStatusChanged);
    on<UserEventSignInSubmitted>(_onUserEventSignInSubmitted);
    on<UserEventSignOutRequested>(_onUserEventSignOutRequested);
    on<UserEventCheckAuthRequested>(_onUserEventCheckAuthRequested);
    on<UserEventSignInSubmittedFailed>(_onUserEventSignInSubmittedFailed);
    on<UserEventSignUpRequested>(_onUserEventSignUpRequested);
    on<UserEventResetError>(_onUserEventResetError);
    on<UserEventSetFetching>((event, emit) {
      emit(state.copyWith(fetching: () => event.flag));
    });
    on<UserEventInvokeBuild>((event, emit) {
      emit(state.updateSync());
    });
  }

  late StreamSubscription<AuthenticationStatus>
      _authenticationStatusSubscription;
  final UserRepository _userRepository;

  void _onUserEventResetError(
      UserEventResetError event, Emitter<UserState> emit) {
    emit(state.copyWith(message: () => null));
  }

  void _onUserEventSignOutRequested(
      UserEventSignOutRequested event, Emitter<UserState> emit) {
    emit(UserState.unauthenticated());
  }

  void _onUserEventSignUpRequested(
      UserEventSignUpRequested event, Emitter<UserState> emit) async {
    add(const UserEventSetFetching(flag: true));
    try {
      var result = await _userRepository.signUp(
          username: event.username, password: event.password);

      add(UserEventSignInSubmitted(
          authToken: result.authToken, username: result.username));
    } on NetworkException catch (e) {
      add(UserEventSignInSubmittedFailed(message: e.toString()));
    } finally {
      add(const UserEventSetFetching(flag: false));
    }
  }

  void _onUserEventSignInSubmittedFailed(
      UserEventSignInSubmittedFailed event, Emitter<UserState> emit) async {
    emit(state.copyWith(message: () => event.message));
  }

  void _onUserEventSignInRequested(
      UserEventSignInRequested event, Emitter<UserState> emit) async {
    add(const UserEventResetError());
    add(const UserEventSetFetching(flag: true));
    try {
      print('_onUserEventSignInRequested');
      var result = await _userRepository.signIn(
          username: event.username, password: event.password);

      add(UserEventSignInSubmitted(
          authToken: result.authToken, username: result.username));
    } on NetworkException catch (e) {
      add(UserEventSignInSubmittedFailed(message: e.toString()));
    } finally {
      add(const UserEventSetFetching(flag: false));
    }
  }

  void _onUserEventSignInSubmitted(
      UserEventSignInSubmitted event, Emitter<UserState> emit) {
    emit(UserState.authenticated(
        user: User(authToken: event.authToken, username: event.username)));
  }

  void _UserEventStatusChanged(
      UserEventStatusChanged event, Emitter<UserState> emit) {
    emit(state.copyWith(status: () => event.status));
  }

  void _onUserEventCheckAuthRequested(event, emit) {
    emit(state.updateSync());
    var username = state.user.username;
    var authToken = state.user.authToken;
    var isLoggedIn = authToken != null && username != null;
    if (isLoggedIn) {
      emit(UserState.authenticated(
          user: User(authToken: event.authToken, username: event.username)));
    } else {
      emit(UserState.unauthenticated());
    }
  }

  @override
  UserState fromJson(Map<String, dynamic> json) {
    final String? authToken = json['authToken'];
    final String? username = json['username'];
    if (authToken == null || username == null) {
      return UserState.unauthenticated();
    }

    _userRepository.fromPersist(authToken);

    return UserState.authenticated(
        user: User(authToken: authToken, username: username));
  }

  @override
  Map<String, String?> toJson(UserState state) =>
      {'authToken': state.user.authToken, 'username': state.user.username};
}
