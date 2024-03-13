import 'package:finance_builder/bootstrap.dart';
import 'package:finance_builder/features/navigation/router.dart';
import 'package:finance_builder/models/account/account.localStorageApi.dart';
import 'package:finance_builder/models/account/account.repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final accountsApi = AccountLocalStorage(
    plugin: await SharedPreferences.getInstance(),
  );

  bootstrap(accountApi: accountsApi);
}

class MyApp extends StatelessWidget {
  final AccountRepository accountRepository;
  const MyApp({super.key, required this.accountRepository});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: accountRepository,
      child: MaterialApp.router(routerConfig: router),
    );
  }
}
