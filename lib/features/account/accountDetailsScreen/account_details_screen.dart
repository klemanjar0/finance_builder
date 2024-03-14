import 'package:finance_builder/models/account/account.bloc.dart';
import 'package:finance_builder/models/account/account.events.dart';
import 'package:finance_builder/models/account/account.model.dart';
import 'package:finance_builder/models/account/account.repository.dart';
import 'package:finance_builder/models/account/account.state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AccountDetailsScreen extends StatefulWidget {
  const AccountDetailsScreen({super.key, required this.id});
  final String? id;

  @override
  AccountDetailsScreenState createState() => AccountDetailsScreenState();
}

class AccountDetailsScreenState extends State<AccountDetailsScreen> {
  String _pageTitle = 'Account Page';

  void onTitleUpdate(String title) {
    setState(() {
      _pageTitle = title;
    });
  }

  Account _accountSelector(AccountsState state) {
    if (state.status != AccountStateStatus.success) {
      return Account.empty;
    }
    return state.accounts.firstWhere((item) => item.id == widget.id,
        orElse: () => Account.empty);
  }

  VoidCallback _onDeleteAccountPressed(BuildContext context) {
    return () {
      if (widget.id == null) {
        return;
      }
      context.read<AccountsBloc>().add(
            AccountEventDeleted(widget.id!),
          );
      context.pop();
    };
  }

  @override
  Widget build(BuildContext context) {
    if (widget.id == null) {
      return const Center(child: Text("Account ID is not provided"));
    }

    return BlocProvider(
        create: (context) => AccountsBloc(
              accountRepository: context.read<AccountRepository>(),
            )..add(const AccountEventSubscriptionRequested()),
        child: Scaffold(
          appBar: AppBar(
              scrolledUnderElevation: 0.0,
              backgroundColor: Colors.white24,
              title: Text(_pageTitle)),
          body: MultiBlocListener(
              listeners: [
                BlocListener<AccountsBloc, AccountsState>(
                  listenWhen: (previous, current) =>
                      previous.status != current.status,
                  listener: (context, state) {
                    if (state.status == AccountStateStatus.failure) {
                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(
                          const SnackBar(
                            content: Text("ERROR"),
                          ),
                        );
                    }
                  },
                ),
                BlocListener<AccountsBloc, AccountsState>(
                  listenWhen: (previous, current) =>
                      previous.lastDeletedAccount !=
                          current.lastDeletedAccount &&
                      current.lastDeletedAccount != null,
                  listener: (context, state) {
                    final lastDeletedAccount = state.lastDeletedAccount!;
                    final messenger = ScaffoldMessenger.of(context);
                    messenger
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                        SnackBar(
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          content: Text(
                              '${lastDeletedAccount.name} has been deleted'),
                          action: SnackBarAction(
                            label:
                                "Undo delete ${lastDeletedAccount.name} (In development)",
                            onPressed: () {
                              messenger.hideCurrentSnackBar();
                            },
                          ),
                        ),
                      );
                  },
                ),
                BlocListener<AccountsBloc, AccountsState>(
                  listenWhen: (previous, current) =>
                      previous.status != current.status,
                  listener: (context, state) {
                    onTitleUpdate(_accountSelector(state).name);
                  },
                )
              ],
              child: BlocSelector<AccountsBloc, AccountsState, Account>(
                selector: _accountSelector,
                builder: (context, state) {
                  return Container(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          children: [
                            const Text(
                              "Current Balance: \$0.00",
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.w700),
                            ),
                            BlocBuilder<AccountsBloc, AccountsState>(
                                builder: (context, state) {
                              return FilledButton.tonal(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        const MaterialStatePropertyAll<Color>(
                                            Colors.lightGreenAccent),
                                    minimumSize: MaterialStateProperty.all(
                                        Size(200, 40)),
                                    elevation: MaterialStateProperty.all(0),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                    ),
                                  ),
                                  onPressed: _onDeleteAccountPressed(context),
                                  child: Text('Delete Account'));
                            }),
                          ],
                        ),
                      ));
                },
              )),
        ));
  }
}
