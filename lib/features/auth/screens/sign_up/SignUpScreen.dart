import 'package:finance_builder/api/AutoLogoutService.dart';
import 'package:finance_builder/features/user/bloc/user.bloc.dart';
import 'package:finance_builder/features/user/bloc/user.repository.dart';
import 'package:finance_builder/features/user/bloc/user.state.dart';
import 'package:finance_builder/theme/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  SignUpScreenState createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
  bool _passwordVisible = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _togglePasswordVisible() {
    setState(() {
      _passwordVisible = !_passwordVisible;
    });
  }

  VoidCallback _onSignInPressed(BuildContext context) {
    return () {
      String email = _emailController.value.text;
      String password = _passwordController.value.text;

      context
          .read<UserBloc>()
          .add(UserEventSignUpRequested(username: email, password: password));
    };
  }

  @override
  void initState() {
    _passwordVisible = false;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => UserBloc(
              userRepository: context.read<UserRepository>(),
              autoLogoutService: context.read<AutoLogoutService>(),
            ),
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Create Account'),
          ),
          body: Container(
            width: double.infinity,
            child: Center(
              child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextFormField(
                        style: Theme.of(context).textTheme.bodyMedium,
                        controller: _emailController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.email_outlined),
                          labelText: 'email',
                          labelStyle: Theme.of(context).textTheme.bodyMedium,
                          hintText: 'enter your email, sweetie',
                        ),
                      ),
                      TextFormField(
                          style: Theme.of(context).textTheme.bodyMedium,
                          controller: _passwordController,
                          obscureText: !_passwordVisible,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.password_outlined),
                            labelText: 'password',
                            labelStyle: Theme.of(context).textTheme.bodyMedium,
                            hintText: 'and create a password, booty',
                            suffixIcon: IconButton(
                              icon: Icon(
                                // Based on passwordVisible state choose the icon
                                _passwordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Theme.of(context).primaryColorLight,
                              ),
                              onPressed: _togglePasswordVisible,
                            ),
                          )),
                      const SizedBox(height: 16),
                      BlocBuilder<UserBloc, UserState>(
                          builder: (context, state) {
                        return FilledButton.icon(
                            onPressed: state.fetching
                                ? null
                                : _onSignInPressed(context),
                            icon: state.fetching
                                ? Container(
                                    width: 24,
                                    height: 24,
                                    padding: const EdgeInsets.all(2.0),
                                    child: const CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 3,
                                    ),
                                  )
                                : const Icon(Icons.login_outlined),
                            label: const Text('let\'s do it!'));
                      }),
                      BlocListener<UserBloc, UserState>(
                        listener: (context, state) {
                          if (state.status ==
                              AuthenticationStatus.authenticated) {
                            GoRouter.of(context)
                                .pushReplacementNamed('dashboard');
                          }
                        },
                        child: const SizedBox(),
                      ),
                      const SizedBox(height: 32),
                      BlocBuilder<UserBloc, UserState>(
                          builder: (context, state) {
                        return Text(
                          state.message ?? '',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium?.apply(
                              color: Theme.of(context).colorScheme.error),
                        );
                      }),
                    ],
                  )),
            ),
          ),
        ));
  }
}
