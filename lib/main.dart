import 'package:finance_builder/features/navigation/router.dart';
import 'package:finance_builder/models/account/account.localStorageApi.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  runApp(const MyApp());

  final accountsApi = AccountLocalStorage(
    plugin: await SharedPreferences.getInstance(),
  );

  bootstrap(accountsApi: accountsApi);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(routerConfig: router);
  }
}
