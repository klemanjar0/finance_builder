import 'package:finance_builder/api/NetworkService.dart';
import 'package:finance_builder/bootstrap.dart';
import 'package:finance_builder/features/navigation/router.dart';
import 'package:finance_builder/features/user/bloc/user.api.dart';
import 'package:finance_builder/features/user/bloc/user.repository.dart';
import 'package:finance_builder/models/account/account.localStorageApi.dart';
import 'package:finance_builder/models/account/account.repository.dart';
import 'package:finance_builder/theme/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final networkService = NetworkService();

  final accountsApi = AccountLocalStorage(
    plugin: await SharedPreferences.getInstance(),
  );

  final userApi = UserNetworkApi(networkService: networkService);

  bootstrap(accountApi: accountsApi, userApi: userApi);
}

class MyApp extends StatelessWidget {
  final AccountRepository accountRepository;
  final UserRepository userRepository;
  const MyApp(
      {super.key,
      required this.accountRepository,
      required this.userRepository});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: accountRepository),
        RepositoryProvider.value(value: userRepository),
      ],
      child: MaterialApp.router(routerConfig: router, theme: themeData),
    );
  }
}
