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
    return BlocProvider(
        create: (_) => UserBloc(
              userRepository: context.read<UserRepository>(),
            ),
        child: BlocBuilder<UserBloc, UserState>(builder: (context, state) {
          return BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Dashboard',
                backgroundColor: Colors.grey,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.account_balance_wallet),
                label: 'Accounts',
                backgroundColor: Colors.grey,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: 'Settings',
                backgroundColor: Colors.grey,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.logout),
                label: 'Log Out',
                backgroundColor: Colors.grey,
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.black,
            onTap: _onItemTapped(context),
          );
        }));
  }
}
