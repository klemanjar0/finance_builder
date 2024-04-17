import 'package:finance_builder/features/dashboard/MainDash.dart';
import 'package:finance_builder/features/navigation/bottomNavBar.dart';
import 'package:finance_builder/features/user/bloc/user.bloc.dart';
import 'package:finance_builder/utils/utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../accounts/components/AccountsSection.dart';

Widget getContentByTab(DashboardBottomTab tab, void Function() onLogout) {
  switch (tab) {
    case DashboardBottomTab.home:
      return MainDash();
    case DashboardBottomTab.accounts:
      return AccountsSection();
    case DashboardBottomTab.settings:
      return Center(
          child: CupertinoButton(child: Text('Log out'), onPressed: onLogout));
  }
}

class Dashboard extends StatefulWidget {
  final String title;
  const Dashboard({super.key, required this.title});

  @override
  DashboardState createState() => DashboardState();
}

class DashboardState extends State<Dashboard> {
  // Widget? renderFloatingActionButton(BuildContext context) {
  //   if (_currentTab == DashboardBottomTab.accounts) {
  //     return FloatingActionButton.extended(
  //       onPressed: () {
  //         GoRouter.of(context).pushNamed('createAccountScreen');
  //       },
  //       backgroundColor: Colors.lightGreenAccent,
  //       foregroundColor: Colors.black,
  //       icon: const Icon(Icons.add),
  //       label: const Text('New Account'),
  //     );
  //   }
  //
  //   return null;
  // }

  //var a = Center(child: getContentByTab(_currentTab));

  DashboardBottomTab _getTabByIndex(int index) {
    return switch (index) {
      0 => DashboardBottomTab.home,
      1 => DashboardBottomTab.accounts,
      2 => DashboardBottomTab.settings,
      3 => DashboardBottomTab.settings,
      _ => DashboardBottomTab.home,
    };
  }

  void _logOut() {
    context.read<UserBloc>().add(const UserEventSignOutRequested());
    GoRouter.of(context).pushNamed('splash');
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
        tabBar: CupertinoTabBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.money_dollar_circle_fill),
              label: 'Accounts',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.settings),
              label: 'Settings',
            ),
          ],
        ),
        tabBuilder: (BuildContext context, int index) {
          return CupertinoTabView(builder: (BuildContext context) {
            return CupertinoPageScaffold(
              navigationBar: index == 1
                  ? null
                  : const CupertinoNavigationBar(
                      middle: Text('Finance Builder'),
                    ),
              child: SafeArea(
                child: Center(
                    child: getContentByTab(_getTabByIndex(index), _logOut)),
              ),
            );
          });
        });
  }
}
