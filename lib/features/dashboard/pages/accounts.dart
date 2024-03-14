import 'package:finance_builder/components/TouchableOpacity/TouchableOpacity.dart';
import 'package:finance_builder/models/account/account.bloc.dart';
import 'package:finance_builder/models/account/account.events.dart';
import 'package:finance_builder/models/account/account.repository.dart';
import 'package:finance_builder/models/account/account.state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AccountItem extends StatelessWidget {
  const AccountItem(
      {super.key,
      required this.id,
      required this.title,
      required this.isNegativeAllowed});

  final String id;
  final String title;
  final bool isNegativeAllowed;

  VoidCallback onOpenDetails(BuildContext context) {
    return () {
      context.goNamed('account', pathParameters: {'id': id});
    };
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
        child: TouchableOpacity(
          onTap: onOpenDetails(context),
          child: Container(
              width: double.infinity,
              child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 2, horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                              child: Text(
                            title,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 26, fontWeight: FontWeight.bold),
                          )),
                          const Text("\$0.00",
                              style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w500))
                        ],
                      ),
                      Row(
                        children: [
                          if (!isNegativeAllowed)
                            const Text(
                              'DEBIT ONLY',
                              style: TextStyle(
                                  inherit: true,
                                  color: Colors.black45,
                                  fontWeight: FontWeight.w700),
                            )
                        ],
                      ),
                    ],
                  ))),
        ));
  }
}

class AccountsPage extends StatefulWidget {
  const AccountsPage({super.key});

  @override
  AccountsPageState createState() => AccountsPageState();
}

class AccountsPageState extends State<AccountsPage> {
  void onAddAccountButtonPress() {}

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AccountsBloc(
        accountRepository: context.read<AccountRepository>(),
      )..add(const AccountEventSubscriptionRequested()),
      child: Scrollbar(
        child:
            BlocBuilder<AccountsBloc, AccountsState>(builder: (context, state) {
          return ListView.separated(
            separatorBuilder: (context, index) => const Padding(
              padding: EdgeInsets.only(left: 24),
              child: Divider(
                color: Colors.black12,
              ),
            ),
            itemCount: state.accounts.length,
            itemBuilder: (context, index) => Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: AccountItem(
                id: state.accounts[index].id,
                title: state.accounts[index].name,
                isNegativeAllowed: state.accounts[index].isNegativeAllowed,
              ),
            ),
          );
        }),
      ),
    );
  }
}
