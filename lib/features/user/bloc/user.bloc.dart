import 'dart:async';

import 'package:equatable/equatable.dart';
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

final class UserEventSignInSubmitted extends UserEvent {
  const UserEventSignInSubmitted(
      {required this.username, required this.authToken});

  final String username;
  final String authToken;

  @override
  List<Object> get props => [username, authToken];
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
}

class UserBloc extends HydratedBloc<UserEvent, UserState> {
  UserBloc({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(const UserState.unknown()) {
    on<UserEventSignInRequested>(_onUserEventSignInRequested);
    on<UserEventStatusChanged>(_UserEventStatusChanged);
    on<UserEventSignInSubmitted>(_onUserEventSignInSubmitted);
    on<UserEventSignOutRequested>(_onUserEventSignOutRequested);
    on<UserEventCheckAuthRequested>(_onUserEventCheckAuthRequested);
    _authenticationStatusSubscription = userRepository.status.listen(
      (status) => add(UserEventStatusChanged(status)),
    );
  }

  late StreamSubscription<AuthenticationStatus>
      _authenticationStatusSubscription;
  final UserRepository _userRepository;

  void _onUserEventSignOutRequested(
      UserEventSignOutRequested event, Emitter<UserState> emit) {
    emit(const UserState.unauthenticated());
  }

  void _onUserEventSignInRequested(
      UserEventSignInRequested event, Emitter<UserState> emit) async {
    emit(state.copyWith(fetching: () => true));
    var result = await _userRepository.signIn(
        username: event.username, password: event.password);
    add(UserEventSignInSubmitted(
        authToken: result.authToken, username: result.username));
  }

  void _onUserEventSignInSubmitted(
      UserEventSignInSubmitted event, Emitter<UserState> emit) {
    emit(UserState.authenticated(
        username: event.username, authToken: event.authToken));
  }

  void _UserEventStatusChanged(
      UserEventStatusChanged event, Emitter<UserState> emit) {}

  dynamic _onUserEventCheckAuthRequested(event, emit) {
    var username = state.username;
    var authToken = state.authToken;
    var isLoggedIn = authToken != null && username != null;

    if (isLoggedIn) {
      return emit(
          UserState.authenticated(username: username, authToken: authToken));
    } else {
      return emit(const UserState.unauthenticated());
    }
  }

  @override
  UserState fromJson(Map<String, dynamic> json) {
    final String? authToken = json['authToken'];
    final String? username = json['username'];

    if (authToken == null || username == null) {
      return const UserState.unauthenticated();
    }

    return UserState.authenticated(username: username, authToken: authToken);
  }

  @override
  Map<String, String?> toJson(UserState state) =>
      {'authToken': state.authToken, 'username': state.username};
}
