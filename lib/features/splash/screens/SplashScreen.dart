import 'package:finance_builder/api/AutoLogoutService.dart';
import 'package:finance_builder/features/user/bloc/user.bloc.dart';
import 'package:finance_builder/features/user/bloc/user.repository.dart';
import 'package:finance_builder/features/user/bloc/user.state.dart';
import 'package:finance_builder/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key, required this.title});

  final String title;

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
        value: context.read<UserBloc>()
          ..add(const UserEventCheckAuthRequested()),
        child: BlocListener<UserBloc, UserState>(
          listener: (context, state) {
            Future<void>.delayed(const Duration(seconds: 2)).then((_) {
              switch (state.status) {
                case AuthenticationStatus.authenticated:
                  GoRouter.of(context).pushReplacementNamed('dashboard');
                case AuthenticationStatus.unauthenticated:
                  GoRouter.of(context).pushReplacementNamed('sign');
                case AuthenticationStatus.unknown:
                  break;
              }
            });
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text(widget.title),
            ),
            body: Container(
              child: const Center(child: CircularProgressIndicator()),
            ),
          ),
        ));
  }
}
