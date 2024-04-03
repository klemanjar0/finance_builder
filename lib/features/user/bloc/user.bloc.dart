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

class UserBloc extends HydratedBloc<UserEvent, UserState> {
  UserBloc({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(const UserState.unauthenticated()) {
    on<UserEventSignInRequested>((event, emit) => {});
    on<UserEventSignInSubmitted>((event, emit) => {});
    on<UserEventSignOutRequested>((event, emit) => {});
  }

  final UserRepository _userRepository;

  @override
  Future<void> close() {
    _userRepository.dispose();
    return super.close();
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
