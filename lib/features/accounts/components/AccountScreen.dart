import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:finance_builder/features/accounts/bloc/accounts.bloc.dart';
import 'package:finance_builder/features/accounts/bloc/accounts.events.dart';
import 'package:finance_builder/features/accounts/bloc/accounts.models.dart';
import 'package:finance_builder/features/accounts/bloc/accounts.state.dart';
import 'package:finance_builder/features/accounts/bloc/types.dart';
import 'package:finance_builder/features/accounts/components/TransactionItem.dart';
import 'package:finance_builder/theme/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:countup/countup.dart';
import 'package:intl/intl.dart';

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
  ScrollController _scrollController = ScrollController();
  double _scrollPosition = 0;

  _scrollListener() {
    setState(() {
      _scrollPosition = _scrollController.position.pixels;
    });
  }

  @override
  void initState() {
    context.read<AccountsBloc>().add(AccountEventGetSingleAccountRequested(
        payload: GetSingleAccountRequestPayload(id: widget.id)));
    _scrollController.addListener(_scrollListener);
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

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('manage account'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextButton(
                  onPressed: () {},
                  child: Text('edit account metadata.',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .apply(color: Theme.of(context).colorScheme.primary)),
                ),
                const Divider(),
                TextButton(
                    onPressed: () {},
                    child: Text('delete account.',
                        style: Theme.of(context).textTheme.bodyMedium!.apply(
                            color: Theme.of(context).colorScheme.error))),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _renderHeader(bool? showTitle, String? title) {
    return Row(
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
        if (showTitle == true)
          Expanded(
            child: Text(
              title ?? '',
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleMedium?.apply(
                  fontSizeDelta: 4, fontWeightDelta: 3, color: Colors.white),
            ),
          ),
        BlocBuilder<AccountsBloc, AccountState>(builder: (context, state) {
          return GestureDetector(
            child: Container(
              margin: EdgeInsets.all(16),
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100.0),
                color: state.singleFetching
                    ? Colors.transparent
                    : Theme.of(context).primaryColorDark,
              ),
              child: state.singleFetching
                  ? CircularProgressIndicator(
                      color: Theme.of(context).primaryColorDark,
                    )
                  : const Center(
                      child: Icon(
                        Icons.apps_rounded,
                        size: 32,
                      ),
                    ),
            ),
            onTap: () {
              _showMyDialog();
            },
          );
        }),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final safePadding = MediaQuery.of(context).padding.top;
    final safePaddingBot = MediaQuery.of(context).padding.top;
    final double value =
        _scrollPosition > 140 ? _scrollPosition + safePadding : -100.0;
    return BlocProvider.value(
        value: context.read<AccountsBloc>(),
        child: BlocListener<AccountsBloc, AccountState>(
          listener: _onBlocListen,
          child: Scaffold(
            body: SingleChildScrollView(
                controller: _scrollController,
                child: Stack(
                  children: [
                    Column(
                      children: [
                        SizedBox(
                          height: safePadding,
                        ),
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
                                _renderHeader(false, null),
                                Expanded(
                                    child: Container(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 8),
                                    child:
                                        BlocBuilder<AccountsBloc, AccountState>(
                                            builder: (context, state) {
                                      return Text(
                                        state.singleFetching
                                            ? "Loading..."
                                            : state.single?.name ??
                                                'Failed to load',
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
                                    child:
                                        BlocBuilder<AccountsBloc, AccountState>(
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Row(
                                      children: [
                                        Padding(
                                            padding: EdgeInsets.only(
                                                left: 16, right: 4),
                                            child: Countup(
                                              begin: 0,
                                              end:
                                                  percent, //here you insert the number or its variable
                                              duration: const Duration(
                                                  milliseconds: 450),
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
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 16),
                                      child: Text(
                                        'spent of plan expenses',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium
                                            ?.apply(
                                              color: Theme.of(context)
                                                  .primaryColorDark,
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
                                return AnimatedTextKit(
                                  animatedTexts: [
                                    TypewriterAnimatedText(
                                      'loading...',
                                      textStyle: TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context)
                                              .primaryColorDark),
                                      speed: const Duration(milliseconds: 150),
                                    ),
                                  ],
                                  repeatForever: true,
                                  pause: const Duration(milliseconds: 75),
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
                                          color: Theme.of(context)
                                              .primaryColorDark,
                                        ),
                                  ),
                                  Text(
                                    '${state.single?.currentBalance.toInt()}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.apply(
                                            color: Theme.of(context)
                                                .primaryColorDark,
                                            fontWeightDelta: 3),
                                  ),
                                  Text(
                                    ' of total budget ${state.single?.budget.toInt()}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.apply(
                                          color: Theme.of(context)
                                              .primaryColorDark,
                                        ),
                                  )
                                ],
                              );
                            },
                          ),
                        ),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'expenses history',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineLarge
                                    ?.apply(
                                        color: Colors.white,
                                        fontWeightDelta: 2),
                              ),
                              TextButton(
                                  onPressed: () {
                                    GoRouter.of(context).pushNamed(
                                        'createTransactionScreen',
                                        pathParameters: {'id': widget.id});
                                  },
                                  child: const Icon(
                                    Icons.add,
                                    color: Colors.white,
                                    size: 32,
                                  )),
                            ],
                          ),
                        ),
                        BlocBuilder<AccountsBloc, AccountState>(
                            builder: (context, state) {
                          if (state.singleFetching == true) {
                            return const CircularProgressIndicator();
                          }
                          if (state.single == null) {
                            return const Text('no expenses yet');
                          }
                          return Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                            child: Column(
                              children: [
                                for (var i = 0;
                                    i < state.single!.transactions.length;
                                    i++)
                                  Column(
                                    children: [
                                      TransactionUI(
                                          transaction:
                                              state.single!.transactions[i],
                                          onDelete: () {}),
                                      i == state.single!.transactions.length - 1
                                          ? SizedBox()
                                          : Divider()
                                    ],
                                  ),
                              ],
                            ),
                          );
                        }),
                        SizedBox(
                          height: safePaddingBot,
                        ),
                      ],
                    ),
                    BlocBuilder<AccountsBloc, AccountState>(
                        builder: (context, state) {
                      return AnimatedPositioned(
                        top: value - 950,
                        right: 0,
                        left: 0,
                        duration: const Duration(milliseconds: 150),
                        child: Container(
                          height: 1000,
                          alignment: Alignment.bottomCenter,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(32.0),
                                bottomRight: Radius.circular(32.0)),
                            color: Colors.black,
                          ),
                          child: _renderHeader(true, state.single?.name),
                        ),
                      );
                    }),
                  ],
                )),
          ),
        ));
  }
}
