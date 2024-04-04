import 'package:finance_builder/features/user/bloc/user.bloc.dart';
import 'package:finance_builder/features/user/bloc/user.repository.dart';
import 'package:finance_builder/features/user/bloc/user.state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SignScreen extends StatefulWidget {
  const SignScreen({super.key});

  @override
  SignScreenState createState() => SignScreenState();
}

class SignScreenState extends State<SignScreen> {
  bool _passwordVisible = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void _togglePasswordVisible() {
    setState(() {
      _passwordVisible = !_passwordVisible;
    });
  }

  VoidCallback _onSignInPressed(BuildContext context) {
    return () {
      final String email = emailController.value.text;
      final String password = emailController.value.text;
      context
          .read<UserBloc>()
          .add(UserEventSignInRequested(username: email, password: password));
    };
  }

  void _onSignUpPressed() {}

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
            ),
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Sign In'),
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
                        controller: emailController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.email_outlined),
                          labelText: 'email',
                          labelStyle: Theme.of(context).textTheme.bodyMedium,
                          hintText: 'enter your email, honey',
                        ),
                      ),
                      TextFormField(
                          style: Theme.of(context).textTheme.bodyMedium,
                          controller: passwordController,
                          obscureText: !_passwordVisible,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.password_outlined),
                            labelText: 'password',
                            labelStyle: Theme.of(context).textTheme.bodyMedium,
                            hintText: 'and your password, sweetie',
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
                        return FilledButton(
                            onPressed: _onSignInPressed(context),
                            child: const Text('do something, i want in!'));
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
                      BlocBuilder<UserBloc, UserState>(
                          builder: (context, state) {
                        if (state.fetching) {
                          return const Padding(
                              padding: EdgeInsets.all(8),
                              child: CircularProgressIndicator());
                        }

                        return const SizedBox(
                          height: 0,
                        );
                      }),
                      const SizedBox(height: 32),
                      Text(
                        'we do not share anyone\'s data. we promise. \nmaybe only the way you\'re so cute. and nothing else.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.apply(color: Theme.of(context).primaryColorLight),
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                      ElevatedButton(
                          onPressed: () {},
                          child: const Text(
                              'i don\'t have an account :c lemme create one'))
                    ],
                  )),
            ),
          ),
        ));
  }
}
