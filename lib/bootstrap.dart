import 'dart:async';
import 'dart:developer';

import 'package:finance_builder/api/AutoLogoutService.dart';
import 'package:finance_builder/features/user/bloc/user.api.dart';
import 'package:finance_builder/features/user/bloc/user.repository.dart';
import 'package:flutter/foundation.dart';
import 'package:finance_builder/bloc/AppBlocObserver.dart';
import 'package:finance_builder/main.dart';
import 'package:flutter/widgets.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

import 'features/accounts/bloc/accounts.api.dart';
import 'features/accounts/bloc/accounts.repository.dart';

void bootstrap(
    {required AccountApi accountApi,
    required UserApi userApi,
    required AutoLogoutService autoLogoutService}) async {
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  WidgetsFlutterBinding.ensureInitialized();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorage.webStorageDirectory
        : await getApplicationDocumentsDirectory(),
  );

  Bloc.observer = AppBlocObserver();

  final accountRepository = AccountsRepository(accountApi: accountApi);
  final userRepository = UserRepository(userApi: userApi);

  runZonedGuarded(
    () => runApp(MyApp(
        accountRepository: accountRepository,
        userRepository: userRepository,
        autoLogoutService: autoLogoutService)),
    (error, stackTrace) => log(error.toString(), stackTrace: stackTrace),
  );
}
