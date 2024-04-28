import 'package:finance_builder/components/SortingBottomSheet/SortingBottomSheet.dart';
import 'package:finance_builder/features/accounts/bloc/accounts.models.dart';
import 'package:finance_builder/features/accounts/bloc/types.dart';
import 'package:finance_builder/features/accounts/components/AccountItem.dart';
import 'package:finance_builder/helpers/mixins/InfiniteScrollMixin.dart';
import 'package:finance_builder/theme/index.dart';
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

var sortOptions = const [
  SortParam(field: 'name', label: 'Name'),
  SortParam(field: 'description', label: 'Description'),
  SortParam(field: 'budget', label: 'Budget'),
  SortParam(field: 'currentBalance', label: 'Spent')
];

String getLabelByValue(String value) {
  return sortOptions.firstWhere((element) => element.field == value).label;
}

class AccountsSectionState extends State<AccountsSection>
    with InfiniteScrollMixin {
  @override
  void initState() {
    super.initState();

    initInfiniteScroll(() {
      context.read<AccountsBloc>().add(const AccountEventGetListRequested(
          loadMore: true, autoTriggered: false));
    });

    context.read<AccountsBloc>().add(const AccountEventGetListRequested(
        loadMore: false, autoTriggered: false));
  }

  @override
  void dispose() {
    disposeInfiniteScroll();
    super.dispose();
  }

  void onDelete({required String id, required String name}) {
    context.read<AccountsBloc>().add(AccountEventDeleteRequested(
        payload: AccountsRemoveRequestPayload(id: id)));
    // implement
  }

  Widget errorGuard(AccountState state) {
    if (state.error != null) {
      return Center(
        child: Text('${state.error}'),
      );
    }

    if (!state.fetching && state.accounts.isEmpty) {
      return const Center(
        child: Text('No Data Found!'),
      );
    }

    return Container();
  }

  Future<void> onRefresh() {
    context
        .read<AccountsBloc>()
        .add(const AccountEventGetListRequested(loadMore: false));
    return Future(() => null);
  }

  Widget _renderSort(AccountState state) {
    return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: CupertinoButton(
          color: Theme.of(context).lavender,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Sort By ${getLabelByValue(state.sortOption.field)}',
                style: TextStyle(color: CupertinoColors.systemBlue),
              ),
              const SizedBox(width: 4),
              state.sortOption.direction == SortDirection.asc
                  ? const Icon(
                      Icons.arrow_upward,
                      color: CupertinoColors.systemBlue,
                      size: 20,
                    )
                  : const Icon(Icons.arrow_downward,
                      color: CupertinoColors.systemBlue, size: 20),
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
                    options: sortOptions));
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
        controller: infiniteScrollController,
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
            onRefresh: onRefresh,
          ),
          SliverList.builder(
            itemBuilder: (BuildContext context, int index) {
              return _renderSort(state);
            },
            itemCount: 1,
          ),
          SliverList.builder(
            itemBuilder: (BuildContext context, int index) {
              return errorGuard(state);
            },
            itemCount: 1,
          ),
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
