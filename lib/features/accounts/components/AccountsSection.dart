import 'package:finance_builder/components/SortingBottomSheet/SortingBottomSheet.dart';
import 'package:finance_builder/features/accounts/bloc/types.dart';
import 'package:finance_builder/features/accounts/components/AccountItem.dart';
import 'package:finance_builder/utils/utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

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

  void onDelete(BuildContext context,
      {required String id, required String name}) {
    showAlertDialog(context,
        title: 'remove account',
        content:
            'are you sure you want delete account $name? this will also lead to removal of all transactions in this account.',
        buttons: [
          TextButton(
            child: Text("chill, bro"),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            onPressed: () {
              GoRouter.of(context).pop();
            },
          ),
          TextButton(
            child: Text("ok"),
            onPressed: () {
              print('here ${id}');
              context.read<AccountsBloc>().add(AccountEventDeleteRequested(
                  payload: AccountsRemoveRequestPayload(id: id)));
              GoRouter.of(context).pop();
              // do delete
            },
          )
        ]);
    // implement
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
              Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: FilledButton.icon(
                    icon: state.sortOption.direction == SortDirection.asc
                        ? Icon(Icons.arrow_upward)
                        : Icon(Icons.arrow_downward),
                    label: Text('sort by ${state.sortOption.field}'),
                    onPressed: () {
                      showBottomSort(
                          context,
                          BottomSortConfig(
                              selected: state.sortOption,
                              onSubmit: (SortOption option) {
                                context.read<AccountsBloc>().add(
                                    AccountEventSetSort(sortOption: option));
                              },
                              options: const [
                                SortParam(field: 'name', label: 'name'),
                                SortParam(
                                    field: 'description', label: 'description'),
                                SortParam(field: 'budget', label: 'budget'),
                                SortParam(
                                    field: 'currentBalance', label: 'spent')
                              ]));
                    },
                  )),
              Expanded(
                  child: ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(8),
                      itemCount: state.accounts.length + 1,
                      itemBuilder: (BuildContext context, int index) {
                        var array = state.accounts;
                        if (index == array.length) {
                          return Visibility(
                              visible: state.fetching,
                              child: const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(8),
                                  child: CircularProgressIndicator(),
                                ),
                              ));
                        } else {
                          var accountData = array[index];

                          return AccountUI(
                              account: accountData,
                              onDelete: () => onDelete(context,
                                  id: accountData.id, name: accountData.name));
                        }
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
    return BlocProvider.value(
        value: context.read<AccountsBloc>()
          ..add(const AccountEventGetListRequested(loadMore: false)),
        child: Container(
          child: buildList(context),
        ));
  }
}
