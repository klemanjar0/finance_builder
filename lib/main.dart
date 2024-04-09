import 'package:finance_builder/api/AutoLogoutService.dart';
import 'package:finance_builder/api/NetworkService.dart';
import 'package:finance_builder/bootstrap.dart';
import 'package:finance_builder/features/accounts/bloc/accounts.api.dart';
import 'package:finance_builder/features/navigation/router.dart';
import 'package:finance_builder/features/user/bloc/user.api.dart';
import 'package:finance_builder/features/user/bloc/user.bloc.dart';
import 'package:finance_builder/features/user/bloc/user.repository.dart';
import 'package:finance_builder/theme/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/accounts/bloc/accounts.repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final autoLogoutService = AutoLogoutService();
  final networkService = NetworkService(autoLogoutService: autoLogoutService);

  final userApi = UserNetworkApi(networkService: networkService);
  final accountsApi = AccountNetworkApi(networkService: networkService);

  bootstrap(
      accountApi: accountsApi,
      userApi: userApi,
      autoLogoutService: autoLogoutService);
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  final AccountsRepository accountRepository;
  final UserRepository userRepository;
  final AutoLogoutService autoLogoutService;

  const MyApp(
      {super.key,
      required this.accountRepository,
      required this.userRepository,
      required this.autoLogoutService});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: accountRepository),
        RepositoryProvider.value(value: userRepository),
        RepositoryProvider.value(value: autoLogoutService),
      ],
      child: BlocProvider(
          create: (_) => UserBloc(
                userRepository: context.read<UserRepository>(),
                autoLogoutService: context.read<AutoLogoutService>(),
              ),
          child: MaterialApp.router(routerConfig: router, theme: themeData)),
    );
  }
}
