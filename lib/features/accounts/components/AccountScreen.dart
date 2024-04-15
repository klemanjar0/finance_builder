import 'package:finance_builder/features/accounts/bloc/accounts.bloc.dart';
import 'package:finance_builder/features/accounts/bloc/accounts.events.dart';
import 'package:finance_builder/features/accounts/bloc/accounts.models.dart';
import 'package:finance_builder/features/accounts/bloc/accounts.state.dart';
import 'package:finance_builder/features/accounts/bloc/types.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:countup/countup.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key, required this.id});

  final String id;

  @override
  AccountScreenState createState() => AccountScreenState();
}

class AccountScreenState extends State<AccountScreen>
    with TickerProviderStateMixin {
  late AnimationController controller;
  double percent = 0;

  @override
  void initState() {
    controller = AnimationController(
        vsync: this, animationBehavior: AnimationBehavior.normal)
      ..addListener(() {
        setState(() {});
      });

    setState(() {
      controller.value = 0;
    });
    super.initState();
  }

  (double, bool) percentData(
      {required double budget, required double currentBalance}) {
    if (currentBalance > budget) {
      return (1, true);
    }

    var value = currentBalance / budget;
    return (value, false);
  }

  void setProgress(Account account) {
    var data = percentData(
        budget: account.budget, currentBalance: account.currentBalance);

    controller.value = data.$1;
  }

  void onBack(BuildContext context) {
    context.read<AccountsBloc>().add(const AccountEventResetSingleAccount());
    GoRouter.of(context).pop();
  }

  void _onBlocListen(BuildContext context, AccountState state) {
    if (state.singleError != null) {
      GoRouter.of(context).pop();
      context.read<AccountsBloc>().add(const AccountEventResetAccountError());
    }

    if (state.single != null) {
      setState(() {
        var data = percentData(
            budget: state.single!.budget,
            currentBalance: state.single!.currentBalance);

        controller.value = data.$1;
        percent = data.$1 * 100;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
        value: context.read<AccountsBloc>()
          ..add(AccountEventGetSingleAccountRequested(
              payload: GetSingleAccountRequestPayload(id: widget.id))),
        child: BlocListener<AccountsBloc, AccountState>(
          listener: _onBlocListen,
          child: Scaffold(
            body: SafeArea(
                child: SingleChildScrollView(
              child: Column(
                children: [
                  AspectRatio(
                    aspectRatio: 1,
                    child: Container(
                      margin: EdgeInsets.all(16),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(32.0),
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GestureDetector(
                                child: Container(
                                  margin: EdgeInsets.all(16),
                                  width: 48,
                                  height: 48,
                                  child: Center(
                                    child: Icon(
                                      Icons.chevron_left,
                                      size: 32,
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100.0),
                                    color: Theme.of(context).primaryColorDark,
                                  ),
                                ),
                                onTap: () {
                                  onBack(context);
                                },
                              ),
                              BlocBuilder<AccountsBloc, AccountState>(
                                  builder: (context, state) {
                                if (state.singleFetching) {
                                  return CircularProgressIndicator(
                                    color: Theme.of(context).primaryColorDark,
                                  );
                                }

                                return const SizedBox(width: 0, height: 0);
                              }),
                              GestureDetector(
                                child: Container(
                                  margin: EdgeInsets.all(16),
                                  width: 48,
                                  height: 48,
                                  child: const Center(
                                    child: Icon(
                                      Icons.apps_rounded,
                                      size: 32,
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100.0),
                                    color: Theme.of(context).primaryColorDark,
                                  ),
                                ),
                                onTap: () {
                                  onBack(context);
                                },
                              )
                            ],
                          ),
                          Expanded(
                              child: Container(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              child: BlocBuilder<AccountsBloc, AccountState>(
                                  builder: (context, state) {
                                return Text(
                                  state.singleFetching
                                      ? "Loading..."
                                      : state.single?.name ?? 'Failed to load',
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.apply(
                                          color: Theme.of(context)
                                              .primaryColorDark,
                                          fontWeightDelta: 4),
                                );
                              }),
                            ),
                          )),
                          Flexible(
                              child: Container(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              child: BlocBuilder<AccountsBloc, AccountState>(
                                  builder: (context, state) {
                                return SingleChildScrollView(
                                  child: Text(
                                    state.singleFetching
                                        ? "Loading..."
                                        : state.single?.description ??
                                            'Failed to load description',
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.apply(
                                          color: Theme.of(context)
                                              .primaryColorDark,
                                        ),
                                  ),
                                );
                              }),
                            ),
                          )),
                          Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                children: [
                                  Padding(
                                      padding:
                                          EdgeInsets.only(left: 16, right: 4),
                                      child: Countup(
                                        begin: 0,
                                        end:
                                            percent, //here you insert the number or its variable
                                        duration:
                                            const Duration(milliseconds: 450),
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge
                                            ?.apply(
                                                fontSizeDelta: 4,
                                                fontWeightDelta: 3,
                                                color: Theme.of(context)
                                                    .primaryColorDark),
                                      )),
                                  Text(
                                    '%',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.apply(
                                            fontSizeDelta: 4,
                                            fontWeightDelta: 3,
                                            color: Theme.of(context)
                                                .primaryColorDark),
                                  )
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Text(
                                  'spent of plan expenses',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.apply(
                                        color:
                                            Theme.of(context).primaryColorDark,
                                      ),
                                ),
                              )
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.all(8.0),
                            width: double.infinity,
                            child: TweenAnimationBuilder<double>(
                              duration: const Duration(milliseconds: 450),
                              curve: Curves.easeInOut,
                              tween: Tween<double>(
                                begin: 0,
                                end: controller.value,
                              ),
                              builder: (context, value, _) =>
                                  LinearProgressIndicator(
                                value: value,
                                borderRadius: BorderRadius.circular(32.0),
                                backgroundColor:
                                    Theme.of(context).disabledColor,
                                color: Theme.of(context).primaryColorDark,
                                minHeight: 64,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    margin: EdgeInsets.all(16),
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32.0),
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    child: BlocBuilder<AccountsBloc, AccountState>(
                      builder: (context, state) {
                        if (state.singleFetching) {
                          return CircularProgressIndicator(
                            color: Theme.of(context).primaryColorDark,
                          );
                        }

                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'spent ',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.apply(
                                    color: Theme.of(context).primaryColorDark,
                                  ),
                            ),
                            Text(
                              '${state.single?.currentBalance.toInt()}',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.apply(
                                      color: Theme.of(context).primaryColorDark,
                                      fontWeightDelta: 3),
                            ),
                            Text(
                              ' of total budget ${state.single?.budget.toInt()}',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.apply(
                                    color: Theme.of(context).primaryColorDark,
                                  ),
                            )
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            )),
          ),
        ));
  }
}
