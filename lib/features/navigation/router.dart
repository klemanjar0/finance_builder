import 'package:finance_builder/features/accounts/components/AccountScreen.dart';
import 'package:finance_builder/features/accounts/screens/CreateTransactionScreen.dart';
import 'package:finance_builder/features/auth/screens/sign_screen/SignScreen.dart';
import 'package:finance_builder/features/dashboard/dashboard.dart';
import 'package:finance_builder/features/splash/screens/SplashScreen.dart';
import 'package:finance_builder/main.dart';
import 'package:finance_builder/utils/constants.dart';
import 'package:go_router/go_router.dart';

import '../accounts/screens/CreateAccountScreen.dart';
import '../auth/screens/sign_up/SignUpScreen.dart';

final router = GoRouter(
  navigatorKey: navigatorKey,
  debugLogDiagnostics: true,
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      name: 'splash',
      builder: (context, state) => const SplashScreen(
        title: '',
      ),
    ),
    GoRoute(
        path: '/sign', name: 'sign', builder: (context, state) => SignScreen()),
    GoRoute(
        path: '/sign_up',
        name: 'sign_up',
        builder: (context, state) => SignUpScreen()),
    GoRoute(
        path: '/',
        name: 'dashboard',
        builder: (context, state) => Dashboard(
              title: constants.screenNames.home,
            ),
        routes: [
          GoRoute(
            path: 'dashboard/createAccountScreen',
            name: 'createAccountScreen',
            builder: (context, state) => CreateAccountScreen(),
          ),
          GoRoute(
            path: 'dashboard/account/:id',
            name: 'accountDetails',
            builder: (context, state) =>
                AccountScreen(id: state.pathParameters['id']!),
          ),
          GoRoute(
              path: 'dashboard/createTransactionScreen/:id',
              name: 'createTransactionScreen',
              builder: (context, state) =>
                  CreateTransactionScreen(id: state.pathParameters['id']!))
        ]),
  ],
);
