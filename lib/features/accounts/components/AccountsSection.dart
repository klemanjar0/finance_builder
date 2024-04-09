import 'package:finance_builder/features/accounts/components/AccountItem.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/accounts.state.dart';
import '../bloc/accounts.events.dart';
import '../bloc/accounts.bloc.dart';
import '../bloc/accounts.repository.dart';

class AccountsSection extends StatefulWidget {
  const AccountsSection({super.key});

  @override
  AccountsSectionState createState() => AccountsSectionState();
}

class AccountsSectionState extends State<AccountsSection> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.atEdge) {
        bool isTop = _scrollController.position.pixels == 0;
        if (!isTop) {
          print('At the bottom');
        }
      }
    });
  }

  Widget buildList(BuildContext context) {
    return BlocBuilder<AccountsBloc, AccountState>(builder: (context, state) {
      return RefreshIndicator(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (state.error != null)
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(state.error!),
                ),
              if (state.fetching)
                const Padding(
                  padding: EdgeInsets.all(8),
                  child: CircularProgressIndicator(),
                ),
              Expanded(
                  child: ListView.builder(
                      //controller: _scrollController,
                      padding: const EdgeInsets.all(8),
                      itemCount: state.accounts.length,
                      itemBuilder: (BuildContext context, int index) {
                        var accountData = state.accounts[index];
                        return AccountUI(
                          account: accountData,
                        );
                      })),
            ],
          ),
          onRefresh: () {
            context
                .read<AccountsBloc>()
                .add(const AccountEventGetListRequested(loadMore: false));
            return Future(() => null);
          });
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) =>
            AccountsBloc(accountsRepository: context.read<AccountsRepository>())
              ..add(const AccountEventGetListRequested(loadMore: false)),
        child: Container(
          child: buildList(context),
        ));
  }
}
