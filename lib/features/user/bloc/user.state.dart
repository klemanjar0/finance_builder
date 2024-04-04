import 'package:equatable/equatable.dart';

enum AuthenticationStatus { unknown, authenticated, unauthenticated }

final class UserState extends Equatable {
  const UserState._(
      {this.authToken,
      this.username,
      required this.status,
      this.fetching = false});

  const UserState.authenticated(
      {required String username, required String authToken})
      : this._(
            authToken: authToken,
            username: username,
            status: AuthenticationStatus.authenticated,
            fetching: false);
  const UserState.unauthenticated()
      : this._(
            authToken: null,
            username: null,
            status: AuthenticationStatus.unauthenticated);
  const UserState.unknown()
      : this._(
            authToken: null,
            username: null,
            status: AuthenticationStatus.unknown);

  final AuthenticationStatus status;
  final String? authToken;
  final String? username;
  final bool fetching;

  UserState copyWith({
    String Function()? authToken,
    String Function()? username,
    AuthenticationStatus Function()? status,
    bool Function()? fetching,
  }) {
    return UserState._(
      authToken: authToken != null ? authToken() : this.authToken,
      username: username != null ? username() : this.username,
      status: status != null ? status() : this.status,
      fetching: fetching != null ? fetching() : this.fetching,
    );
  }

  @override
  List<Object?> get props => [authToken, username];
}
