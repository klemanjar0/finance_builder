import 'package:finance_builder/features/user/bloc/user.bloc.dart';
import 'package:finance_builder/features/user/bloc/user.repository.dart';
import 'package:finance_builder/features/user/bloc/user.state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {},
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("My title"),
      content: Text("This is my message."),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => UserBloc(
              userRepository: context.read<UserRepository>(),
            ),
        child: BlocListener<UserBloc, UserState>(
          listener: (context, state) {
            print(state.status);
            switch (state.status) {
              case AuthenticationStatus.authenticated:
                Future<void>.delayed(const Duration(seconds: 3));
              //print('one');
              case AuthenticationStatus.unauthenticated:
                Future<void>.delayed(const Duration(seconds: 3));
                print('two'); // TODO
              case AuthenticationStatus.unknown:
                break;
            }
          },
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              title: Text(widget.title),
            ),
            body: Container(
              color: Colors.white,
              child: Center(child:
                  BlocBuilder<UserBloc, UserState>(builder: (context, state) {
                return const CircularProgressIndicator();
              })),
            ),
          ),
        ));
  }
}
