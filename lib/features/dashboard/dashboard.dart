import 'package:finance_builder/features/dashboard/pages/accounts.dart';
import 'package:finance_builder/features/navigation/bottomNavBar.dart';
import 'package:finance_builder/utils/utility.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

Widget getContentByTab(DashboardBottomTab tab) {
  switch (tab) {
    case DashboardBottomTab.home:
      return const Text(
        'Home',
      );
    case DashboardBottomTab.accounts:
      return AccountsPage();
    case DashboardBottomTab.settings:
      return const Text(
        'Settings',
      );
  }
}

class Dashboard extends StatefulWidget {
  final String title;
  const Dashboard({super.key, required this.title});

  @override
  DashboardState createState() => DashboardState();
}

class DashboardState extends State<Dashboard> {
  DashboardBottomTab _currentTab = DashboardBottomTab.home;

  void onIndexChanged(DashboardBottomTab tab) {
    setState(() {
      _currentTab = tab;
    });
  }

  Widget? renderFloatingActionButton(BuildContext context) {
    if (_currentTab == DashboardBottomTab.accounts) {
      return FloatingActionButton.extended(
        onPressed: () {
          context.go('/createAccountScreen');
        },
        backgroundColor: Colors.lightGreenAccent,
        foregroundColor: Colors.black,
        icon: const Icon(Icons.add),
        label: const Text('New Account'),
      );
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        backgroundColor: Colors.white24,
        title: Text(widget.title),
      ),
      body: Center(child: getContentByTab(_currentTab)),
      bottomNavigationBar: BottomNavBar(onIndexChanged: onIndexChanged),
      floatingActionButton: renderFloatingActionButton(context),
    );
  }
}
