import 'package:finance_builder/features/user/bloc/user.bloc.dart';
import 'package:finance_builder/features/user/bloc/user.repository.dart';
import 'package:finance_builder/features/user/bloc/user.state.dart';
import 'package:finance_builder/theme/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../api/AutoLogoutService.dart';

class SignScreen extends StatefulWidget {
  const SignScreen({super.key});

  @override
  SignScreenState createState() => SignScreenState();
}

class SignScreenState extends State<SignScreen> {
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
          .add(UserEventSignInRequested(username: email, password: password));
    };
  }

  void _onSignUpPressed() {
    GoRouter.of(context).pushNamed('sign_up');
  }

  @override
  void initState() {
    _passwordVisible = false;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
        value: context.read<UserBloc>(),
        child: CupertinoPageScaffold(
          navigationBar: const CupertinoNavigationBar(
            middle: Text('Sign in'),
          ),
          child: SafeArea(
            child: Container(
              width: double.infinity,
              child: Center(
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          child: const Text(
                            'Sign In',
                            style: TextStyle(fontSize: 38),
                          ),
                        ),
                        const Divider(),
                        CupertinoTextField(
                          style: Theme.of(context).textTheme.bodyLarge,
                          controller: _emailController,
                          placeholder: 'Enter your email',
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        CupertinoTextField(
                          style: Theme.of(context).textTheme.bodyLarge,
                          controller: _passwordController,
                          obscureText: !_passwordVisible,
                          placeholder: 'Enter your password',
                          suffix: GestureDetector(
                            onTap: _togglePasswordVisible,
                            child: !_passwordVisible
                                ? const Icon(CupertinoIcons.lock_fill)
                                : const Icon(CupertinoIcons.lock_open_fill),
                          ),
                        ),
                        const SizedBox(height: 32),
                        BlocBuilder<UserBloc, UserState>(
                            builder: (context, state) {
                          return CupertinoButton.filled(
                              onPressed: state.fetching
                                  ? null
                                  : _onSignInPressed(context),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  state.fetching
                                      ? Container(
                                          width: 24,
                                          height: 24,
                                          padding: const EdgeInsets.all(2.0),
                                          child: CupertinoActivityIndicator(
                                            color: Theme.of(context).lochmara,
                                            radius: 12,
                                          ),
                                        )
                                      : const Icon(Icons.login_outlined),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  const Text('Sign in'),
                                ],
                              ));
                        }),
                        const SizedBox(
                          height: 8,
                        ),
                        CupertinoButton(
                            color: Theme.of(context).lavender,
                            onPressed: _onSignUpPressed,
                            child: Text(
                              'Create New Account',
                              style:
                                  TextStyle(color: Theme.of(context).lochmara),
                            )),
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
                            style: TextStyle(
                                color: Theme.of(context).sunsetOrange),
                          );
                        }),
                      ],
                    )),
              ),
            ),
          ),
        ));
  }
}
