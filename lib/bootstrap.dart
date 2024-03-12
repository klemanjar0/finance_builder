import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:finance_builder/models/account/account.api.dart';
import 'package:finance_builder/models/account/account.repository.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void bootstrap({required AccountApi accountApi}) {
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  Bloc.observer = const AppBlocObserver();

  final accountRepository = AccountRepository(accountApi: accountApi);

  runZonedGuarded(
    () => runApp(App(accountRepository: accountRepository)),
    (error, stackTrace) => log(error.toString(), stackTrace: stackTrace),
  );
}
