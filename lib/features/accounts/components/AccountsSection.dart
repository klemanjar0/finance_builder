import 'package:finance_builder/components/SortingBottomSheet/SortingBottomSheet.dart';
import 'package:finance_builder/features/accounts/bloc/accounts.models.dart';
import 'package:finance_builder/features/accounts/bloc/types.dart';
import 'package:finance_builder/features/accounts/components/AccountItem.dart';
import 'package:finance_builder/utils/utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
  void Function()? loadMoreCallback;

  @override
  void initState() {
    super.initState();

    context.read<AccountsBloc>()
      ..add(const AccountEventGetListRequested(
          loadMore: false, autoTriggered: true))
      ..initOnLoadMore((loadMoreFn) {
        setState(() {
          loadMoreCallback = loadMoreFn;
        });
      });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        loadMoreCallback!();
      }
    });
  }

  void onDelete({required String id, required String name}) {
    context.read<AccountsBloc>().add(AccountEventDeleteRequested(
        payload: AccountsRemoveRequestPayload(id: id)));
    // implement
  }

  Widget _renderSort(AccountState state) {
    return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: CupertinoButton.filled(
          child: Row(
            children: [
              state.sortOption.direction == SortDirection.asc
                  ? Icon(Icons.arrow_upward)
                  : Icon(Icons.arrow_downward),
              Text('sort by ${state.sortOption.field}'),
            ],
          ),
          onPressed: () {
            showBottomSort(
                context,
                BottomSortConfig(
                    selected: state.sortOption,
                    onSubmit: (SortOption option) {
                      context
                          .read<AccountsBloc>()
                          .add(AccountEventSetSort(sortOption: option));
                    },
                    options: const [
                      SortParam(field: 'name', label: 'name'),
                      SortParam(field: 'description', label: 'description'),
                      SortParam(field: 'budget', label: 'budget'),
                      SortParam(field: 'currentBalance', label: 'spent')
                    ]));
          },
        ));
  }

  void _onCreate() {
    GoRouter.of(context).pushNamed('createAccountScreen');
  }

  Widget buildList() {
    return BlocBuilder<AccountsBloc, AccountState>(builder: (context, state) {
      return CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        controller: _scrollController,
        slivers: <Widget>[
          CupertinoSliverNavigationBar(
            backgroundColor: CupertinoColors.secondarySystemBackground,
            largeTitle: const Text('Accounts'),
            trailing: GestureDetector(
              onTap: _onCreate,
              child: const Icon(
                CupertinoIcons.add,
                color: CupertinoColors.black,
              ),
            ),
          ),
          CupertinoSliverRefreshControl(
            onRefresh: () async {
              context
                  .read<AccountsBloc>()
                  .add(const AccountEventGetListRequested(loadMore: false));
            },
          ),
          // if (state.error != null)
          //   Padding(
          //     padding: const EdgeInsets.all(8),
          //     child: Text(state.error!),
          //   ),
          // if (state.accounts.isEmpty && !state.fetching)
          //   Container(
          //     padding: EdgeInsets.all(16),
          //     child: Text('no accounts yet'),
          //   ),
          SliverList.separated(
            itemBuilder: (BuildContext context, int index) {
              var array = state.accounts;

              if (index == array.length) {
                return Visibility(
                    visible: state.fetching,
                    child: const Center(
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: CupertinoActivityIndicator(
                          radius: 16,
                        ),
                      ),
                    ));
              }

              var accountData = array[index];

              return AccountUI(
                  account: accountData,
                  onDelete: () =>
                      onDelete(id: accountData.id, name: accountData.name));
            },
            itemCount: (state.accounts.length + (state.fetching ? 1 : 0)),
            separatorBuilder: (BuildContext context, int index) => Container(
              height: 0,
              padding: const EdgeInsets.only(left: 16),
              child: const Divider(),
            ),
          ),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
        value: context.read<AccountsBloc>(),
        child: Container(
          child: buildList(),
        ));
  }
}
