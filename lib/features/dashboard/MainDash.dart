import 'package:finance_builder/features/accounts/bloc/accounts.bloc.dart';
import 'package:finance_builder/features/accounts/bloc/accounts.events.dart';
import 'package:finance_builder/features/accounts/bloc/accounts.state.dart';
import 'package:finance_builder/features/navigation/bottomNavBar.dart';
import 'package:finance_builder/utils/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pie_chart/pie_chart.dart';

import '../accounts/components/AccountsSection.dart';

class MainDash extends StatefulWidget {
  const MainDash({
    super.key,
  });

  @override
  MainDashState createState() => MainDashState();
}

class MainDashState extends State<MainDash> {
  @override
  void initState() {
    context.read<AccountsBloc>().add(const AccountEventSummaryRequested());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
        value: context.read<AccountsBloc>(),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: SafeArea(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(4.0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25.0),
                    color: Colors.lightGreenAccent,
                  ),
                  child: BlocBuilder<AccountsBloc, AccountState>(
                    builder: (context, state) {
                      if (state.summaryFetching) {
                        return CircularProgressIndicator();
                      }

                      if (state.summary == null) {
                        return Text(
                          'no data',
                          style: Theme.of(context)
                              .textTheme
                              .headlineLarge!
                              .apply(color: Theme.of(context).primaryColorDark),
                        );
                      }

                      return Text(
                        'spent this month ${state.summary!.totalSpentThisMonth}',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineLarge!.apply(
                            color: Theme.of(context).primaryColorDark,
                            fontWeightDelta: 3),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: EdgeInsets.all(8.0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25.0),
                    color: Colors.black,
                  ),
                  child: BlocBuilder<AccountsBloc, AccountState>(
                    builder: (context, state) {
                      if (state.summaryFetching || state.summary == null) {
                        return CircularProgressIndicator();
                      }

                      if (state.summary!.spentByType.isEmpty) {
                        return Text('no data yet');
                      }

                      return PieChart(
                        dataMap: state.summary!.spentByType,
                        chartType: ChartType.ring,
                        colorList: const [
                          Colors.lightGreenAccent,
                          Colors.lightGreen,
                          Colors.lime,
                          Colors.limeAccent,
                          Colors.grey,
                          Colors.white,
                        ],
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
