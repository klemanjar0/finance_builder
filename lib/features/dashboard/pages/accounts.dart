import 'package:finance_builder/components/TouchableOpacity/TouchableOpacity.dart';
import 'package:finance_builder/models/account/account.bloc.dart';
import 'package:finance_builder/models/account/account.events.dart';
import 'package:finance_builder/models/account/account.repository.dart';
import 'package:finance_builder/models/account/account.state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AccountItem extends StatelessWidget {
  const AccountItem(
      {super.key, required this.title, required this.isNegativeAllowed});

  final String title;
  final bool isNegativeAllowed;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
        child: TouchableOpacity(
          onTap: () {
            print('Tap');
          },
          child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.account_balance),
                              SizedBox(
                                width: 8,
                              ),
                              Text(
                                title,
                                style: TextStyle(fontSize: 22),
                              )
                            ],
                          ),
                          Text("Balance: \$0.00")
                        ],
                      ),
                      Row(
                        children: [
                          if (!isNegativeAllowed)
                            Icon(Icons.monetization_on_sharp,
                                color: Colors.green),
                          SizedBox(
                            width: 8,
                          ),
                          if (!isNegativeAllowed)
                            Text(
                              'DEBIT ONLY',
                              style: TextStyle(
                                  inherit: true,
                                  color: Colors.deepOrange,
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
            separatorBuilder: (context, index) => Padding(
              padding: EdgeInsets.symmetric(
                vertical: 0.0,
                horizontal: 24,
              ),
              child: Divider(
                color: Colors.black12,
              ),
            ),
            itemCount: state.accounts.length,
            itemBuilder: (context, index) => Padding(
              padding: EdgeInsets.all(8.0),
              child: AccountItem(
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
