import 'package:finance_builder/features/account/accountDetailsScreen/account_details_screen.dart';
import 'package:finance_builder/features/account/createAccountScreen/create_account_screen.dart';
import 'package:finance_builder/features/dashboard/dashboard.dart';
import 'package:finance_builder/utils/constants.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
        path: '/',
        builder: (context, state) => Dashboard(
              title: constants.screenNames.home,
            ),
        routes: [
          GoRoute(
            path: 'createAccountScreen',
            builder: (context, state) => CreateAccountScreen(
              title: constants.screenNames.createAccount,
            ),
          ),
          GoRoute(
            path: 'account/:id',
            name: 'account',
            builder: (context, state) => AccountDetailsScreen(
              id: state.pathParameters['id'],
            ),
          ),
        ]),
  ],
);
