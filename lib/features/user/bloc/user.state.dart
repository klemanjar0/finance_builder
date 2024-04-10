import 'package:equatable/equatable.dart';

enum AuthenticationStatus { unknown, authenticated, unauthenticated }

class User {
  User({required this.username, required this.authToken});

  User.empty() : this(authToken: null, username: null);

  final String? username;
  final String? authToken;

  bool isAuthed() {
    return authToken != null;
  }
}

class UserState extends Equatable {
  const UserState._(
      {required this.user,
      required this.status,
      this.fetching = false,
      this.message,
      this.sync = 0});

  const UserState.authenticated({required User user})
      : this._(user: user, status: AuthenticationStatus.authenticated);
  UserState.unauthenticated()
      : this._(
            user: User.empty(),
            sync: 0,
            status: AuthenticationStatus.unauthenticated);
  UserState.unknown()
      : this._(
            user: User.empty(),
            status: AuthenticationStatus.unknown,
            sync: 0,
            fetching: false);

  final AuthenticationStatus status;
  final User user;
  final String? message;
  final bool fetching;
  final int sync;

  UserState copyWith({
    User Function()? user,
    AuthenticationStatus Function()? status,
    bool Function()? fetching,
    String? Function()? message,
    int Function()? sync,
  }) {
    return UserState._(
      user: user != null ? user() : this.user,
      status: status != null ? status() : this.status,
      fetching: fetching != null ? fetching() : this.fetching,
      message: message != null ? message() : this.message,
      sync: sync != null ? sync() : this.sync,
    );
  }

  UserState updateSync() {
    return UserState._(
        user: user,
        status: status,
        fetching: fetching,
        message: message,
        sync: sync + 1);
  }

  UserState loading({
    required bool fetching,
  }) {
    return UserState._(
      user: this.user,
      status: this.status,
      fetching: fetching,
      message: this.message,
      sync: sync,
    );
  }

  @override
  List<Object?> get props => [user.authToken, user.username, status, fetching, message, sync];
}
