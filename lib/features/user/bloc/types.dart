import 'package:equatable/equatable.dart';

class SignInSuccess extends Equatable {
  final String username;
  final String authToken;

  const SignInSuccess({required this.username, required this.authToken});

  @override
  List<Object> get props => [username, authToken];
}
