import 'package:animated_text_kit/animated_text_kit.dart';
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

    context.read<UserBloc>().add(const UserEventCheckAuthRequested());

    var userBloc = context.read<UserBloc>();

    Future<void>.delayed(const Duration(seconds: 3)).then((_) {
      switch (userBloc.state.status) {
        case AuthenticationStatus.authenticated:
          GoRouter.of(context).pushReplacementNamed('dashboard');
        case AuthenticationStatus.unauthenticated:
          GoRouter.of(context).pushReplacementNamed('sign');
        case AuthenticationStatus.unknown:
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
        value: context.read<UserBloc>(),
        child: Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
          ),
          body: Container(
            child: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(
                  height: 32,
                ),
                AnimatedTextKit(
                  animatedTexts: [
                    TypewriterAnimatedText(
                      'loading...',
                      textStyle: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary),
                      speed: const Duration(milliseconds: 150),
                    ),
                  ],
                  repeatForever: true,
                  pause: const Duration(milliseconds: 75),
                )
              ],
            )),
          ),
        ));
  }
}
