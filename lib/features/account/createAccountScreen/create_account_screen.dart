import 'package:finance_builder/models/account/account.bloc.dart';
import 'package:finance_builder/models/account/account.events.dart';
import 'package:finance_builder/models/account/account.model.dart';
import 'package:finance_builder/models/account/account.repository.dart';
import 'package:finance_builder/models/account/account.state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key, required this.title});

  final String title;

  @override
  CreateAccountScreenState createState() => CreateAccountScreenState();
}

class CreateAccountScreenState extends State<CreateAccountScreen> {
  String name = '';
  String description = '';

  final nameController = TextEditingController();

  VoidCallback _onCreatedAccountPressed(BuildContext context) {
    return () {
      final String accountName = nameController.value.text;
      context.read<AccountsBloc>().add(
            AccountEventCreated(Account(
              name: accountName,
            )),
          );
      context.pop();
    };
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AccountsBloc(
        accountRepository: context.read<AccountRepository>(),
      ),
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: TextFormField(
                  controller: nameController,
                  style: TextStyle(color: Colors.black),
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.account_balance_wallet),
                    border: UnderlineInputBorder(),
                    labelText: 'Account Name',
                    labelStyle: TextStyle(color: Colors.black),
                    fillColor: Colors.black26,
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black26),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.lightGreenAccent),
                    ),
                  ),
                )),
            Center(child: BlocBuilder<AccountsBloc, AccountsState>(
              builder: (context, state) {
                return FilledButton.tonal(
                    style: ButtonStyle(
                      backgroundColor: const MaterialStatePropertyAll<Color>(
                          Colors.lightGreenAccent),
                      minimumSize: MaterialStateProperty.all(Size(200, 40)),
                      elevation: MaterialStateProperty.all(0),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                    ),
                    onPressed: _onCreatedAccountPressed(context),
                    child: Text('Create'));
              },
            ))
          ],
        ),
        appBar: AppBar(
          backgroundColor: Colors.lightGreenAccent,
          title: Text(widget.title),
        ),
      ),
    );
  }
}
