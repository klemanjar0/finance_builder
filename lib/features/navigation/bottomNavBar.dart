import 'package:finance_builder/api/AutoLogoutService.dart';
import 'package:finance_builder/features/user/bloc/user.bloc.dart';
import 'package:finance_builder/features/user/bloc/user.repository.dart';
import 'package:finance_builder/features/user/bloc/user.state.dart';
import 'package:finance_builder/utils/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class BottomNavBar extends StatefulWidget {
  final Function(DashboardBottomTab) onIndexChanged;
  const BottomNavBar({super.key, required this.onIndexChanged});

  @override
  BottomNavBarState createState() => BottomNavBarState();
}

class BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;

  void logOut(BuildContext context) {
    context.read<UserBloc>().add(const UserEventSignOutRequested());
    GoRouter.of(context).pushReplacementNamed('splash');
  }

  void Function(int) _onItemTapped(BuildContext context) {
    return (int index) {
      if (index == 3) {
        logOut(context);
      }

      setState(() {
        _selectedIndex = index;
        widget.onIndexChanged(getDashboardBottomTabByIndex(index));
      });
    };
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
        value: context.read<UserBloc>(),
        child: BlocBuilder<UserBloc, UserState>(builder: (context, state) {
          return BottomNavigationBar(
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: const Icon(Icons.home_outlined),
                activeIcon: const Icon(Icons.home),
                label: 'dashboard',
                backgroundColor: Theme.of(context).colorScheme.background,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.account_balance_wallet_outlined),
                activeIcon: const Icon(Icons.account_balance_wallet),
                label: 'accounts',
                backgroundColor: Theme.of(context).colorScheme.background,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.settings_outlined),
                activeIcon: const Icon(Icons.settings),
                label: 'settings',
                backgroundColor: Theme.of(context).colorScheme.background,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.logout),
                label: 'log Out',
                backgroundColor: Theme.of(context).colorScheme.background,
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Theme.of(context).colorScheme.primary,
            unselectedItemColor: Theme.of(context).colorScheme.inversePrimary,
            onTap: _onItemTapped(context),
          );
        }));
  }
}
