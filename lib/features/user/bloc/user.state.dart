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
      this.message});

  const UserState.authenticated({required User user})
      : this._(user: user, status: AuthenticationStatus.authenticated);
  UserState.unauthenticated()
      : this._(
            user: User.empty(), status: AuthenticationStatus.unauthenticated);
  UserState.unknown()
      : this._(
            user: User.empty(),
            status: AuthenticationStatus.unknown,
            fetching: false);

  final AuthenticationStatus status;
  final User user;
  final String? message;
  final bool fetching;

  UserState copyWith({
    User Function()? user,
    AuthenticationStatus Function()? status,
    bool Function()? fetching,
    String? Function()? message,
  }) {
    return UserState._(
      user: user != null ? user() : this.user,
      status: status != null ? status() : this.status,
      fetching: fetching != null ? fetching() : this.fetching,
      message: message != null ? message() : this.message,
    );
  }

  UserState loading({
    required bool fetching,
  }) {
    return UserState._(
      user: this.user,
      status: this.status,
      fetching: fetching,
      message: this.message,
    );
  }

  @override
  List<Object?> get props => [user, status, fetching, message];
}
