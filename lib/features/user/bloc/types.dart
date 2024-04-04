import 'package:equatable/equatable.dart';
import 'package:finance_builder/models/JsonMap.dart';

class SignInSuccess extends Equatable {
  final String username;
  final String authToken;

  const SignInSuccess({required this.username, required this.authToken});

  factory SignInSuccess.fromJson(JsonMap json, String? name) {
    return switch (json) {
      {
        'authToken': String authToken,
      } =>
        SignInSuccess(
          username: name ?? '',
          authToken: authToken,
        ),
      _ => throw const FormatException('Failed to load SignInSuccess.'),
    };
  }

  @override
  List<Object> get props => [username, authToken];
}
