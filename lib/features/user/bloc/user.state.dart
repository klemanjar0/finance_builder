import 'package:equatable/equatable.dart';

final class UserState extends Equatable {
  const UserState._({this.authToken, this.username});

  const UserState.authenticated(
      {required String username, required String authToken})
      : this._(authToken: authToken, username: username);
  const UserState.unauthenticated() : this._(authToken: null, username: null);

  final String? authToken;
  final String? username;

  UserState copyWith({
    String Function()? authToken,
    String Function()? username,
  }) {
    return UserState._(
      authToken: authToken != null ? authToken() : this.authToken,
      username: username != null ? username() : this.username,
    );
  }

  @override
  List<Object?> get props => [authToken, username];
}
